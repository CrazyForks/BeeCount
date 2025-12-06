import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/db.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/tag_providers.dart';
import '../../providers/database_providers.dart';
import '../../services/data/tag_seed_service.dart';
import '../../styles/tokens.dart';
import '../../widgets/ui/ui.dart';
import 'tag_edit_page.dart';

/// 标签管理页面
class TagManagePage extends ConsumerStatefulWidget {
  const TagManagePage({super.key});

  @override
  ConsumerState<TagManagePage> createState() => _TagManagePageState();
}

class _TagManagePageState extends ConsumerState<TagManagePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tagsAsync = ref.watch(tagsWithStatsProvider);

    return Scaffold(
      backgroundColor: BeeTokens.scaffoldBackground(context),
      body: Column(
        children: [
          PrimaryHeader(
            title: l10n.tagManageTitle,
            subtitle: l10n.tagManageSubtitle,
            showBack: true,
            actions: [
              IconButton(
                onPressed: _addTag,
                icon: const Icon(Icons.add),
                tooltip: l10n.tagAddTitle,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'generate_default') {
                    _generateDefaultTags();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'generate_default',
                    child: Row(
                      children: [
                        const Icon(Icons.auto_fix_high, size: 20),
                        const SizedBox(width: 12),
                        Text(l10n.tagManageGenerateDefault),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: tagsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('${l10n.commonError}: $error'),
              ),
              data: (tags) {
                if (tags.isEmpty) {
                  return _buildEmptyState(l10n);
                }
                return _buildTagGrid(tags, l10n);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.label_outline,
            size: 64,
            color: BeeTokens.textTertiary(context),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.tagManageEmpty,
            style: TextStyle(
              fontSize: 16,
              color: BeeTokens.textSecondary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tagManageEmptyHint,
            style: TextStyle(
              fontSize: 14,
              color: BeeTokens.textTertiary(context),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _generateDefaultTags,
            icon: const Icon(Icons.auto_fix_high),
            label: Text(l10n.tagManageGenerateDefault),
          ),
        ],
      ),
    );
  }

  Widget _buildTagGrid(
    List<({Tag tag, int transactionCount})> tags,
    AppLocalizations l10n,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: tags.length,
      itemBuilder: (context, index) {
        final item = tags[index];
        return _TagCard(
          tag: item.tag,
          transactionCount: item.transactionCount,
          onTap: () => _editTag(item.tag),
          onDelete: () => _deleteTag(item.tag, l10n),
        );
      },
    );
  }

  void _addTag() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TagEditPage(),
      ),
    );
  }

  void _editTag(Tag tag) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TagEditPage(tag: tag),
      ),
    );
  }

  void _deleteTag(Tag tag, AppLocalizations l10n) async {
    final confirmed = await AppDialog.confirm<bool>(
      context,
      title: l10n.tagDeleteConfirmTitle,
      message: l10n.tagDeleteConfirmMessage(tag.name),
    );

    if (confirmed == true && mounted) {
      final repo = ref.read(repositoryProvider);
      await repo.deleteTag(tag.id);
      ref.read(tagListRefreshProvider.notifier).state++;

      if (mounted) {
        showToast(context, l10n.tagDeleteSuccess);
      }
    }
  }

  void _generateDefaultTags() async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await AppDialog.confirm<bool>(
      context,
      title: l10n.tagManageGenerateDefault,
      message: l10n.tagManageGenerateDefaultConfirm,
    );

    if (confirmed == true && mounted) {
      final db = ref.read(databaseProvider);
      await TagSeedService.seedDefaultTags(db, l10n);
      ref.read(tagListRefreshProvider.notifier).state++;

      if (mounted) {
        showToast(context, l10n.tagManageGenerateDefaultSuccess);
      }
    }
  }
}

/// 标签卡片
class _TagCard extends StatelessWidget {
  final Tag tag;
  final int transactionCount;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TagCard({
    required this.tag,
    required this.transactionCount,
    required this.onTap,
    required this.onDelete,
  });

  Color _parseColor(BuildContext context) {
    if (tag.color == null || tag.color!.isEmpty) {
      return Theme.of(context).colorScheme.primary;
    }
    try {
      String hex = tag.color!;
      if (hex.startsWith('#')) {
        hex = hex.substring(1);
      }
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tagColor = _parseColor(context);
    final isDark = BeeTokens.isDark(context);

    return Material(
      color: BeeTokens.surface(context),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: tagColor.withValues(alpha: isDark ? 0.4 : 0.3),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              // 背景渐变色块
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tagColor.withValues(alpha: isDark ? 0.15 : 0.1),
                  ),
                ),
              ),
              // 内容
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标签名称
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 颜色指示圆点
                          Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: tagColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tag.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: BeeTokens.textPrimary(context),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 交易数量
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.tagTransactionCount(transactionCount),
                          style: TextStyle(
                            fontSize: 12,
                            color: BeeTokens.textTertiary(context),
                          ),
                        ),
                        // 删除按钮
                        GestureDetector(
                          onTap: onDelete,
                          child: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: BeeTokens.iconTertiary(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
