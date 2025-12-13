import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers.dart';
import '../../widgets/ui/ui.dart';
import '../../widgets/biz/biz.dart';
import '../../styles/tokens.dart';
import '../data/import_page.dart';
import '../data/export_page.dart';
import '../category/category_manage_page.dart';
import '../category/category_migration_page.dart';
import '../tag/tag_manage_page.dart';
import '../settings/config_import_export_page.dart';
import '../settings/storage_management_page.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/ui_scale_extensions.dart';
import '../../services/attachment_export_import_service.dart';

/// 数据管理二级页面
class DataManagementPage extends ConsumerStatefulWidget {
  const DataManagementPage({super.key});

  @override
  ConsumerState<DataManagementPage> createState() => _DataManagementPageState();
}

class _DataManagementPageState extends ConsumerState<DataManagementPage> {
  bool _isExporting = false;
  bool _isImporting = false;
  int _exportProgress = 0;
  int _exportTotal = 0;
  int _importProgress = 0;
  int _importTotal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeeTokens.scaffoldBackground(context),
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
                // 提示文案
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    AppLocalizations.of(context).dataManagementAttachmentHint,
                    style: TextStyle(
                      fontSize: 12,
                      color: BeeTokens.textTertiary(context),
                    ),
                  ),
                ),
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
                      BeeTokens.cardDivider(context),
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
                // 附件导出导入
                _buildAttachmentSection(context, ref),
                SizedBox(height: 8.0.scaled(context, ref)),
                // 分类管理
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
                      BeeTokens.cardDivider(context),
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
                // 标签管理
                SectionCard(
                  margin: EdgeInsets.zero,
                  child: AppListTile(
                    leading: Icons.label_outline,
                    title: AppLocalizations.of(context).tagManageTitle,
                    subtitle: AppLocalizations.of(context).tagManageSubtitle,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TagManagePage()),
                      );
                    },
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
                      BeeTokens.cardDivider(context),
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

  // ============================================
  // 附件导出导入相关
  // ============================================

  Widget _buildAttachmentSection(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final primary = ref.watch(primaryColorProvider);

    return SectionCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 导出附件
          AppListTile(
            leading: Icons.upload_file,
            title: l10n.attachmentExportTitle,
            subtitle: l10n.attachmentExportSubtitle,
            trailing: _isExporting
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primary,
                    ),
                  )
                : null,
            onTap: _isExporting ? null : _handleExport,
          ),
          // 导出进度
          if (_isExporting && _exportTotal > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: _exportProgress / _exportTotal,
                    backgroundColor: BeeTokens.divider(context),
                    color: primary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.attachmentExportProgress(_exportProgress, _exportTotal),
                    style: TextStyle(
                      fontSize: 12,
                      color: BeeTokens.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          BeeTokens.cardDivider(context),
          // 导入附件
          AppListTile(
            leading: Icons.download,
            title: l10n.attachmentImportTitle,
            subtitle: l10n.attachmentImportSubtitle,
            trailing: _isImporting
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primary,
                    ),
                  )
                : null,
            onTap: _isImporting ? null : _selectImportFile,
          ),
          // 导入进度
          if (_isImporting && _importTotal > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: _importProgress / _importTotal,
                    backgroundColor: BeeTokens.divider(context),
                    color: primary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.attachmentImportProgress(_importProgress, _importTotal),
                    style: TextStyle(
                      fontSize: 12,
                      color: BeeTokens.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleExport() async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(attachmentExportImportServiceProvider);

    // 检查是否有附件
    final repo = ref.read(repositoryProvider);
    final attachments = await repo.getAllAttachments();
    if (attachments.isEmpty) {
      if (mounted) {
        showToast(context, l10n.attachmentExportEmpty);
      }
      return;
    }

    setState(() {
      _isExporting = true;
      _exportProgress = 0;
      _exportTotal = attachments.length;
    });

    final exportPath = await service.exportAttachments(
      onProgress: (current, total) {
        if (mounted) {
          setState(() {
            _exportProgress = current;
            _exportTotal = total;
          });
        }
      },
    );

    setState(() {
      _isExporting = false;
    });

    if (!mounted) return;

    if (exportPath != null) {
      showToast(context, l10n.attachmentExportSuccess);

      // iOS 弹出分享
      if (Platform.isIOS) {
        await Share.shareXFiles([XFile(exportPath)]);
      } else {
        // Android 显示保存路径
        showToast(context, l10n.attachmentExportSavedTo(exportPath));
      }
    } else {
      showToast(context, l10n.attachmentExportFailed);
    }
  }

  Future<void> _selectImportFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['gz', 'tar'],
    );

    if (result == null || result.files.isEmpty) return;

    final filePath = result.files.first.path;
    if (filePath == null) return;

    final service = ref.read(attachmentExportImportServiceProvider);
    final info = await service.previewArchive(filePath);

    if (!mounted) return;

    if (info == null) {
      showToast(context, AppLocalizations.of(context).attachmentImportFailed);
      return;
    }

    // 显示确认弹窗
    final conflictStrategy = await _showImportConfirmDialog(filePath, info);
    if (conflictStrategy != null) {
      await _handleImport(filePath, info, conflictStrategy);
    }
  }

  Future<String?> _showImportConfirmDialog(
    String filePath,
    AttachmentArchiveInfo info,
  ) async {
    final l10n = AppLocalizations.of(context);
    final primary = ref.read(primaryColorProvider);
    String conflictStrategy = AttachmentExportImportService.conflictSkip;

    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text(l10n.attachmentImportTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 文件名
                  Row(
                    children: [
                      Icon(Icons.archive, size: 20, color: primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          filePath.split('/').last,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 归档信息
                  Text(
                    l10n.attachmentArchiveInfo(
                      info.count,
                      info.exportedAt != null
                          ? DateFormat('yyyy-MM-dd HH:mm').format(info.exportedAt!)
                          : '-',
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: BeeTokens.textSecondary(ctx),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 冲突策略
                  Text(
                    l10n.attachmentImportConflictStrategy,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  // 跳过选项
                  RadioListTile<String>(
                    title: Text(l10n.attachmentImportConflictSkip, style: const TextStyle(fontSize: 14)),
                    value: AttachmentExportImportService.conflictSkip,
                    groupValue: conflictStrategy,
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() => conflictStrategy = v);
                      }
                    },
                    activeColor: primary,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    visualDensity: VisualDensity.compact,
                  ),
                  // 覆盖选项
                  RadioListTile<String>(
                    title: Text(l10n.attachmentImportConflictOverwrite, style: const TextStyle(fontSize: 14)),
                    value: AttachmentExportImportService.conflictOverwrite,
                    groupValue: conflictStrategy,
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() => conflictStrategy = v);
                      }
                    },
                    activeColor: primary,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(null),
                  child: Text(l10n.commonCancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(conflictStrategy),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(l10n.attachmentStartImport),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleImport(
    String filePath,
    AttachmentArchiveInfo info,
    String conflictStrategy,
  ) async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(attachmentExportImportServiceProvider);

    setState(() {
      _isImporting = true;
      _importProgress = 0;
      _importTotal = info.count;
    });

    final result = await service.importAttachments(
      archivePath: filePath,
      conflictStrategy: conflictStrategy,
      onProgress: (current, total) {
        if (mounted) {
          setState(() {
            _importProgress = current;
            _importTotal = total;
          });
        }
      },
    );

    setState(() {
      _isImporting = false;
    });

    if (!mounted) return;

    if (result.success) {
      showToast(
        context,
        l10n.attachmentImportResult(
          result.imported,
          result.skipped,
          result.overwritten,
          result.failed,
        ),
      );
    } else {
      showToast(context, result.message ?? l10n.attachmentImportFailed);
    }
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
