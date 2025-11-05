import 'package:flutter/material.dart';

/// Flutter widget that will be rendered as the home screen widget
class HomeWidgetView extends StatelessWidget {
  final String todayExpense;
  final String todayIncome;
  final String monthExpense;
  final String monthIncome;
  final Color themeColor;
  final String appName;
  final String monthSuffix;
  final String todayExpenseLabel;
  final String todayIncomeLabel;
  final String monthExpenseLabel;
  final String monthIncomeLabel;

  const HomeWidgetView({
    super.key,
    required this.todayExpense,
    required this.todayIncome,
    required this.monthExpense,
    required this.monthIncome,
    required this.themeColor,
    required this.appName,
    required this.monthSuffix,
    required this.todayExpenseLabel,
    required this.todayIncomeLabel,
    required this.monthExpenseLabel,
    required this.monthIncomeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor,
            Color.lerp(themeColor, Colors.black, 0.15)!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                appName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${DateTime.now().month}$monthSuffix',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main content - 2x2 grid
          Expanded(
            child: Row(
              children: [
                // Today's expense
                Expanded(
                  child: _buildStatCard(
                    todayExpenseLabel,
                    todayExpense,
                    const Color(0xFFFF6B6B),
                    Icons.arrow_upward,
                    true,
                  ),
                ),
                const SizedBox(width: 12),
                // Today's income
                Expanded(
                  child: _buildStatCard(
                    todayIncomeLabel,
                    todayIncome,
                    const Color(0xFF51CF66),
                    Icons.arrow_downward,
                    true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                // Month's expense
                Expanded(
                  child: _buildStatCard(
                    monthExpenseLabel,
                    monthExpense,
                    const Color(0xFFFF6B6B),
                    Icons.trending_up,
                    false,
                  ),
                ),
                const SizedBox(width: 12),
                // Month's income
                Expanded(
                  child: _buildStatCard(
                    monthIncomeLabel,
                    monthIncome,
                    const Color(0xFF51CF66),
                    Icons.trending_down,
                    false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
    bool isToday,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: color,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isToday ? 22 : 20,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

}
