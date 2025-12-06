import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../styles/tokens.dart';
import '../../widgets/ui/ui.dart';
import '../../providers/theme_providers.dart';
import 'amount_text.dart';
import 'tag_chip.dart';

class TransactionListItem extends ConsumerWidget {
  final IconData icon;
  final String title;
  final double amount;
  final bool isExpense; // 决定正负号
  final bool? hide; // 改为可选,null时使用全局状态
  final VoidCallback? onTap;
  final VoidCallback? onCategoryTap; // 点击分类图标/名称的回调
  final String? categoryName; // 分类名称，用于显示
  final VoidCallback? onDelete; // 删除回调
  final String? accountName; // 账户名称，用于显示
  final DateTime? happenedAt; // 交易时间，用于显示时分

  // 批量选择模式相关
  final bool isSelectionMode; // 是否处于选择模式
  final bool isSelected; // 是否被选中
  final VoidCallback? onSelectionChanged; // 选中状态改变回调
  final bool showFullDate; // 是否显示完整日期（年-月-日 时:分）

  // 标签相关
  final List<({String name, String? color})>? tags; // 关联的标签

  const TransactionListItem({
      super.key,
      required this.icon,
      required this.title,
      required this.amount,
      required this.isExpense,
      this.hide,
      this.onTap,
      this.onCategoryTap,
      this.categoryName,
      this.onDelete,
      this.accountName,
      this.happenedAt,
      this.isSelectionMode = false,
      this.isSelected = false,
      this.onSelectionChanged,
      this.showFullDate = false,
      this.tags,
  });

  /// 检查是否有次要信息需要显示（时间或账户）
  bool _hasSecondaryInfo(WidgetRef ref) {
    // 显示完整日期模式
    if (showFullDate && happenedAt != null) return true;

    // 显示时间（设置开启 + 有数据 + 不是00:00:00）
    final showTime = ref.watch(showTransactionTimeProvider) &&
        happenedAt != null &&
        (happenedAt!.hour != 0 || happenedAt!.minute != 0 || happenedAt!.second != 0);

    return showTime || accountName != null;
  }

  /// 构建次要信息文本（时间 · 账户）
  String _buildSecondaryText(WidgetRef ref) {
    final parts = <String>[];

    // 时间部分
    if (happenedAt != null) {
      if (showFullDate) {
        // 完整日期模式
        parts.add(
          '${happenedAt!.year}-${happenedAt!.month.toString().padLeft(2, '0')}-${happenedAt!.day.toString().padLeft(2, '0')} '
          '${happenedAt!.hour.toString().padLeft(2, '0')}:${happenedAt!.minute.toString().padLeft(2, '0')}',
        );
      } else if (ref.watch(showTransactionTimeProvider) &&
          (happenedAt!.hour != 0 || happenedAt!.minute != 0 || happenedAt!.second != 0)) {
        // 完整时间模式（HH:mm:ss）
        parts.add(
          '${happenedAt!.hour.toString().padLeft(2, '0')}:${happenedAt!.minute.toString().padLeft(2, '0')}:${happenedAt!.second.toString().padLeft(2, '0')}',
        );
      }
    }

    // 账户部分
    if (accountName != null) {
      parts.add(accountName!);
    }

    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget child = InkWell(
      onTap: isSelectionMode ? onSelectionChanged : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: BeeDimens.listRowVertical),
        child: Row(
          children: [
            // 选择模式下显示复选框，否则显示分类图标
            if (isSelectionMode)
              Checkbox(
                value: isSelected,
                onChanged: (_) => onSelectionChanged?.call(),
                activeColor: Theme.of(context).colorScheme.primary,
              )
            else
              // 分类图标，支持点击跳转
              GestureDetector(
                onTap: onCategoryTap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon,
                      color: Theme.of(context).colorScheme.primary, size: 18),
                ),
              ),
            const SizedBox(width: 12),
            // 左侧：分类名称 + 备注 + 时间·账户
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 第一行：分类名称（始终显示）
                    GestureDetector(
                      onTap: onCategoryTap,
                      child: Text(
                        categoryName ?? title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: BeeTextTokens.title(context),
                      ),
                    ),
                    // 第二行：备注（当title与categoryName不同时显示）
                    if (categoryName != null && categoryName != title)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: BeeTokens.textSecondary(context),
                          ),
                        ),
                      ),
                    // 第三行：时间 · 账户
                    if (_hasSecondaryInfo(ref))
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          _buildSecondaryText(ref),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: BeeTokens.textTertiary(context),
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // 右侧：金额 + 标签
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 金额
                AmountText(
                    value: isExpense ? -amount : amount,
                    hide: hide,
                    signed: true,
                    decimals: 2,
                    style: BeeTextTokens.title(context)),
                // 标签（显示在金额下方）
                if (tags != null && tags!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: TagChipList(
                      tags: tags!,
                      maxDisplay: 2,
                      size: TagChipSize.small,
                      spacing: 4,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );

    // 如果提供了删除回调，则包装在Dismissible中支持侧滑删除
    if (onDelete != null) {
      return Dismissible(
        key: ValueKey('transaction_$title${amount.toString()}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.red,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 24,
          ),
        ),
        confirmDismiss: (direction) async {
          // 显示确认对话框
          return await AppDialog.confirm<bool>(
            context,
            title: '确认删除',
            message: '确定要删除这笔交易吗？此操作无法撤销。',
          ) ?? false;
        },
        onDismissed: (direction) {
          onDelete!();
        },
        child: child,
      );
    }

    return child;
  }
}
