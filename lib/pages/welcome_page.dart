import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/ui_state_providers.dart';

/// 首次启动欢迎页面
/// 展示应用的独特价值：隐私保护、开源透明、数据自主
class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // 页面指示器
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // 页面内容
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildWelcomePage(context, theme, l10n),
                  _buildPrivacyPage(context, theme, l10n),
                  _buildOpenSourcePage(context, theme, l10n),
                  _buildCloudSyncPage(context, theme, l10n),
                ],
              ),
            ),

            // 底部按钮
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: Text(l10n.commonPrevious),
                    ),
                  const Spacer(),
                  if (_currentPage < 3)
                    FilledButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.primaryColor,
                      ),
                      child: Text(l10n.commonNext),
                    )
                  else
                    FilledButton(
                      onPressed: () => _finishWelcome(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.primaryColor,
                      ),
                      child: Text(l10n.commonFinish),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 第1页：欢迎
  Widget _buildWelcomePage(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 应用图标
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SvgPicture.asset(
                'assets/logo.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 欢迎标题
          Text(
            l10n.welcomeTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // 欢迎描述
          Text(
            l10n.welcomeDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 第2页：隐私保护
  Widget _buildPrivacyPage(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 隐私图标
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),

          // 标题
          Text(
            l10n.welcomePrivacyTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // 特性列表
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem(
                    context,
                    Icons.check_circle_outline,
                    Colors.white,
                    l10n.welcomePrivacyFeature1,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.check_circle_outline,
                    Colors.white,
                    l10n.welcomePrivacyFeature2,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.check_circle_outline,
                    Colors.white,
                    l10n.welcomePrivacyFeature3,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.check_circle_outline,
                    Colors.white,
                    l10n.welcomePrivacyFeature4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 第3页：开源透明
  Widget _buildOpenSourcePage(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 开源图标
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.code_outlined,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),

          // 标题
          Text(
            l10n.welcomeOpenSourceTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // 特性列表
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem(
                    context,
                    Icons.check_circle_outline,
                    Colors.white,
                    l10n.welcomeOpenSourceFeature1,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.check_circle_outline,
                    Colors.white,
                    l10n.welcomeOpenSourceFeature2,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.check_circle_outline,
                    Colors.white,
                    l10n.welcomeOpenSourceFeature3,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // GitHub链接按钮
          OutlinedButton.icon(
            onPressed: () => _launchGitHub(context),
            icon: const Icon(Icons.open_in_new, size: 18, color: Colors.white),
            label: Text(l10n.welcomeViewGitHub,
                style: const TextStyle(color: Colors.white)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 第4页：云同步说明
  Widget _buildCloudSyncPage(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 云同步图标
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_outlined,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),

          // 标题
          Text(
            l10n.welcomeCloudSyncTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // 描述
          Text(
            l10n.welcomeCloudSyncDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // 特性列表
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem(
                    context,
                    Icons.offline_bolt_outlined,
                    Colors.white,
                    l10n.welcomeCloudSyncFeature1,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.dns_outlined,
                    Colors.white,
                    l10n.welcomeCloudSyncFeature2,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    Icons.cloud_upload_outlined,
                    Colors.white,
                    l10n.welcomeCloudSyncFeature3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建特性条目
  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    Color color,
    String text,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: color,
                ),
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
              content:
                  Text(AppLocalizations.of(context).privacyOpenSourceUrlError),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context).privacyOpenSourceUrlError),
          ),
        );
      }
    }
  }

  /// 完成欢迎页面
  Future<void> _finishWelcome(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcome_shown', true);

    if (context.mounted) {
      // 首次启动的情况，标记欢迎页面已完成，触发重新构建
      // 这将显示启屏页面（如果初始化未完成）或主应用（如果已完成）
      ref.read(shouldShowWelcomeProvider.notifier).state = false;
    }
  }
}
