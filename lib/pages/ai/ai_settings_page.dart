import 'package:beecount/pages/ai/ai_model_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/ui/ui.dart';
import '../../widgets/biz/section_card.dart';
import '../../styles/tokens.dart';
import '../../utils/ui_scale_extensions.dart';
import '../../providers/theme_providers.dart';
import '../../providers/ui_state_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../services/ai/ai_chat_service.dart';
import '../../services/ai/ai_constants.dart';
import 'ai_prompt_edit_page.dart';

/// AI智能识别设置页面
class AISettingsPage extends ConsumerStatefulWidget {
  const AISettingsPage({super.key});

  @override
  ConsumerState<AISettingsPage> createState() => _AISettingsPageState();
}

class _AISettingsPageState extends ConsumerState<AISettingsPage> {
  String _strategy = 'local_first';
  String _glmApiKey = '';
  bool _aiEnabled = false; // AI增强开关
  bool _useVision = true; // 使用视觉模型开关（默认打开）
  bool _loading = true;
  bool _testing = false; // 是否正在测试

  late final TextEditingController _apiKeyController;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString(AIConstants.keyGlmApiKey) ?? '';

    setState(() {
      _strategy = prefs.getString(AIConstants.keyAiStrategy) ?? AIConstants.defaultStrategy;
      _glmApiKey = apiKey;
      _apiKeyController.text = apiKey;
      _aiEnabled = prefs.getBool(AIConstants.keyAiBillExtractionEnabled) ?? false;
      _useVision = prefs.getBool(AIConstants.keyAiUseVision) ?? true; // 默认打开
      _loading = false;
    });
  }


  Future<void> _openGlmWebsite() async {
    final uri = Uri.parse('https://open.bigmodel.cn/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// 测试API Key是否有效（自动先保存）
  Future<void> _saveAndTestApiKey() async {
    if (_glmApiKey.isEmpty) {
      return;
    }

    setState(() {
      _testing = true;
    });

    // 先保存
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AIConstants.keyGlmApiKey, _glmApiKey);

    // 再测试
    final result = await AIChatService.validateApiKey();

    setState(() {
      _testing = false;
    });

    if (mounted) {
      if (result.isValid) {
        showToast(context, AppLocalizations.of(context).aiCloudApiKeyValid);
      } else {
        showToast(context, AppLocalizations.of(context).aiCloudApiKeyInvalid);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        backgroundColor: BeeTokens.scaffoldBackground(context),
        body: Column(
          children: [
            PrimaryHeader(
              title: l10n.aiSettingsTitle,
              showBack: true,
            ),
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: BeeTokens.scaffoldBackground(context),
      body: Column(
        children: [
          PrimaryHeader(
            title: l10n.aiSettingsTitle,
            subtitle: l10n.aiSettingsSubtitle,
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0.scaled(context, ref),
                vertical: 8.0.scaled(context, ref),
              ),
              children: [
                // AI增强开关
                _buildEnableSection(),

                SizedBox(height: 8.0.scaled(context, ref)),

                // 执行策略
                _buildStrategySection(),

                SizedBox(height: 8.0.scaled(context, ref)),

                // 云端API配置
                _buildCloudApiSection(),

                SizedBox(height: 8.0.scaled(context, ref)),

                // 本地模型管理
                _buildLocalModelSection(),

                SizedBox(height: 8.0.scaled(context, ref)),

                // 高级设置（提示词编辑）
                _buildAdvancedSection(),

                // 底部安全区域
                SizedBox(height: 32.0.scaled(context, ref)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildEnableSection() {
    final l10n = AppLocalizations.of(context);

    return SectionCard(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            value: _aiEnabled,
            onChanged: (value) async {
              setState(() => _aiEnabled = value);

              // 使用setter保存并通知所有监听者
              final setter = ref.read(aiAssistantSetterProvider);
              await setter.setEnabled(value);

              // Invalidate provider以触发重新加载
              ref.invalidate(aiAssistantEnabledProvider);

              if (mounted) {
                showToast(context, value ? l10n.aiEnableToastOn : l10n.aiEnableToastOff);
              }
            },
            title: Text(
              l10n.aiEnableTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(l10n.aiEnableSubtitle),
            activeColor: ref.watch(primaryColorProvider),
          ),

          // 上传图片到AI开关
          BeeTokens.cardDivider(context),
          SwitchListTile(
            value: _useVision,
            onChanged: _aiEnabled ? (value) async {
              setState(() => _useVision = value);

              // 立即保存Vision开关状态
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool(AIConstants.keyAiUseVision, value);

              if (mounted) {
                showToast(
                  context,
                  value ? l10n.aiUsingVisionDesc : l10n.aiUnUsingVisionDesc,
                );
              }
            } : null,
            title: Text(
              l10n.aiUploadImage,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              _useVision
                  ? l10n.aiUseVisionDesc
                  : l10n.aiUnUseVisionDesc
            ),
            activeColor: ref.watch(primaryColorProvider),
          ),
        ],
      ),
    );
  }

  /// 获取当前策略的显示名称
  String _getStrategyDisplayName(AppLocalizations l10n) {
    switch (_strategy) {
      case 'local_first':
        return l10n.aiStrategyLocalFirst;
      case 'cloud_first':
        return l10n.aiStrategyCloudFirst;
      case 'local_only':
        return l10n.aiStrategyLocalOnly;
      case 'cloud_only':
        return l10n.aiStrategyCloudOnly;
      default:
        return l10n.aiStrategyCloudFirst;
    }
  }

  /// 显示策略选择弹窗
  void _showStrategyDialog() {
    final l10n = AppLocalizations.of(context);
    final primaryColor = ref.read(primaryColorProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.aiStrategyTitle),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStrategyDialogOption(
              context,
              'cloud_first',
              l10n.aiStrategyCloudFirst,
              l10n.aiStrategyCloudFirstDesc,
              Icons.cloud,
              primaryColor,
              enabled: true,
            ),
            _buildStrategyDialogOption(
              context,
              'cloud_only',
              l10n.aiStrategyCloudOnly,
              l10n.aiStrategyCloudOnlyDesc,
              Icons.cloud_done,
              primaryColor,
              enabled: true,
            ),
            _buildStrategyDialogOption(
              context,
              'local_first',
              l10n.aiStrategyLocalFirst,
              l10n.aiStrategyLocalFirstDesc,
              Icons.phone_android,
              primaryColor,
              enabled: false, // 本地模型训练中
            ),
            _buildStrategyDialogOption(
              context,
              'local_only',
              l10n.aiStrategyLocalOnly,
              l10n.aiStrategyLocalOnlyDesc,
              Icons.offline_bolt,
              primaryColor,
              enabled: false, // 本地模型训练中
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyDialogOption(
    BuildContext dialogContext,
    String value,
    String title,
    String subtitle,
    IconData icon,
    Color primaryColor, {
    bool enabled = true,
  }) {
    final l10n = AppLocalizations.of(context);
    final isSelected = _strategy == value;
    final displaySubtitle = enabled ? subtitle : l10n.aiStrategyUnavailable;

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ListTile(
        leading: Icon(
          icon,
          color: enabled && isSelected ? primaryColor : BeeTokens.textTertiary(context),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: enabled && isSelected ? primaryColor : BeeTokens.textPrimary(context),
          ),
        ),
        subtitle: Text(
          displaySubtitle,
          style: TextStyle(
            fontSize: 12,
            color: enabled ? BeeTokens.textSecondary(context) : Colors.orange[700],
            fontStyle: enabled ? FontStyle.normal : FontStyle.italic,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: primaryColor)
            : null,
        onTap: enabled
            ? () async {
                // 先关闭弹窗
                Navigator.pop(dialogContext);

                setState(() => _strategy = value);

                // 立即保存执行策略
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString(AIConstants.keyAiStrategy, value);

                if (mounted) {
                  showToast(context, l10n.aiStrategySwitched(title));
                }
              }
            : null,
      ),
    );
  }

  Widget _buildStrategySection() {
    final l10n = AppLocalizations.of(context);

    return SectionCard(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(
          Icons.auto_awesome,
          color: ref.watch(primaryColorProvider),
        ),
        title: Text(
          l10n.aiStrategyTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(_getStrategyDisplayName(l10n)),
        trailing: const Icon(Icons.chevron_right),
        onTap: _showStrategyDialog,
      ),
    );
  }

  Widget _buildCloudApiSection() {
    final l10n = AppLocalizations.of(context);

    return SectionCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.cloud_outlined,
                  size: 20,
                  color: ref.watch(primaryColorProvider),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.aiCloudApiTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // 测试连接按钮（自动保存）
                TextButton.icon(
                  onPressed: _testing || _glmApiKey.isEmpty ? null : _saveAndTestApiKey,
                  icon: _testing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline, size: 16),
                  label: Text(l10n.aiCloudApiTestKey),
                  style: TextButton.styleFrom(
                    foregroundColor: ref.watch(primaryColorProvider),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: l10n.aiCloudApiKeyLabel,
                    hintText: l10n.aiCloudApiKeyHint,
                    border: const OutlineInputBorder(),
                    helperText: l10n.aiCloudApiKeyHelper,
                    prefixIcon: const Icon(Icons.vpn_key),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ref.watch(primaryColorProvider),
                        width: 2,
                      ),
                    ),
                  ),
                  controller: _apiKeyController,
                  onChanged: (v) {
                    setState(() {
                      _glmApiKey = v;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _openGlmWebsite,
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: Text(l10n.aiCloudApiGetKey),
                  style: TextButton.styleFrom(
                    foregroundColor: ref.watch(primaryColorProvider),
                  ),
                ),
                // API Key未配置提示
                if (_glmApiKey.isEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.aiCloudApiKeyRequired,
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalModelSection() {
    final l10n = AppLocalizations.of(context);

    return SectionCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.storage,
                  size: 20,
                  color: BeeTokens.textTertiary(context),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.aiLocalModelTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    l10n.aiLocalModelTraining,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: ListTile(
              leading: Icon(Icons.download_outlined, color: BeeTokens.textTertiary(context)),
              title: Text(l10n.aiLocalModelManagement),
              subtitle: Text(l10n.aiLocalModelUnavailable),
              trailing: const Icon(Icons.chevron_right),
              enabled: false,
              onTap: null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSection() {
    final l10n = AppLocalizations.of(context);

    return SectionCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.tune,
                  size: 20,
                  color: ref.watch(primaryColorProvider),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.aiPromptAdvancedSettings,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit_note, color: ref.watch(primaryColorProvider)),
            title: Text(l10n.aiPromptEditEntry),
            subtitle: Text(l10n.aiPromptEditEntryDesc),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AIPromptEditPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.psychology_outlined, color: ref.watch(primaryColorProvider)),
            title: Text(l10n.aiModelSelectEntry),
            subtitle: Text(l10n.aiModelSelectEntryDesc),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AIModelSelectionPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
