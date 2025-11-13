import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../widgets/ui/ui.dart';
import '../../widgets/biz/biz.dart';
import '../../styles/colors.dart';
import '../data/import_page.dart';
import '../data/export_page.dart';
import '../category/category_manage_page.dart';
import '../category/category_migration_page.dart';
import '../settings/config_import_export_page.dart';
import '../settings/storage_management_page.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/ui_scale_extensions.dart';

/// 数据管理二级页面
class DataManagementPage extends ConsumerWidget {
  const DataManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: BeeColors.greyBg,
      body: Column(
        children: [
          PrimaryHeader(
            title: AppLocalizations.of(context).dataManagementPageTitle,
            subtitle: AppLocalizations.of(context).dataManagementPageSubtitle,
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 导入导出
                SectionCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // 导入数据
                      Consumer(builder: (ctx, r, _) {
                        final p = r.watch(importProgressProvider);
                        if (!p.running && p.total == 0) {
                          return AppListTile(
                            leading: Icons.file_upload_outlined,
                            title: AppLocalizations.of(context).mineImport,
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const ImportPage()),
                              );
                            },
                          );
                        }
                        if (p.running) {
                          final percent =
                              p.total == 0 ? null : (p.done / p.total).clamp(0.0, 1.0);
                          return AppListTile(
                            leading: Icons.upload_outlined,
                            title: AppLocalizations.of(context).mineImportProgressTitle,
                            subtitle: AppLocalizations.of(context)
                                .mineImportProgressSubtitle(p.done, p.fail, p.ok, p.total),
                            trailing: SizedBox(
                                width: 72, child: LinearProgressIndicator(value: percent)),
                            onTap: null,
                          );
                        }
                        final allOk = (p.done == p.total) && (p.fail == 0);
                        if (allOk) return const _ImportSuccessTile();
                        return AppListTile(
                          leading: Icons.info_outline,
                          title: AppLocalizations.of(context).mineImportCompleteTitle,
                          subtitle:
                              '${AppLocalizations.of(context).commonSuccess} ${p.ok}，${AppLocalizations.of(context).commonFailed} ${p.fail}',
                          onTap: null,
                        );
                      }),
                      const Divider(height: 1, thickness: 0.5),
                      // 导出数据
                      AppListTile(
                        leading: Icons.file_download_outlined,
                        title: AppLocalizations.of(context).mineExport,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ExportPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.0.scaled(context, ref)),
                // 分类和账户管理
                SectionCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // 分类管理
                      AppListTile(
                        leading: Icons.category_outlined,
                        title: AppLocalizations.of(context).mineCategoryManagement,
                        subtitle: AppLocalizations.of(context).mineCategoryManagementSubtitle,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CategoryManagePage()),
                          );
                        },
                      ),
                      const Divider(height: 1, thickness: 0.5),
                      // 分类迁移
                      AppListTile(
                        leading: Icons.swap_horiz,
                        title: AppLocalizations.of(context).mineCategoryMigration,
                        subtitle: AppLocalizations.of(context).mineCategoryMigrationSubtitle,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CategoryMigrationPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.0.scaled(context, ref)),
                // 配置管理
                SectionCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // 配置导入导出
                      AppListTile(
                        leading: Icons.settings_backup_restore,
                        title: AppLocalizations.of(context).configImportExportTitle,
                        subtitle: AppLocalizations.of(context).configImportExportSubtitle,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ConfigImportExportPage()),
                          );
                        },
                      ),
                      const Divider(height: 1, thickness: 0.5),
                      // 存储空间管理
                      AppListTile(
                        leading: Icons.storage_outlined,
                        title: AppLocalizations.of(context).storageManagementTitle,
                        subtitle: AppLocalizations.of(context).storageManagementSubtitle,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const StorageManagementPage()),
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

// 导入完成后的短暂动画提示：线性进度条从 0 -> 100%
class _ImportSuccessTile extends StatelessWidget {
  const _ImportSuccessTile();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (ctx, v, child) {
        return AppListTile(
          leading: Icons.check_circle_outline,
          title: AppLocalizations.of(ctx).mineImportCompleteTitle,
          subtitle: AppLocalizations.of(ctx).mineImportCompleteAllSuccess,
          trailing: SizedBox(
            width: 72,
            child: LinearProgressIndicator(
              value: v,
              valueColor: AlwaysStoppedAnimation(primary),
            ),
          ),
        );
      },
    );
  }
}
