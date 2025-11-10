import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../widgets/ui/ui.dart';
import '../../widgets/biz/biz.dart';
import '../../styles/colors.dart';
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

    return Scaffold(
      backgroundColor: BeeColors.greyBg,
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
                      const Divider(height: 1, thickness: 0.5),
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
                      const Divider(height: 1, thickness: 0.5),
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
                      const Divider(height: 1, thickness: 0.5),
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
}
