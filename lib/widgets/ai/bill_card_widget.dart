import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../ai/tasks/bill_extraction_task.dart';
import '../../widgets/biz/section_card.dart';
import '../../styles/tokens.dart';
import '../../utils/ui_scale_extensions.dart';
import '../../providers.dart';
import '../../l10n/app_localizations.dart';

/// 记账成功卡片组件
class BillCardWidget extends ConsumerWidget {
  final BillInfo billInfo;
  final int? transactionId;
  final VoidCallback? onUndo;
  final VoidCallback? onEdit;
  final bool isUndone; // 是否已撤销

  const BillCardWidget({
    super.key,
    required this.billInfo,
    this.transactionId,
    this.onUndo,
    this.onEdit,
    this.isUndone = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0.scaled(context, ref),
      ),
      child: SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Icon(
                  isUndone ? Icons.cancel : Icons.check_circle,
                  color: isUndone ? Colors.grey : Colors.green,
                  size: 20.0.scaled(context, ref),
                ),
                SizedBox(width: 8.0.scaled(context, ref)),
                Text(
                  isUndone
                      ? AppLocalizations.of(context).billCardUndone
                      : AppLocalizations.of(context).billCardSuccess,
                  style: TextStyle(
                    fontSize: 16.0.scaled(context, ref),
                    fontWeight: FontWeight.w600,
                    color: isUndone
                        ? BeeTokens.textSecondary(context)
                        : BeeTokens.textPrimary(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.0.scaled(context, ref)),
            Divider(color: BeeTokens.divider(context)),
            SizedBox(height: 12.0.scaled(context, ref)),

            // 信息行
            _buildInfoRow(
              context,
              ref,
              AppLocalizations.of(context).billCardAmount,
              '¥${billInfo.amount?.abs().toStringAsFixed(2) ?? '0.00'}',
            ),
            SizedBox(height: 8.0.scaled(context, ref)),
            _buildInfoRow(
              context,
              ref,
              AppLocalizations.of(context).billCardCategory,
              billInfo.category ?? '其他',
            ),
            SizedBox(height: 8.0.scaled(context, ref)),
            _buildInfoRow(
              context,
              ref,
              AppLocalizations.of(context).billCardTime,
              _formatTime(billInfo.time),
            ),
            if (billInfo.merchant != null && billInfo.merchant!.isNotEmpty) ...[
              SizedBox(height: 8.0.scaled(context, ref)),
              _buildInfoRow(
                context,
                ref,
                AppLocalizations.of(context).billCardNote,
                billInfo.merchant!,
              ),
            ],

            SizedBox(height: 16.0.scaled(context, ref)),

            // 操作按钮
            if (!isUndone)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onUndo != null)
                    TextButton(
                      onPressed: onUndo,
                      child: Text(
                        AppLocalizations.of(context).billCardUndo,
                        style: TextStyle(
                          color: BeeTokens.textSecondary(context),
                        ),
                      ),
                    ),
                  if (onUndo != null && onEdit != null)
                    SizedBox(width: 8.0.scaled(context, ref)),
                  if (onEdit != null)
                    OutlinedButton(
                      onPressed: onEdit,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: ref.watch(primaryColorProvider),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context).billCardEdit,
                        style: TextStyle(
                          color: ref.watch(primaryColorProvider),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    WidgetRef ref,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.0.scaled(context, ref),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.0.scaled(context, ref),
              color: BeeTokens.textSecondary(context),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.0.scaled(context, ref),
              color: BeeTokens.textPrimary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '今天';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(time.year, time.month, time.day);

    if (targetDay == today) {
      return '今天 ${DateFormat('HH:mm').format(time)}';
    } else if (targetDay == today.subtract(const Duration(days: 1))) {
      return '昨天 ${DateFormat('HH:mm').format(time)}';
    } else if (time.year == now.year) {
      return DateFormat('MM月dd日 HH:mm').format(time);
    } else {
      return DateFormat('yyyy年MM月dd日 HH:mm').format(time);
    }
  }
}
