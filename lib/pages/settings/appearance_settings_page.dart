import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../providers/theme_providers.dart';
import '../../widgets/ui/ui.dart';
import '../../widgets/biz/biz.dart';
import '../../styles/tokens.dart';
import './personalize_page.dart';
import './font_settings_page.dart';
import './language_settings_page.dart';
import './widget_management_page.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/ui_scale_extensions.dart';

/// 外观设置二级页面
class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final patternStyle = ref.watch(darkModePatternStyleProvider);
    final isDark = BeeTokens.isDark(context);
    final l10n = AppLocalizations.of(context);

    String languageDisplay;
    if (currentLanguage == null) {
      languageDisplay = l10n.languageSystemDefault;
    } else {
      switch (currentLanguage.languageCode) {
        case 'zh':
          languageDisplay = l10n.languageChinese;
          break;
        case 'en':
          languageDisplay = l10n.languageEnglish;
          break;
        default:
          languageDisplay = currentLanguage.languageCode;
      }
    }

    // 主题模式显示文本
    String themeModeDisplay;
    switch (themeMode) {
      case ThemeMode.light:
        themeModeDisplay = l10n.appearanceThemeModeLight;
        break;
      case ThemeMode.dark:
        themeModeDisplay = l10n.appearanceThemeModeDark;
        break;
      default:
        themeModeDisplay = l10n.appearanceThemeModeSystem;
    }

    // 图案样式显示文本
    String patternDisplay;
    switch (patternStyle) {
      case 'none':
        patternDisplay = l10n.appearancePatternNone;
        break;
      case 'particles':
        patternDisplay = l10n.appearancePatternParticles;
        break;
      case 'honeycomb':
        patternDisplay = l10n.appearancePatternHoneycomb;
        break;
      default:
        patternDisplay = l10n.appearancePatternIcons;
    }

    return Scaffold(
      backgroundColor: BeeTokens.scaffoldBackground(context),
      body: Column(
        children: [
          PrimaryHeader(
            title: l10n.appearanceSettingsPageTitle,
            subtitle: l10n.appearanceSettingsPageSubtitle,
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 显示设置 SectionCard
                SectionCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // 外观模式
                      AppListTile(
                        leading: Icons.brightness_6_outlined,
                        title: l10n.appearanceThemeMode,
                        subtitle: themeModeDisplay,
                        onTap: () => _showThemeModeDialog(context, ref, l10n),
                      ),
                      BeeTokens.cardDivider(context),
                      // 暗黑模式头部图案（仅暗黑模式下可用）
                      AppListTile(
                        leading: Icons.auto_awesome_outlined,
                        title: l10n.appearanceDarkModePattern,
                        subtitle: patternDisplay,
                        enabled: isDark,
                        onTap: isDark ? () => _showPatternStyleDialog(context, ref, l10n) : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // 桌面小组件
                      AppListTile(
                        leading: Icons.widgets_outlined,
                        title: l10n.widgetManagement,
                        subtitle: l10n.widgetManagementDesc,
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const WidgetManagementPage()),
                          );
                        },
                      ),
                      BeeTokens.cardDivider(context),
                      // 个性化
                      AppListTile(
                        leading: Icons.brush_outlined,
                        title: l10n.minePersonalize,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const PersonalizePage()),
                          );
                        },
                      ),
                      BeeTokens.cardDivider(context),
                      // 显示缩放
                      AppListTile(
                        leading: Icons.zoom_out_map_outlined,
                        title: l10n.mineDisplayScale,
                        subtitle: l10n.mineDisplayScaleSubtitle,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const FontSettingsPage()),
                          );
                        },
                      ),
                      BeeTokens.cardDivider(context),
                      // 语言设置
                      AppListTile(
                        leading: Icons.language_outlined,
                        title: l10n.mineLanguageSettings,
                        subtitle: languageDisplay,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const LanguageSettingsPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 显示主题模式选择对话框
  void _showThemeModeDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final currentMode = ref.read(themeModeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BeeTokens.surfaceElevated(context),
        title: Text(
          l10n.appearanceThemeMode,
          style: TextStyle(color: BeeTokens.textPrimary(context)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModeOption(
              context, ref,
              title: l10n.appearanceThemeModeSystem,
              value: ThemeMode.system,
              currentValue: currentMode,
              icon: Icons.settings_suggest_outlined,
            ),
            _buildModeOption(
              context, ref,
              title: l10n.appearanceThemeModeLight,
              value: ThemeMode.light,
              currentValue: currentMode,
              icon: Icons.light_mode_outlined,
            ),
            _buildModeOption(
              context, ref,
              title: l10n.appearanceThemeModeDark,
              value: ThemeMode.dark,
              currentValue: currentMode,
              icon: Icons.dark_mode_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required ThemeMode value,
    required ThemeMode currentValue,
    required IconData icon,
  }) {
    final isSelected = value == currentValue;
    final primaryColor = ref.watch(primaryColorProvider);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? primaryColor : BeeTokens.iconSecondary(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? primaryColor : BeeTokens.textPrimary(context),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: primaryColor)
          : null,
      onTap: () {
        ref.read(themeModeProvider.notifier).state = value;
        Navigator.pop(context);
      },
    );
  }

  /// 显示图案样式选择对话框
  void _showPatternStyleDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final currentPattern = ref.read(darkModePatternStyleProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BeeTokens.surfaceElevated(context),
        title: Text(
          l10n.appearanceDarkModePattern,
          style: TextStyle(color: BeeTokens.textPrimary(context)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPatternOption(
              context, ref,
              title: l10n.appearancePatternNone,
              value: 'none',
              currentValue: currentPattern,
              icon: Icons.block_outlined,
            ),
            _buildPatternOption(
              context, ref,
              title: l10n.appearancePatternIcons,
              value: 'icons',
              currentValue: currentPattern,
              icon: Icons.grid_view_outlined,
            ),
            _buildPatternOption(
              context, ref,
              title: l10n.appearancePatternParticles,
              value: 'particles',
              currentValue: currentPattern,
              icon: Icons.auto_awesome_outlined,
            ),
            _buildPatternOption(
              context, ref,
              title: l10n.appearancePatternHoneycomb,
              value: 'honeycomb',
              currentValue: currentPattern,
              icon: Icons.hive_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String value,
    required String currentValue,
    required IconData icon,
  }) {
    final isSelected = value == currentValue;
    final primaryColor = ref.watch(primaryColorProvider);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? primaryColor : BeeTokens.iconSecondary(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? primaryColor : BeeTokens.textPrimary(context),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: primaryColor)
          : null,
      onTap: () {
        ref.read(darkModePatternStyleProvider.notifier).state = value;
        Navigator.pop(context);
      },
    );
  }
}
