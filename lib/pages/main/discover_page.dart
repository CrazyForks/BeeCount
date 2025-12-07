import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../styles/tokens.dart';
import '../../utils/ui_scale_extensions.dart';
import '../../widgets/ui/ui.dart';
import '../../widgets/biz/section_card.dart';
import '../transaction/recurring_transaction_page.dart';
import 'ledgers_page_new.dart';

/// 发现页
///
/// 包含预算、账户总览、周期记账、账本管理等功能入口
class DiscoverPage extends ConsumerWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final primaryColor = ref.watch(primaryColorProvider);

    return Scaffold(
      backgroundColor: BeeTokens.scaffoldBackground(context),
      body: Column(
        children: [
          PrimaryHeader(
            title: l10n.discoverTitle,
            showBack: false,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0.scaled(context, ref),
                vertical: 8.0.scaled(context, ref),
              ),
              children: [
                // 预算管理卡片
                _BudgetCard(primaryColor: primaryColor),
                SizedBox(height: 12.0.scaled(context, ref)),

                // 账户总览卡片
                _AccountsCard(primaryColor: primaryColor),
                SizedBox(height: 12.0.scaled(context, ref)),

                // 更多功能入口
                _MoreFeaturesCard(primaryColor: primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 预算卡片组件
class _BudgetCard extends ConsumerWidget {
  final Color primaryColor;

  const _BudgetCard({required this.primaryColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    // TODO: 从 budgetProvider 获取数据
    // 当前为占位状态，显示引导设置预算

    return GestureDetector(
      onTap: () {
        // TODO: 跳转预算详情页
        showToast(context, l10n.discoverComingSoon);
      },
      child: SectionCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(16.0.scaled(context, ref)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0.scaled(context, ref)),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.pie_chart_outline,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12.0.scaled(context, ref)),
                  Expanded(
                    child: Text(
                      l10n.discoverBudget,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: BeeTokens.textPrimary(context),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: BeeTokens.iconTertiary(context),
                    size: 20,
                  ),
                ],
              ),
              SizedBox(height: 16.0.scaled(context, ref)),
              // 预算内容区域（占位）
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.scaled(context, ref),
                  vertical: 24.0.scaled(context, ref),
                ),
                decoration: BoxDecoration(
                  color: BeeTokens.scaffoldBackground(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 40,
                      color: primaryColor.withValues(alpha: 0.6),
                    ),
                    SizedBox(height: 8.0.scaled(context, ref)),
                    Text(
                      l10n.discoverBudgetEmpty,
                      style: TextStyle(
                        fontSize: 14,
                        color: BeeTokens.textSecondary(context),
                      ),
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

/// 账户总览卡片组件
class _AccountsCard extends ConsumerWidget {
  final Color primaryColor;

  const _AccountsCard({required this.primaryColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    // TODO: 从 accountsProvider 获取数据

    return GestureDetector(
      onTap: () {
        // TODO: 跳转账户管理页
        showToast(context, l10n.discoverComingSoon);
      },
      child: SectionCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(16.0.scaled(context, ref)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0.scaled(context, ref)),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12.0.scaled(context, ref)),
                  Expanded(
                    child: Text(
                      l10n.discoverAssets,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: BeeTokens.textPrimary(context),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: BeeTokens.iconTertiary(context),
                    size: 20,
                  ),
                ],
              ),
              SizedBox(height: 16.0.scaled(context, ref)),
              // 账户概览区域（占位）
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.scaled(context, ref),
                  vertical: 20.0.scaled(context, ref),
                ),
                decoration: BoxDecoration(
                  color: BeeTokens.scaffoldBackground(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _AccountSummaryItem(
                        label: l10n.discoverAccountsTotal,
                        value: '¥0.00',
                        valueColor: BeeTokens.textPrimary(context),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: BeeTokens.divider(context),
                    ),
                    Expanded(
                      child: _AccountSummaryItem(
                        label: l10n.discoverAccountsDebt,
                        value: '¥0.00',
                        valueColor: Colors.orange,
                      ),
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

/// 账户概览项
class _AccountSummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _AccountSummaryItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: BeeTokens.textSecondary(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

/// 更多功能卡片
class _MoreFeaturesCard extends ConsumerWidget {
  final Color primaryColor;

  const _MoreFeaturesCard({required this.primaryColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return SectionCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _FeatureItem(
            icon: Icons.repeat_rounded,
            iconColor: Colors.teal,
            title: l10n.discoverRecurring,
            subtitle: l10n.discoverRecurringSubtitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RecurringTransactionPage(),
                ),
              );
            },
          ),
          Divider(
            height: 1,
            indent: 56.0.scaled(context, ref),
            color: BeeTokens.divider(context),
          ),
          _FeatureItem(
            icon: Icons.menu_book_outlined,
            iconColor: Colors.purple,
            title: l10n.discoverLedgers,
            subtitle: l10n.discoverLedgersSubtitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LedgersPageNew(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 功能入口项组件
class _FeatureItem extends ConsumerWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0.scaled(context, ref),
          vertical: 14.0.scaled(context, ref),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.0.scaled(context, ref)),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
            SizedBox(width: 12.0.scaled(context, ref)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: BeeTokens.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 2.0.scaled(context, ref)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: BeeTokens.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: BeeTokens.iconTertiary(context),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
