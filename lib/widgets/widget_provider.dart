import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/repository.dart';
import '../providers.dart';
import '../providers/ui_state_providers.dart';
import '../providers/theme_providers.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import '../styles/colors.dart';
import 'widget_data.dart';

final widgetDataProvider = FutureProvider<WidgetData>((ref) async {
  final repository = ref.watch(repositoryProvider);
  final currentLedger = await ref.watch(currentLedgerProvider.future);

  // 获取主题色设置
  final primaryColor = ref.watch(primaryColorProvider);
  final isDarkMode = false; // 暂时硬编码，可以后续添加到providers中

  // 获取语言设置
  final locale = ref.watch(languageProvider);
  final localeString = locale?.languageCode ?? 'zh';

  // 国际化标签
  final labels = _getLocalizedLabels(localeString);

  // 主题色配置
  final colors = _getThemeColors(primaryColor, isDarkMode);

  if (currentLedger == null) {
    return WidgetData(
      ledgerName: labels['noLedger'] ?? '暂无账本',
      balance: 0.0,
      balanceText: '¥0.00',
      todayExpense: 0.0,
      todayExpenseText: '¥0.00',
      monthExpense: 0.0,
      monthExpenseText: '¥0.00',
      recentTransactions: [],
      currency: '¥',
      lastUpdated: DateTime.now(),

      // 国际化字段
      locale: localeString,
      todayLabel: labels['todayExpense'] ?? '今日支出',
      monthLabel: labels['monthExpense'] ?? '本月支出',
      balanceLabel: labels['balance'] ?? '余额',
      quickAddLabel: labels['quickAdd'] ?? '快速记账',
      viewReportsLabel: labels['viewReports'] ?? '查看报表',

      // 主题色字段
      primaryColor: colors['primary']!,
      backgroundColor: colors['background']!,
      textColor: colors['text']!,
      accentColor: colors['accent']!,

      // 图标字段
      ledgerIcon: 'account_balance_wallet',
      isDarkMode: isDarkMode,
    );
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final monthStart = DateTime(now.year, now.month, 1);
  final monthEnd = DateTime(now.year, now.month + 1, 1);

  // 获取余额
  final balance = await repository.getCurrentBalance(ledgerId: currentLedger.id);

  // 获取今日支出统计
  final expenseData = await repository.totalsByCategory(
    ledgerId: currentLedger.id,
    type: 'expense',
    start: today,
    end: today.add(const Duration(days: 1)),
  );

  final todayExpense = expenseData.fold(0.0, (sum, item) => sum + item.total);

  // 获取本月支出统计
  final monthExpenseData = await repository.totalsByCategory(
    ledgerId: currentLedger.id,
    type: 'expense',
    start: monthStart,
    end: monthEnd,
  );

  final monthExpense = monthExpenseData.fold(0.0, (sum, item) => sum + item.total);

  // 获取最近交易流的第一次数据
  final recentTransactionsStream = repository.recentTransactions(
    ledgerId: currentLedger.id,
    limit: 5
  );
  final recentTransactions = await recentTransactionsStream.first;

  final currencyFormat = NumberFormat.currency(symbol: '¥');

  return WidgetData(
    ledgerName: currentLedger.name,
    balance: balance,
    balanceText: currencyFormat.format(balance),
    todayExpense: todayExpense,
    todayExpenseText: currencyFormat.format(todayExpense),
    monthExpense: monthExpense,
    monthExpenseText: currencyFormat.format(monthExpense),
    recentTransactions: recentTransactions.map((t) => RecentTransaction(
      description: t.note ?? (labels['noNote'] ?? '无备注'),
      amount: t.amount,
      amountText: currencyFormat.format(t.amount.abs()),
      category: '其他', // 暂时使用固定值，后续可通过join获取分类名称
      date: t.happenedAt,
      isIncome: t.type == 'income',
    )).toList(),
    currency: '¥',
    lastUpdated: DateTime.now(),

    // 国际化字段
    locale: localeString,
    todayLabel: labels['todayExpense'] ?? '今日支出',
    monthLabel: labels['monthExpense'] ?? '本月支出',
    balanceLabel: labels['balance'] ?? '余额',
    quickAddLabel: labels['quickAdd'] ?? '快速记账',
    viewReportsLabel: labels['viewReports'] ?? '查看报表',

    // 主题色字段
    primaryColor: colors['primary']!,
    backgroundColor: colors['background']!,
    textColor: colors['text']!,
    accentColor: colors['accent']!,

    // 图标字段
    ledgerIcon: _getLedgerIcon(currentLedger.name),
    isDarkMode: isDarkMode,
  );
});

final widgetUpdateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class WidgetNotifier extends StateNotifier<AsyncValue<WidgetData>> {
  WidgetNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadData();
  }

  final Ref ref;

  Future<void> _loadData() async {
    try {
      final data = await ref.read(widgetDataProvider.future);
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    ref.invalidate(widgetDataProvider);
    await _loadData();
    ref.read(widgetUpdateProvider.notifier).state = DateTime.now();
  }
}

final widgetNotifierProvider = StateNotifierProvider<WidgetNotifier, AsyncValue<WidgetData>>((ref) {
  return WidgetNotifier(ref);
});

// 国际化标签映射
Map<String, String> _getLocalizedLabels(String locale) {
  switch (locale) {
    case 'en':
      return {
        'noLedger': 'No Ledger',
        'todayExpense': 'Today',
        'monthExpense': 'This Month',
        'balance': 'Balance',
        'quickAdd': 'Quick Add',
        'viewReports': 'Reports',
        'noNote': 'No Note',
      };
    case 'ja':
      return {
        'noLedger': '帳簿なし',
        'todayExpense': '今日の支出',
        'monthExpense': '今月の支出',
        'balance': '残高',
        'quickAdd': 'クイック追加',
        'viewReports': 'レポート',
        'noNote': 'メモなし',
      };
    case 'ko':
      return {
        'noLedger': '장부 없음',
        'todayExpense': '오늘 지출',
        'monthExpense': '이번 달 지출',
        'balance': '잔액',
        'quickAdd': '빠른 추가',
        'viewReports': '보고서',
        'noNote': '메모 없음',
      };
    case 'fr':
      return {
        'noLedger': 'Aucun registre',
        'todayExpense': 'Aujourd\'hui',
        'monthExpense': 'Ce mois',
        'balance': 'Solde',
        'quickAdd': 'Ajout rapide',
        'viewReports': 'Rapports',
        'noNote': 'Aucune note',
      };
    case 'de':
      return {
        'noLedger': 'Kein Hauptbuch',
        'todayExpense': 'Heute',
        'monthExpense': 'Diesen Monat',
        'balance': 'Saldo',
        'quickAdd': 'Schnell hinzufügen',
        'viewReports': 'Berichte',
        'noNote': 'Keine Notiz',
      };
    case 'es':
      return {
        'noLedger': 'Sin libro mayor',
        'todayExpense': 'Hoy',
        'monthExpense': 'Este mes',
        'balance': 'Saldo',
        'quickAdd': 'Agregar rápido',
        'viewReports': 'Informes',
        'noNote': 'Sin nota',
      };
    default: // 中文
      return {
        'noLedger': '暂无账本',
        'todayExpense': '今日支出',
        'monthExpense': '本月支出',
        'balance': '余额',
        'quickAdd': '快速记账',
        'viewReports': '查看报表',
        'noNote': '无备注',
      };
  }
}

// 主题色配置
Map<String, String> _getThemeColors(dynamic primaryColor, bool isDarkMode) {
  final color = primaryColor as Color;
  final primary = color.value.toRadixString(16).padLeft(8, '0').substring(2);

  if (isDarkMode) {
    return {
      'primary': '#$primary',
      'background': '#121212',
      'text': '#FFFFFF',
      'accent': '#FFC107',
    };
  } else {
    return {
      'primary': '#$primary',
      'background': '#FFFFFF',
      'text': '#333333',
      'accent': '#FFC107',
    };
  }
}

// 根据账本名称获取图标
String _getLedgerIcon(String ledgerName) {
  final name = ledgerName.toLowerCase();

  if (name.contains('工资') || name.contains('salary') || name.contains('work')) {
    return 'work';
  } else if (name.contains('投资') || name.contains('invest') || name.contains('股票')) {
    return 'trending_up';
  } else if (name.contains('家庭') || name.contains('family') || name.contains('home')) {
    return 'home';
  } else if (name.contains('旅行') || name.contains('travel') || name.contains('trip')) {
    return 'flight';
  } else if (name.contains('学习') || name.contains('study') || name.contains('education')) {
    return 'school';
  } else if (name.contains('购物') || name.contains('shopping') || name.contains('买')) {
    return 'shopping_cart';
  } else {
    return 'account_balance_wallet';
  }
}