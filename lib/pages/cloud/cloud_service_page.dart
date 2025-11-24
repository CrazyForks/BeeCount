import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cloud_sync/flutter_cloud_sync.dart' hide SyncStatus;
import 'package:flutter_cloud_sync_icloud/flutter_cloud_sync_icloud.dart';
import '../../cloud/sync_service.dart';
import '../../providers/sync_providers.dart';
import '../../services/logger_service.dart';
import '../../widgets/ui/ui.dart';
import '../../widgets/biz/section_card.dart';
import '../../styles/tokens.dart';
import '../../l10n/app_localizations.dart';

// GitHub配置教程链接
const _kSupabaseGuideUrl = 'https://github.com/TNT-Likely/BeeCount/wiki/Supabase-%E4%BA%91%E5%90%8C%E6%AD%A5%E9%85%8D%E7%BD%AE';
const _kWebdavGuideUrl = 'https://github.com/TNT-Likely/BeeCount/wiki/WebDAV-%E4%BA%91%E5%90%8C%E6%AD%A5%E9%85%8D%E7%BD%AE';

class CloudServicePage extends ConsumerStatefulWidget {
  const CloudServicePage({super.key});
  @override
  ConsumerState<CloudServicePage> createState() => _CloudServicePageState();
}

class _CloudServicePageState extends ConsumerState<CloudServicePage> {
  bool _testingConnection = false;
  final Map<String, bool> _connectionTestResults = {};
  bool _hasAutoTested = false;

  @override
  void initState() {
    super.initState();
    // 延迟执行自动测试，等待页面加载完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoTestActiveConnection();
    });
  }

  Future<void> _autoTestActiveConnection() async {
    if (_hasAutoTested) return;
    _hasAutoTested = true;

    final activeAsync = ref.read(activeCloudConfigProvider);
    if (!activeAsync.hasValue) return;

    final active = activeAsync.value!;
    if (active.type == CloudBackendType.local || !active.valid) return;

    // 自动测试当前激活的云服务连接（静默测试，不显示对话框）
    await _testConnection(active, showDialog: false);
  }

  @override
  Widget build(BuildContext context) {
    final activeAsync = ref.watch(activeCloudConfigProvider);
    final supabaseAsync = ref.watch(supabaseConfigProvider);
    final webdavAsync = ref.watch(webdavConfigProvider);

    return Scaffold(
      backgroundColor: BeeTokens.scaffoldBackground(context),
      body: Column(
        children: [
          activeAsync.when(
            loading: () => PrimaryHeader(
              title: AppLocalizations.of(context).mineCloudService,
              showBack: true,
            ),
            error: (e, _) => PrimaryHeader(
              title: AppLocalizations.of(context).mineCloudService,
              showBack: true,
            ),
            data: (active) => PrimaryHeader(
              title: AppLocalizations.of(context).mineCloudService,
              showBack: true,
              actions: active.type != CloudBackendType.local && active.valid
                  ? [
                      IconButton(
                        icon: _testingConnection
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.wifi_find),
                        onPressed: _testingConnection ? null : () => _testConnection(active),
                        tooltip: AppLocalizations.of(context).cloudTestConnection,
                      ),
                    ]
                  : null,
              content: active.type != CloudBackendType.local
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: _buildConnectionStatus(active),
                    )
                  : null,
            ),
          ),
          Expanded(
            child: activeAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('${AppLocalizations.of(context).commonError}: $e')),
              data: (active) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      AppLocalizations.of(context).cloudSelectServiceType,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: BeeTokens.textSecondary(context),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 1. 本地存储 Card
                    _buildServiceCard(
                      context: context,
                      icon: Icons.phone_android,
                      iconColor: BeeTokens.brandLocal,
                      title: AppLocalizations.of(context).cloudLocalStorageTitle,
                      subtitle: AppLocalizations.of(context).cloudLocalStorageSubtitle,
                      isSelected: active.type == CloudBackendType.local,
                      onTap: () => _switchService(CloudBackendType.local),
                    ),

                    // 2. iCloud Card (仅 iOS)
                    if (!kIsWeb && Platform.isIOS) ...[
                      const SizedBox(height: 12),
                      _buildICloudCard(context, active),
                    ],

                    const SizedBox(height: 12),

                    // 3. 自定义 WebDAV Card
                    webdavAsync.when(
                      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                      error: (e, _) => const SizedBox.shrink(),
                      data: (webdavCfg) => _buildServiceCard(
                        context: context,
                        icon: Icons.folder_shared,
                        iconColor: BeeTokens.brandWebdav,
                        title: AppLocalizations.of(context).cloudCustomWebdavTitle,
                        subtitle: webdavCfg?.valid == true
                            ? webdavCfg!.obfuscatedUrl()
                            : AppLocalizations.of(context).cloudCustomWebdavSubtitle,
                        isSelected: active.type == CloudBackendType.webdav,
                        isConfigured: webdavCfg?.valid == true,
                        onTap: () => webdavCfg?.valid == true
                            ? _switchService(CloudBackendType.webdav)
                            : _configureService(CloudBackendType.webdav),
                        onConfigure: webdavCfg?.valid == true
                            ? () => _configureService(CloudBackendType.webdav)
                            : null,
                        onShowGuide: _showWebdavHelpDialog,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 4. 自定义 Supabase Card
                    supabaseAsync.when(
                      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                      error: (e, _) => const SizedBox.shrink(),
                      data: (supabaseCfg) => _buildServiceCard(
                        context: context,
                        icon: Icons.cloud,
                        iconColor: BeeTokens.brandSupabase,
                        title: AppLocalizations.of(context).cloudCustomSupabaseTitle,
                        subtitle: supabaseCfg?.valid == true
                            ? supabaseCfg!.obfuscatedUrl()
                            : AppLocalizations.of(context).cloudCustomSupabaseSubtitle,
                        isSelected: active.type == CloudBackendType.supabase,
                        isConfigured: supabaseCfg?.valid == true,
                        onTap: () => supabaseCfg?.valid == true
                            ? _switchService(CloudBackendType.supabase)
                            : _configureService(CloudBackendType.supabase),
                        onConfigure: supabaseCfg?.valid == true
                            ? () => _configureService(CloudBackendType.supabase)
                            : null,
                        onShowGuide: _showSupabaseHelpDialog,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(CloudServiceConfig config) {
    final testResult = _connectionTestResults[config.id];
    final Color statusColor;
    final IconData statusIcon;
    final String statusText;

    if (testResult == null) {
      // 未测试
      statusColor = BeeTokens.warning(context);
      statusIcon = Icons.help_outline;
      statusText = AppLocalizations.of(context).cloudStatusNotTested;
    } else if (testResult) {
      // 测试成功
      statusColor = BeeTokens.success(context);
      statusIcon = Icons.check_circle_outline;
      statusText = AppLocalizations.of(context).cloudStatusNormal;
    } else {
      // 测试失败
      statusColor = BeeTokens.error(context);
      statusIcon = Icons.error_outline;
      statusText = AppLocalizations.of(context).cloudStatusFailed;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context).commonCurrent}: ${_getTypeName(config.type)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          config.obfuscatedUrl(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: BeeTokens.textSecondary(context),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isSelected,
    bool isConfigured = true,
    required VoidCallback onTap,
    VoidCallback? onConfigure,
    VoidCallback? onShowGuide,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: BeeTokens.success(context), width: 2) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SectionCard(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // 图标
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: iconColor, size: 24),
                    ),
                    const SizedBox(width: 16),

                    // 文字信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: BeeTokens.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 选中标记
                    if (isSelected)
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: BeeTokens.success(context),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: BeeTokens.textOnPrimary(context), size: 18),
                      ),
                  ],
                ),

                // 底部按钮行
                if ((isConfigured && onConfigure != null) || onShowGuide != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onShowGuide != null)
                          TextButton.icon(
                            onPressed: onShowGuide,
                            icon: const Icon(Icons.help_outline, size: 16),
                            label: Text(AppLocalizations.of(context).commonTutorial, style: const TextStyle(fontSize: 12)),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        if (isConfigured && onConfigure != null) ...[
                          if (onShowGuide != null) const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: onConfigure,
                            icon: const Icon(Icons.settings, size: 16),
                            label: Text(AppLocalizations.of(context).commonConfigure, style: const TextStyle(fontSize: 12)),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildICloudCard(BuildContext context, CloudServiceConfig active) {
    final isSelected = active.type == CloudBackendType.icloud;

    return Container(
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: BeeTokens.success(context), width: 2) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SectionCard(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => _switchService(CloudBackendType.icloud),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // 图标
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: BeeTokens.brandIcloud.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.cloud, color: BeeTokens.brandIcloud, size: 24),
                    ),
                    const SizedBox(width: 16),

                    // 文字信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'iCloud',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isSelected
                                ? 'iCloud Drive'
                                : AppLocalizations.of(context).cloudIcloudSubtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: BeeTokens.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 选中标记
                    if (isSelected)
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: BeeTokens.success(context),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: BeeTokens.textOnPrimary(context), size: 18),
                      ),
                  ],
                ),

                // 底部帮助按钮
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _showICloudHelpDialog,
                        icon: const Icon(Icons.help_outline, size: 16),
                        label: Text(AppLocalizations.of(context).commonTutorial, style: const TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSupabaseHelpDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.cloud, color: BeeTokens.brandSupabase),
            const SizedBox(width: 8),
            Text(l10n.cloudSupabaseHelpTitle),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection(
                l10n.cloudSupabaseHelpIntro,
                [
                  l10n.cloudSupabaseHelpIntro1,
                  l10n.cloudSupabaseHelpIntro2,
                  l10n.cloudSupabaseHelpIntro3,
                ],
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                l10n.cloudSupabaseHelpSteps,
                [
                  l10n.cloudSupabaseHelpStep1,
                  l10n.cloudSupabaseHelpStep2,
                  l10n.cloudSupabaseHelpStep3,
                  l10n.cloudSupabaseHelpStep4,
                  l10n.cloudSupabaseHelpStep5,
                ],
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                l10n.cloudSupabaseHelpFaq,
                [
                  '• ${l10n.cloudSupabaseHelpFaq1}',
                  '• ${l10n.cloudSupabaseHelpFaq2}',
                  '• ${l10n.cloudSupabaseHelpFaq3}',
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BeeTokens.brandSupabase.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: BeeTokens.brandSupabase, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.cloudSupabaseHelpNote,
                        style: TextStyle(
                          fontSize: 13,
                          color: BeeTokens.textSecondary(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _openGuide(_kSupabaseGuideUrl),
            child: Text(l10n.cloudDetailedTutorial),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  void _showWebdavHelpDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.folder_shared, color: BeeTokens.brandWebdav),
            const SizedBox(width: 8),
            Text(l10n.cloudWebdavHelpTitle),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection(
                l10n.cloudWebdavHelpIntro,
                [
                  l10n.cloudWebdavHelpIntro1,
                  l10n.cloudWebdavHelpIntro2,
                  l10n.cloudWebdavHelpIntro3,
                ],
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                l10n.cloudWebdavHelpProviders,
                [
                  l10n.cloudWebdavHelpProvider1,
                  l10n.cloudWebdavHelpProvider2,
                  l10n.cloudWebdavHelpProvider3,
                  l10n.cloudWebdavHelpProvider4,
                ],
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                l10n.cloudWebdavHelpSteps,
                [
                  l10n.cloudWebdavHelpStep1,
                  l10n.cloudWebdavHelpStep2,
                  l10n.cloudWebdavHelpStep3,
                  l10n.cloudWebdavHelpStep4,
                  l10n.cloudWebdavHelpStep5,
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BeeTokens.brandWebdav.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: BeeTokens.brandWebdav, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.cloudWebdavHelpNote,
                        style: TextStyle(
                          fontSize: 13,
                          color: BeeTokens.textSecondary(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  void _showICloudHelpDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.cloud, color: BeeTokens.brandIcloud),
            const SizedBox(width: 8),
            Text(l10n.cloudIcloudHelpTitle),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection(
                l10n.cloudIcloudHelpPrerequisites,
                [
                  l10n.cloudIcloudHelpPrereq1,
                  l10n.cloudIcloudHelpPrereq2,
                  l10n.cloudIcloudHelpPrereq3,
                ],
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                l10n.cloudIcloudHelpCheckTitle,
                [
                  l10n.cloudIcloudHelpCheck1,
                  l10n.cloudIcloudHelpCheck2,
                  l10n.cloudIcloudHelpCheck3,
                  l10n.cloudIcloudHelpCheck4,
                ],
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                l10n.cloudIcloudHelpFaqTitle,
                [
                  '• ${l10n.cloudIcloudHelpFaq1}',
                  '• ${l10n.cloudIcloudHelpFaq2}',
                  '• ${l10n.cloudIcloudHelpFaq3}',
                  '• ${l10n.cloudIcloudHelpFaq4}',
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BeeTokens.brandIcloud.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: BeeTokens.brandIcloud, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.cloudIcloudHelpNote,
                        style: TextStyle(
                          fontSize: 13,
                          color: BeeTokens.textSecondary(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: BeeTokens.textPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            item,
            style: TextStyle(
              fontSize: 13,
              color: BeeTokens.textSecondary(context),
            ),
          ),
        )),
      ],
    );
  }

  Future<void> _openGuide(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        showToast(context, AppLocalizations.of(context).cloudCannotOpenLink);
      }
    }
  }

  Future<void> _switchService(CloudBackendType type) async {
    final store = ref.read(cloudServiceStoreProvider);
    final active = await ref.read(activeCloudConfigProvider.future);

    if (active.type == type) return; // 已经是当前类型

    // iCloud: 先检查可用性
    if (type == CloudBackendType.icloud) {
      logger.info('CloudService', '========== 开始 iCloud 诊断 ==========');
      final icloudProvider = ICloudProvider();
      try {
        // 获取详细诊断信息
        final diagnostics = await icloudProvider.getDiagnostics();
        logger.info('CloudService', 'iCloud 诊断信息:');
        diagnostics.forEach((key, value) {
          logger.info('CloudService', '  $key: $value');
        });

        final isAvailable = await icloudProvider.isAvailable();
        logger.info('CloudService', 'iCloud 可用性: $isAvailable');
        logger.info('CloudService', '========== iCloud 诊断结束 ==========');

        if (!isAvailable) {
          if (mounted) {
            // 显示更详细的错误信息
            final cloudKitStatus = diagnostics['cloudKitStatus'] ?? 'unknown';
            final containerAvailable = diagnostics['containerAvailable'] ?? false;
            var detailMessage = AppLocalizations.of(context).cloudIcloudNotAvailableMessage;
            if (cloudKitStatus == 'noAccount') {
              detailMessage = '请在设置中登录 iCloud 账号';
            } else if (!containerAvailable) {
              detailMessage = 'iCloud 容器不可用，请确保 iCloud Drive 已开启';
            }
            await AppDialog.error(
              context,
              title: AppLocalizations.of(context).cloudIcloudNotAvailableTitle,
              message: detailMessage,
            );
          }
          return;
        }
      } catch (e, stack) {
        logger.error('CloudService', 'iCloud 可用性检查失败', e, stack);
        if (mounted) {
          await AppDialog.error(
            context,
            title: AppLocalizations.of(context).cloudIcloudNotAvailableTitle,
            message: 'iCloud 检查失败: $e',
          );
        }
        return;
      }
    }

    // 确认切换
    if (!mounted) return;
    final confirmed = await AppDialog.confirm(
      context,
      title: AppLocalizations.of(context).cloudSwitchConfirmTitle,
      message: AppLocalizations.of(context).cloudSwitchConfirmMessage,
    );
    if (!confirmed || !mounted) return;

    try {
      // 登出（iCloud 使用系统账号，跳过登出）
      if (active.type != CloudBackendType.icloud && active.type != CloudBackendType.local) {
        try {
          final authService = await ref.read(authServiceProvider.future);
          await authService.signOut();
        } catch (_) {
          // 忽略登出错误
        }
      }

      // 激活新配置
      final success = await store.activate(type);
      if (!success && type != CloudBackendType.local && type != CloudBackendType.icloud) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudSwitchFailedTitle, message: AppLocalizations.of(context).cloudSwitchFailedConfigMissing);
        }
        return;
      }

      // 延迟刷新 providers，避免在 build 阶段触发 setState
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.invalidate(activeCloudConfigProvider);
        ref.invalidate(supabaseConfigProvider);
        ref.invalidate(webdavConfigProvider);
        ref.invalidate(authServiceProvider);
        ref.invalidate(syncServiceProvider);
      });

      if (mounted) {
        showToast(context, AppLocalizations.of(context).cloudSwitchedTo(_getTypeName(type)));
      }
    } catch (e) {
      if (mounted) {
        await AppDialog.error(context, title: AppLocalizations.of(context).cloudSwitchFailedTitle, message: '$e');
      }
    }
  }

  Future<void> _configureService(CloudBackendType type) async {
    // 根据类型显示配置对话框
    if (type == CloudBackendType.supabase) {
      await _showSupabaseConfigDialog();
    } else if (type == CloudBackendType.webdav) {
      await _showWebdavConfigDialog();
    }
  }

  Future<void> _showSupabaseConfigDialog() async {
    final existing = await ref.read(supabaseConfigProvider.future);

    if (!mounted) return;

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (dialogContext) => _SupabaseConfigDialog(
        initialUrl: existing?.supabaseUrl ?? '',
        initialKey: existing?.supabaseAnonKey ?? '',
      ),
    );

    if (result != null) {
      final url = result['url'] as String;
      final key = result['key'] as String;

      if (url.isEmpty || key.isEmpty) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudConfigInvalidTitle, message: AppLocalizations.of(context).cloudConfigInvalidMessage);
        }
        return;
      }

      final cfg = CloudServiceConfig(
        type: CloudBackendType.supabase,
        name: AppLocalizations.of(context).cloudCustomSupabaseTitle,
        supabaseUrl: url,
        supabaseAnonKey: key,
      );

      if (!cfg.valid) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudConfigInvalidTitle, message: AppLocalizations.of(context).cloudConfigInvalidMessage);
        }
        return;
      }

      try {
        await ref.read(cloudServiceStoreProvider).saveOnly(cfg);
        ref.invalidate(supabaseConfigProvider);
        // 刷新激活配置，确保同步服务使用最新配置
        ref.invalidate(activeCloudConfigProvider);
        if (mounted) showToast(context, AppLocalizations.of(context).cloudConfigSaved);
      } catch (e) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudSaveFailed, message: e.toString());
        }
      }
    }
  }

  Future<void> _showWebdavConfigDialog() async {
    final existing = await ref.read(webdavConfigProvider.future);

    if (!mounted) return;

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (dialogContext) => _WebdavConfigDialog(
        initialUrl: existing?.webdavUrl ?? '',
        initialUsername: existing?.webdavUsername ?? '',
        initialPassword: existing?.webdavPassword ?? '',
        initialPath: existing?.webdavRemotePath ?? '/',
      ),
    );

    if (result != null) {
      final url = result['url'] as String;
      final username = result['username'] as String;
      final password = result['password'] as String;
      final path = result['path'] as String;

      if (url.isEmpty || username.isEmpty || password.isEmpty) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudConfigInvalidTitle, message: AppLocalizations.of(context).cloudConfigInvalidMessage);
        }
        return;
      }

      final cfg = CloudServiceConfig(
        type: CloudBackendType.webdav,
        name: AppLocalizations.of(context).cloudCustomWebdavTitle,
        webdavUrl: url,
        webdavUsername: username,
        webdavPassword: password,
        webdavRemotePath: path.isEmpty ? '/' : path,
      );

      if (!cfg.valid) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudConfigInvalidTitle, message: AppLocalizations.of(context).cloudConfigInvalidMessage);
        }
        return;
      }

      try {
        await ref.read(cloudServiceStoreProvider).saveOnly(cfg);
        ref.invalidate(webdavConfigProvider);
        // 刷新激活配置，确保同步服务使用最新配置
        ref.invalidate(activeCloudConfigProvider);
        if (mounted) showToast(context, AppLocalizations.of(context).cloudConfigSaved);
      } catch (e) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudSaveFailed, message: e.toString());
        }
      }
    }
  }

  String _getTypeName(CloudBackendType type) {
    switch (type) {
      case CloudBackendType.local:
        return AppLocalizations.of(context).cloudLocalStorageTitle;
      case CloudBackendType.supabase:
        return 'Supabase';
      case CloudBackendType.webdav:
        return 'WebDAV';
      case CloudBackendType.icloud:
        return 'iCloud';
    }
  }

  // 测试连接
  Future<void> _testConnection(CloudServiceConfig config, {bool showDialog = true}) async {
    if (!config.valid || config.type == CloudBackendType.local) return;

    setState(() => _testingConnection = true);
    try {
      bool connectionSuccess = false;
      String? errorDetail;

      try {
        switch (config.type) {
          case CloudBackendType.local:
            break;

          case CloudBackendType.supabase:
            // Supabase 连接测试 - 尝试访问 REST API
            final testUrl = Uri.parse('${config.supabaseUrl}/rest/v1/');
            final response = await http.get(
              testUrl,
              headers: {
                'apikey': config.supabaseAnonKey!,
                'Authorization': 'Bearer ${config.supabaseAnonKey}',
              },
            ).timeout(const Duration(seconds: 10));

            if (response.statusCode == 200 || response.statusCode == 404) {
              connectionSuccess = true;
            } else if (response.statusCode == 401 || response.statusCode == 403) {
              throw Exception(AppLocalizations.of(context).cloudErrorAuthFailed);
            } else {
              throw Exception(AppLocalizations.of(context).cloudErrorServerStatus('${response.statusCode}'));
            }
            break;

          case CloudBackendType.webdav:
            // WebDAV 连接测试 - 发送 OPTIONS 请求
            final testUrl = Uri.parse(config.webdavUrl!);
            final credentials = base64Encode(
              utf8.encode('${config.webdavUsername}:${config.webdavPassword}'),
            );

            final request = http.Request('OPTIONS', testUrl);
            request.headers['Authorization'] = 'Basic $credentials';

            final streamedResponse = await request.send().timeout(const Duration(seconds: 10));
            final response = await http.Response.fromStream(streamedResponse);

            if (response.statusCode == 200 || response.statusCode == 204) {
              final davHeader = response.headers['dav'];
              if (davHeader != null || response.headers.containsKey('allow')) {
                connectionSuccess = true;
              } else {
                throw Exception(AppLocalizations.of(context).cloudErrorWebdavNotSupported);
              }
            } else if (response.statusCode == 401) {
              throw Exception(AppLocalizations.of(context).cloudErrorAuthFailedCredentials);
            } else if (response.statusCode == 403) {
              throw Exception(AppLocalizations.of(context).cloudErrorAccessDenied);
            } else if (response.statusCode == 404) {
              throw Exception(AppLocalizations.of(context).cloudErrorPathNotFound(testUrl.path));
            } else {
              throw Exception(AppLocalizations.of(context).cloudErrorServerStatus('${response.statusCode}'));
            }
            break;

          case CloudBackendType.icloud:
            // iCloud 连接测试
            final icloudProvider = ICloudProvider();
            final isAvailable = await icloudProvider.isAvailable();
            if (isAvailable) {
              // 尝试初始化容器
              try {
                await icloudProvider.initialize({});
                connectionSuccess = true;
              } catch (e) {
                throw Exception('iCloud 容器初始化失败: $e');
              }
            } else {
              throw Exception('iCloud 不可用，请检查设备是否已登录 iCloud 并开启 iCloud Drive');
            }
            break;
        }
      } on http.ClientException catch (e) {
        connectionSuccess = false;
        errorDetail = AppLocalizations.of(context).cloudErrorNetwork(e.message);
      } on Exception catch (e) {
        connectionSuccess = false;
        errorDetail = e.toString().replaceFirst('Exception: ', '');
      } catch (e) {
        connectionSuccess = false;
        errorDetail = e.toString();
      }

      setState(() {
        _connectionTestResults[config.id] = connectionSuccess;
      });

      // 只在手动测试时显示对话框
      if (mounted && showDialog) {
        if (connectionSuccess) {
          await AppDialog.info(context,
              title: AppLocalizations.of(context).cloudTestSuccessTitle,
              message: AppLocalizations.of(context).cloudTestSuccessMessage);
        } else {
          await AppDialog.error(context,
              title: AppLocalizations.of(context).cloudTestFailedTitle,
              message: errorDetail ?? AppLocalizations.of(context).cloudTestFailedMessage);
        }
      }
    } catch (e) {
      setState(() {
        _connectionTestResults[config.id] = false;
      });
      // 只在手动测试时显示错误对话框
      if (mounted && showDialog) {
        await AppDialog.error(context,
            title: AppLocalizations.of(context).cloudTestErrorTitle,
            message: e.toString());
      }
    } finally {
      if (mounted) setState(() => _testingConnection = false);
    }
  }
}

// Supabase配置对话框(独立Widget,避免controller生命周期问题)
class _SupabaseConfigDialog extends StatefulWidget {
  final String initialUrl;
  final String initialKey;

  const _SupabaseConfigDialog({
    required this.initialUrl,
    required this.initialKey,
  });

  @override
  State<_SupabaseConfigDialog> createState() => _SupabaseConfigDialogState();
}

class _SupabaseConfigDialogState extends State<_SupabaseConfigDialog> {
  late final TextEditingController urlController;
  late final TextEditingController keyController;

  @override
  void initState() {
    super.initState();
    urlController = TextEditingController(text: widget.initialUrl);
    keyController = TextEditingController(text: widget.initialKey);
  }

  @override
  void dispose() {
    urlController.dispose();
    keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).cloudConfigureSupabaseTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudSupabaseUrlLabel,
                hintText: AppLocalizations.of(context).cloudSupabaseUrlHint,
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: keyController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudAnonKeyLabel,
                hintText: AppLocalizations.of(context).cloudSupabaseAnonKeyHintLong,
              ),
              keyboardType: TextInputType.text,
              minLines: 1,
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(AppLocalizations.of(context).commonCancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop({
              'url': urlController.text.trim(),
              'key': keyController.text.trim(),
            });
          },
          child: Text(AppLocalizations.of(context).commonSave),
        ),
      ],
    );
  }
}

// WebDAV配置对话框(独立Widget,避免controller生命周期问题)
class _WebdavConfigDialog extends StatefulWidget {
  final String initialUrl;
  final String initialUsername;
  final String initialPassword;
  final String initialPath;

  const _WebdavConfigDialog({
    required this.initialUrl,
    required this.initialUsername,
    required this.initialPassword,
    required this.initialPath,
  });

  @override
  State<_WebdavConfigDialog> createState() => _WebdavConfigDialogState();
}

class _WebdavConfigDialogState extends State<_WebdavConfigDialog> {
  late final TextEditingController urlController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController pathController;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    urlController = TextEditingController(text: widget.initialUrl);
    usernameController = TextEditingController(text: widget.initialUsername);
    passwordController = TextEditingController(text: widget.initialPassword);
    pathController = TextEditingController(text: widget.initialPath);
  }

  @override
  void dispose() {
    urlController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).cloudConfigureWebdavTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudWebdavUrlLabel,
                hintText: AppLocalizations.of(context).cloudWebdavUrlHint,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudWebdavUsernameLabel,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudWebdavPasswordLabel,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: obscurePassword,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pathController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudWebdavRemotePathLabel,
                hintText: AppLocalizations.of(context).cloudWebdavPathHint,
                helperText: AppLocalizations.of(context).cloudWebdavRemotePathHelperText,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(AppLocalizations.of(context).commonCancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop({
              'url': urlController.text.trim(),
              'username': usernameController.text.trim(),
              'password': passwordController.text.trim(),
              'path': pathController.text.trim(),
            });
          },
          child: Text(AppLocalizations.of(context).commonSave),
        ),
      ],
    );
  }
}
