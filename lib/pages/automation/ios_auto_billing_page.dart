import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/ui/primary_header.dart';
import '../../widgets/ui/toast.dart';
import '../../providers.dart';
import '../../l10n/app_localizations.dart';

/// iOS自动记账配置页面
/// 通过快捷指令实现截图自动识别
class IOSAutoBillingPage extends ConsumerStatefulWidget {
  const IOSAutoBillingPage({super.key});

  @override
  ConsumerState<IOSAutoBillingPage> createState() => _IOSAutoBillingPageState();
}

class _IOSAutoBillingPageState extends ConsumerState<IOSAutoBillingPage> {

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
                // 功能说明
                _buildInfoCard(
                  context,
                  primaryColor,
                  icon: Icons.info_outline,
                  title: l10n.featureDescription,
                  content: l10n.iosAutoFeatureDesc,
                ),

                const SizedBox(height: 16),

                // 快速添加快捷指令按钮
                _buildQuickAddButton(context, primaryColor),

                const SizedBox(height: 16),

                // 双击背部快速触发说明
                _buildBackTapCard(context, primaryColor, l10n),

                const SizedBox(height: 16),

                // 快捷指令配置指南
                _buildShortcutsGuide(context, primaryColor),

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


  Widget _buildQuickAddButton(BuildContext context, Color primaryColor) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      color: primaryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, color: primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  l10n.iosAutoShortcutQuickAdd,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.iosAutoShortcutQuickAddDesc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _importShortcut(context),
                    icon: const Icon(Icons.download),
                    label: Text(l10n.iosAutoShortcutImport),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _openShortcutsApp(context),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(l10n.iosAutoShortcutOpenApp),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importShortcut(BuildContext context) async {
    try {
      // iCloud快捷指令分享链接：蜜蜂截屏记账
      const shortcutUrl = 'https://www.icloud.com/shortcuts/c7ff35e0e92c4efebf9e6ec9344b7731';

      final url = Uri.parse(shortcutUrl);

      // 在Safari中打开，自动弹出添加快捷指令对话框
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // 使用Safari打开
        );
      } else {
        if (context.mounted) {
          showToast(context, AppLocalizations.of(context).iosAutoCannotOpenLink);
        }
      }
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        showToast(context, l10n.iosAutoImportFailed(e.toString()));
      }
    }
  }

  Future<void> _openShortcutsApp(BuildContext context) async {
    try {
      // 尝试打开快捷指令App
      final url = Uri.parse('shortcuts://');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          showToast(context, AppLocalizations.of(context).iosAutoCannotOpenShortcuts);
        }
      }
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        showToast(context, l10n.iosAutoOpenAppFailed(e.toString()));
      }
    }
  }


  Widget _buildBackTapCard(
    BuildContext context,
    Color primaryColor,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Card(
      color: primaryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.touch_app, color: primaryColor, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.iosAutoBackTapTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.iosAutoBackTapDesc,
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

  Widget _buildInfoCard(
    BuildContext context,
    Color primaryColor, {
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

  Widget _buildShortcutsGuide(BuildContext context, Color primaryColor) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      color: primaryColor.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  '快捷指令配置指南',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'iOS通过"快捷指令"应用实现截图自动识别记账。设置后，每次截图都会自动识别并记录交易。',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.iosAutoShortcutConfigTitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 8),
            _buildStep(context, '1', l10n.iosAutoShortcutStep1),
            _buildStep(context, '2', l10n.iosAutoShortcutStep2),
            _buildStep(context, '3', l10n.iosAutoShortcutStep3),
            _buildStep(context, '4', l10n.iosAutoShortcutStep4),
            _buildStep(context, '5', l10n.iosAutoShortcutStep5),
            _buildStep(context, '6', l10n.iosAutoShortcutStep6),
            _buildStep(context, '7', l10n.iosAutoShortcutStep7),
            _buildStep(context, '8', l10n.iosAutoShortcutStep8),
            _buildStep(context, '9', l10n.iosAutoShortcutStep9),
            _buildStep(context, '10', l10n.iosAutoShortcutStep10),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.iosAutoShortcutRecommendedTip,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade800,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String number, String text) {
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
