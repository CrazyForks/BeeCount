class WidgetData {
  final String ledgerName;
  final double balance;
  final String balanceText;
  final double todayExpense;
  final String todayExpenseText;
  final double monthExpense;
  final String monthExpenseText;
  final List<RecentTransaction> recentTransactions;
  final String currency;
  final DateTime lastUpdated;

  // 国际化相关
  final String locale;
  final String todayLabel;
  final String monthLabel;
  final String balanceLabel;
  final String quickAddLabel;
  final String viewReportsLabel;

  // 主题色配置
  final String primaryColor;
  final String backgroundColor;
  final String textColor;
  final String accentColor;

  // 图标相关
  final String ledgerIcon;
  final bool isDarkMode;

  const WidgetData({
    required this.ledgerName,
    required this.balance,
    required this.balanceText,
    required this.todayExpense,
    required this.todayExpenseText,
    required this.monthExpense,
    required this.monthExpenseText,
    required this.recentTransactions,
    required this.currency,
    required this.lastUpdated,

    // 国际化默认值
    this.locale = 'zh',
    this.todayLabel = '今日支出',
    this.monthLabel = '本月支出',
    this.balanceLabel = '余额',
    this.quickAddLabel = '快速记账',
    this.viewReportsLabel = '查看报表',

    // 主题色默认值
    this.primaryColor = '#2E7D32',
    this.backgroundColor = '#FFFFFF',
    this.textColor = '#333333',
    this.accentColor = '#FFC107',

    // 图标默认值
    this.ledgerIcon = 'account_balance_wallet',
    this.isDarkMode = false,
  });

  Map<String, dynamic> toJson() => {
        'ledgerName': ledgerName,
        'balance': balance,
        'balanceText': balanceText,
        'todayExpense': todayExpense,
        'todayExpenseText': todayExpenseText,
        'monthExpense': monthExpense,
        'monthExpenseText': monthExpenseText,
        'recentTransactions': recentTransactions.map((t) => t.toJson()).toList(),
        'currency': currency,
        'lastUpdated': lastUpdated.toIso8601String(),

        // 国际化字段
        'locale': locale,
        'todayLabel': todayLabel,
        'monthLabel': monthLabel,
        'balanceLabel': balanceLabel,
        'quickAddLabel': quickAddLabel,
        'viewReportsLabel': viewReportsLabel,

        // 主题色字段
        'primaryColor': primaryColor,
        'backgroundColor': backgroundColor,
        'textColor': textColor,
        'accentColor': accentColor,

        // 图标字段
        'ledgerIcon': ledgerIcon,
        'isDarkMode': isDarkMode,
      };

  factory WidgetData.fromJson(Map<String, dynamic> json) => WidgetData(
        ledgerName: json['ledgerName'] as String,
        balance: json['balance'] as double,
        balanceText: json['balanceText'] as String,
        todayExpense: json['todayExpense'] as double,
        todayExpenseText: json['todayExpenseText'] as String,
        monthExpense: json['monthExpense'] as double? ?? 0.0,
        monthExpenseText: json['monthExpenseText'] as String? ?? '¥0.00',
        recentTransactions: (json['recentTransactions'] as List)
            .map((t) => RecentTransaction.fromJson(t))
            .toList(),
        currency: json['currency'] as String,
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),

        // 国际化字段
        locale: json['locale'] as String? ?? 'zh',
        todayLabel: json['todayLabel'] as String? ?? '今日支出',
        monthLabel: json['monthLabel'] as String? ?? '本月支出',
        balanceLabel: json['balanceLabel'] as String? ?? '余额',
        quickAddLabel: json['quickAddLabel'] as String? ?? '快速记账',
        viewReportsLabel: json['viewReportsLabel'] as String? ?? '查看报表',

        // 主题色字段
        primaryColor: json['primaryColor'] as String? ?? '#2E7D32',
        backgroundColor: json['backgroundColor'] as String? ?? '#FFFFFF',
        textColor: json['textColor'] as String? ?? '#333333',
        accentColor: json['accentColor'] as String? ?? '#FFC107',

        // 图标字段
        ledgerIcon: json['ledgerIcon'] as String? ?? 'account_balance_wallet',
        isDarkMode: json['isDarkMode'] as bool? ?? false,
      );
}

class RecentTransaction {
  final String description;
  final double amount;
  final String amountText;
  final String category;
  final DateTime date;
  final bool isIncome;

  const RecentTransaction({
    required this.description,
    required this.amount,
    required this.amountText,
    required this.category,
    required this.date,
    required this.isIncome,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'amount': amount,
        'amountText': amountText,
        'category': category,
        'date': date.toIso8601String(),
        'isIncome': isIncome,
      };

  factory RecentTransaction.fromJson(Map<String, dynamic> json) =>
      RecentTransaction(
        description: json['description'] as String,
        amount: json['amount'] as double,
        amountText: json['amountText'] as String,
        category: json['category'] as String,
        date: DateTime.parse(json['date'] as String),
        isIncome: json['isIncome'] as bool,
      );
}