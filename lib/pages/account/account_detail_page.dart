import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db.dart' as db;
import '../../providers.dart';
import '../../widgets/ui/ui.dart';
import '../../widgets/biz/biz.dart';
import '../../styles/colors.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/ui_scale_extensions.dart';
import '../../utils/transaction_edit_utils.dart';

/// 账户详情页面
/// 显示账户的统计信息和相关交易
class AccountDetailPage extends ConsumerWidget {
  final db.Account account;

  const AccountDetailPage({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final primaryColor = ref.watch(primaryColorProvider);
    final statsAsync = ref.watch(accountStatsProvider(account.id));
    final transactionsAsync =
        ref.watch(accountTransactionsProvider(account.id));
    final currentLedgerAsync = ref.watch(currentLedgerProvider);
    final currencyCode = currentLedgerAsync.asData?.value?.currency ?? 'CNY';

    return Scaffold(
      backgroundColor: BeeColors.greyBg,
      body: Column(
        children: [
          PrimaryHeader(
            title: account.name,
            subtitle: _getTypeLabel(context, account.type),
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 16.0.scaled(context, ref),
              ),
              children: [
                // 统计卡片
                SectionCard(
                  child: statsAsync.when(
                    data: (stats) => Padding(
                      padding: EdgeInsets.all(12.0.scaled(context, ref)),
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatCell(
                              label: l10n.accountBalance,
                              value: stats.balance,
                              currencyCode: currencyCode,
                              color: stats.balance >= 0
                                  ? BeeColors.primaryText
                                  : Colors.red,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40.0.scaled(context, ref),
                            color: Colors.grey[300],
                          ),
                          Expanded(
                            child: _StatCell(
                              label: l10n.homeIncome,
                              value: stats.income,
                              currencyCode: currencyCode,
                              color: Colors.green,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40.0.scaled(context, ref),
                            color: Colors.grey[300],
                          ),
                          Expanded(
                            child: _StatCell(
                              label: l10n.homeExpense,
                              value: stats.expense,
                              currencyCode: currencyCode,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading: () => Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0.scaled(context, ref)),
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, stack) => Padding(
                      padding: EdgeInsets.all(16.0.scaled(context, ref)),
                      child: Text(
                        '${l10n.commonError}: $err',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0.scaled(context, ref)),
                // 交易列表
                SectionCard(
                  child: transactionsAsync.when(
                    data: (transactions) {
                      if (transactions.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(32.0.scaled(context, ref)),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 48.0.scaled(context, ref),
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 8.0.scaled(context, ref)),
                                Text(
                                  l10n.accountNoTransactions,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(12.0.scaled(context, ref)),
                            child: Text(
                              l10n.accountTransactionHistory,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: BeeColors.primaryText,
                              ),
                            ),
                          ),
                          ...transactions.asMap().entries.map((entry) {
                            final index = entry.key;
                            final tx = entry.value;

                            return Column(
                              children: [
                                if (index > 0)
                                  const Divider(height: 1, thickness: 0.5),
                                _TransactionTile(
                                  transaction: tx,
                                  currencyCode: currencyCode,
                                  primaryColor: primaryColor,
                                  onTap: () =>
                                      _editTransaction(context, ref, tx),
                                ),
                              ],
                            );
                          }),
                        ],
                      );
                    },
                    loading: () => Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0.scaled(context, ref)),
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, stack) => Padding(
                      padding: EdgeInsets.all(16.0.scaled(context, ref)),
                      child: Text(
                        '${l10n.commonError}: $err',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case 'cash':
        return l10n.accountTypeCash;
      case 'bank_card':
        return l10n.accountTypeBankCard;
      case 'credit_card':
        return l10n.accountTypeCreditCard;
      case 'alipay':
        return l10n.accountTypeAlipay;
      case 'wechat':
        return l10n.accountTypeWechat;
      case 'other':
        return l10n.accountTypeOther;
      default:
        return type;
    }
  }

  Future<void> _editTransaction(
      BuildContext context, WidgetRef ref, db.Transaction tx) async {
    // 先获取分类信息
    final categoryAsync = tx.categoryId != null
        ? await ref.read(categoriesProvider.future)
        : null;
    final category = categoryAsync?.cast<db.Category?>().firstWhere(
          (c) => c?.id == tx.categoryId,
          orElse: () => null,
        );

    if (!context.mounted) return;
    await TransactionEditUtils.editTransaction(context, ref, tx, category);

    // 刷新统计数据
    ref.invalidate(accountStatsProvider(account.id));
    ref.invalidate(accountTransactionsProvider(account.id));
  }
}

/// 统计单元格
class _StatCell extends ConsumerWidget {
  final String label;
  final double value;
  final String currencyCode;
  final Color color;

  const _StatCell({
    required this.label,
    required this.value,
    required this.currencyCode,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AmountText(
          value: value,
          signed: false,
          showCurrency: true,
          useCompactFormat: true,
          currencyCode: currencyCode,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.0.scaled(context, ref)),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

/// 交易列表项
class _TransactionTile extends ConsumerWidget {
  final db.Transaction transaction;
  final String currencyCode;
  final Color primaryColor;
  final VoidCallback onTap;

  const _TransactionTile({
    required this.transaction,
    required this.currencyCode,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 交易类型颜色
    Color amountColor;
    final l10n = AppLocalizations.of(context);

    switch (transaction.type) {
      case 'income':
        amountColor = Colors.green;
        break;
      case 'expense':
        amountColor = Colors.red;
        break;
      case 'transfer':
        amountColor = Colors.orange;
        break;
      default:
        amountColor = BeeColors.primaryText;
    }

    // 显示交易金额或备注作为标题
    String displayTitle = transaction.note?.isNotEmpty == true
        ? transaction.note!
        : (transaction.type == 'income'
            ? l10n.homeIncome
            : transaction.type == 'expense'
                ? l10n.homeExpense
                : 'Transfer');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0.scaled(context, ref),
          vertical: 12.0.scaled(context, ref),
        ),
        child: Row(
          children: [
            // 图标
            Container(
              width: 40.0.scaled(context, ref),
              height: 40.0.scaled(context, ref),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForType(transaction.type),
                color: primaryColor,
                size: 20.0.scaled(context, ref),
              ),
            ),
            SizedBox(width: 12.0.scaled(context, ref)),
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayTitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: BeeColors.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0.scaled(context, ref)),
                    child: Text(
                      _formatDate(transaction.happenedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 金额
            AmountText(
              value: transaction.type == 'expense' || transaction.type == 'transfer'
                  ? -transaction.amount
                  : transaction.amount,
              signed: true,
              showCurrency: false,
              currencyCode: currencyCode,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'income':
        return Icons.add_circle_outline;
      case 'expense':
        return Icons.remove_circle_outline;
      case 'transfer':
        return Icons.swap_horiz;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final local = date.toLocal();

    if (local.year == now.year &&
        local.month == now.month &&
        local.day == now.day) {
      return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    }

    return '${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

// Provider: 账户相关的交易列表
final accountTransactionsProvider = StreamProvider.family
    .autoDispose<List<db.Transaction>, int>((ref, accountId) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchAccountTransactions(accountId);
});
