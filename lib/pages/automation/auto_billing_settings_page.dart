import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/ui/primary_header.dart';
import '../../providers.dart';
import '../../services/screenshot_monitor_service.dart';
import '../../l10n/app_localizations.dart';
import 'ios_auto_billing_page.dart';

/// 自动记账设置页面（根据平台路由）
class AutoBillingSettingsPage extends StatelessWidget {
  const AutoBillingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const IOSAutoBillingPage();
    } else {
      return const AndroidAutoBillingPage();
    }
  }
}

/// Android自动记账设置页面
class AndroidAutoBillingPage extends ConsumerStatefulWidget {
  const AndroidAutoBillingPage({super.key});

  @override
  ConsumerState<AndroidAutoBillingPage> createState() => _AndroidAutoBillingPageState();
}

class _AndroidAutoBillingPageState extends ConsumerState<AndroidAutoBillingPage> {
  late final ScreenshotMonitorService _screenshotMonitor;
  bool _isMonitorEnabled = false;
  bool _isAccessibilityEnabled = false;
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final container = ProviderScope.containerOf(context);
      _screenshotMonitor = ScreenshotMonitorService(container);
      _loadMonitorStatus();
      _isInitialized = true;
    }
  }

  Future<void> _loadMonitorStatus() async {
    final enabled = await _screenshotMonitor.isEnabled();

    // 检查无障碍服务状态
    bool accessibilityEnabled = false;
    try {
      const platform = MethodChannel('com.example.beecount/screenshot');
      accessibilityEnabled = await platform.invokeMethod('isAccessibilityServiceEnabled');
    } catch (e) {
      print('检查无障碍服务状态失败: $e');
    }

    setState(() {
      _isMonitorEnabled = enabled;
      _isAccessibilityEnabled = accessibilityEnabled;
      _isLoading = false;
    });
  }

  Future<void> _toggleMonitor(bool value) async {
    if (value) {
      // 请求权限
      print('📸 [AutoBilling] 准备请求照片权限');
      final status = await Permission.photos.request();
      print('📸 [AutoBilling] 照片权限请求结果: $status');
      if (!status.isGranted) {
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.photosPermissionRequired)),
          );
        }
        return;
      }

      try {
        print('📸 [AutoBilling] 开始启用截图监听');
        // 只保存设置，不启动服务
        await _screenshotMonitor.enable();
        print('📸 [AutoBilling] 截图监听启用完成');
        setState(() {
          _isMonitorEnabled = true;
        });
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.enableSuccess)),
          );
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.enableFailed}: $e')),
          );
        }
      }
    } else {
      try {
        await _screenshotMonitor.disable();
        setState(() {
          _isMonitorEnabled = false;
        });
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.disableSuccess)),
          );
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.disableFailed}: $e')),
          );
        }
      }
    }
  }

  Future<void> _openAccessibilitySettings() async {
    try {
      // 使用 MethodChannel 调用原生方法打开无障碍设置
      const platform = MethodChannel('com.example.beecount/screenshot');
      await platform.invokeMethod('openAccessibilitySettings');
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.openSettingsFailed}: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _screenshotMonitor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = ref.watch(primaryColorProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          PrimaryHeader(
            title: l10n.autoScreenshotBillingTitle,
            showBack: true,
            leadingIcon: Icons.auto_fix_high,
            leadingPlain: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 功能说明卡片
                _buildInfoCard(
                  context,
                  primaryColor,
                  l10n,
                  icon: Icons.info_outline,
                  title: l10n.featureDescription,
                  content: l10n.featureDescriptionContent,
                ),

                const SizedBox(height: 16),

                // 开关卡片
                _buildSwitchCard(
                  context,
                  primaryColor,
                  l10n,
                  icon: Icons.auto_awesome,
                  title: l10n.autoBilling,
                  subtitle: _isMonitorEnabled ? l10n.enabled : l10n.disabled,
                  value: _isMonitorEnabled,
                  onChanged: _isLoading ? null : _toggleMonitor,
                ),

                const SizedBox(height: 16),

                // 无障碍服务状态卡片
                _buildAccessibilityStatusCard(context, primaryColor, l10n),

                const SizedBox(height: 16),

                // 无障碍服务引导卡片
                _buildAccessibilityGuideCard(context, primaryColor, l10n),

                const SizedBox(height: 16),

                // 支持的支付方式
                _buildSupportCard(
                  context,
                  primaryColor,
                  l10n,
                  icon: Icons.payment,
                  title: l10n.supportedPayments,
                  items: [
                    l10n.supportedAlipay,
                    l10n.supportedWechat,
                    l10n.supportedUnionpay,
                    l10n.supportedOthers,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    Color primaryColor,
    AppLocalizations l10n, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchCard(
    BuildContext context,
    Color primaryColor,
    AppLocalizations l10n, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool)? onChanged,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: value ? primaryColor : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityStatusCard(BuildContext context, Color primaryColor, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (_isAccessibilityEnabled ? Colors.green : Colors.grey).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isAccessibilityEnabled ? Icons.check_circle : Icons.info_outline,
                color: _isAccessibilityEnabled ? Colors.green : Colors.grey,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.accessibilityService,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isAccessibilityEnabled ? l10n.accessibilityServiceEnabled : l10n.accessibilityServiceDisabled,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _isAccessibilityEnabled
                          ? Colors.green
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              _isAccessibilityEnabled ? Icons.check : Icons.close,
              color: _isAccessibilityEnabled ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityGuideCard(BuildContext context, Color primaryColor, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Card(
      color: primaryColor.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  l10n.improveRecognitionSpeed,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.accessibilityGuideContent,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.setupSteps,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildStep(l10n, '1', l10n.accessibilityStep1),
            _buildStep(l10n, '2', l10n.accessibilityStep2),
            _buildStep(l10n, '3', l10n.accessibilityStep3),
            _buildStep(l10n, '4', l10n.accessibilityStep4),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openAccessibilitySettings,
                icon: const Icon(Icons.settings),
                label: Text(l10n.openAccessibilitySettings),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.accessibilityServiceNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(AppLocalizations l10n, String number, String text) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(
    BuildContext context,
    Color primaryColor,
    AppLocalizations l10n, {
    required IconData icon,
    required String title,
    required List<String> items,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                item,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
