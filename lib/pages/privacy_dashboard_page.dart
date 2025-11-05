import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../widgets/ui/ui.dart';

/// 隐私仪表盘页面
/// 展示应用的隐私保护措施和数据安全状态
class PrivacyDashboardPage extends ConsumerWidget {
  const PrivacyDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          PrimaryHeader(
            title: l10n.privacyDashboardTitle,
            showBack: true,
          ),
          Expanded(
            child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 隐私评分卡片
          _buildPrivacyScoreCard(context, theme, l10n),
          const SizedBox(height: 16),

          // 数据存储位置
          _buildDataStorageSection(context, theme, l10n),
          const SizedBox(height: 16),

          // 网络请求监控
          _buildNetworkMonitorSection(context, theme, l10n),
          const SizedBox(height: 16),

          // 权限使用说明
          _buildPermissionsSection(context, theme, l10n),
          const SizedBox(height: 16),

          // 开源验证
          _buildOpenSourceSection(context, theme, l10n),
        ],
            ),
          ),
        ],
      ),
    );
  }

  /// 隐私评分卡片
  Widget _buildPrivacyScoreCard(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 隐私评分图标
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shield_outlined,
                size: 40,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 16),

            // 隐私评分文本
            Text(
              l10n.privacyScoreExcellent,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              l10n.privacyScoreDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 数据存储位置说明
  Widget _buildDataStorageSection(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage_outlined, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  l10n.privacyDataStorageTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildPrivacyCheckItem(
              context,
              Icons.check_circle_outline,
              Colors.green,
              l10n.privacyDataStorageLocal,
            ),
            const SizedBox(height: 8),

            _buildPrivacyCheckItem(
              context,
              Icons.check_circle_outline,
              Colors.green,
              l10n.privacyDataStorageNoUpload,
            ),
            const SizedBox(height: 8),

            _buildPrivacyCheckItem(
              context,
              Icons.check_circle_outline,
              Colors.green,
              l10n.privacyDataStorageOptionalSync,
            ),
          ],
        ),
      ),
    );
  }

  /// 网络请求监控
  Widget _buildNetworkMonitorSection(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.network_check_outlined, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  l10n.privacyNetworkMonitorTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              l10n.privacyNetworkMonitorSince,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),

            _buildStatItem(
              context,
              l10n.privacyNetworkDataRequests,
              '0',
              Colors.green,
            ),
            const SizedBox(height: 8),

            _buildStatItem(
              context,
              l10n.privacyNetworkTrackers,
              '0',
              Colors.green,
            ),
            const SizedBox(height: 8),

            _buildStatItem(
              context,
              l10n.privacyNetworkAdRequests,
              '0',
              Colors.green,
            ),
            const SizedBox(height: 8),

            _buildStatItem(
              context,
              l10n.privacyNetworkAnalytics,
              '0',
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  /// 权限使用说明
  Widget _buildPermissionsSection(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security_outlined, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  l10n.privacyPermissionsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              l10n.privacyPermissionsOnlyRequest,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),

            _buildPrivacyCheckItem(
              context,
              Icons.check_circle_outline,
              Colors.green,
              l10n.privacyPermissionsStorage,
            ),
            const SizedBox(height: 8),

            _buildPrivacyCheckItem(
              context,
              Icons.check_circle_outline,
              Colors.green,
              l10n.privacyPermissionsNotifications,
            ),
            const SizedBox(height: 8),

            _buildPrivacyCheckItem(
              context,
              Icons.cancel_outlined,
              Colors.orange,
              l10n.privacyPermissionsNoLocation,
            ),
            const SizedBox(height: 8),

            _buildPrivacyCheckItem(
              context,
              Icons.cancel_outlined,
              Colors.orange,
              l10n.privacyPermissionsNoContacts,
            ),
            const SizedBox(height: 8),

            _buildPrivacyCheckItem(
              context,
              Icons.cancel_outlined,
              Colors.orange,
              l10n.privacyPermissionsNoCamera,
            ),
          ],
        ),
      ),
    );
  }

  /// 开源验证
  Widget _buildOpenSourceSection(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code_outlined, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  l10n.privacyOpenSourceTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildPrivacyCheckItem(
              context,
              Icons.check_circle_outline,
              Colors.green,
              l10n.privacyOpenSourcePublic,
            ),
            const SizedBox(height: 8),

            _buildPrivacyCheckItem(
              context,
              Icons.check_circle_outline,
              Colors.green,
              l10n.privacyOpenSourceCommunity,
            ),
            const SizedBox(height: 8),

            _buildPrivacyCheckItem(
              context,
              Icons.check_circle_outline,
              Colors.green,
              l10n.privacyOpenSourceMIT,
            ),
            const SizedBox(height: 16),

            // GitHub链接按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _launchGitHub(context),
                icon: const Icon(Icons.open_in_new),
                label: Text(l10n.privacyOpenSourceViewCode),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 隐私检查项
  Widget _buildPrivacyCheckItem(
    BuildContext context,
    IconData icon,
    Color color,
    String text,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  /// 统计项
  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  /// 打开GitHub链接
  Future<void> _launchGitHub(BuildContext context) async {
    final url = Uri.parse('https://github.com/TNT-Likely/BeeCount');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).privacyOpenSourceUrlError),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).privacyOpenSourceUrlError),
          ),
        );
      }
    }
  }
}
