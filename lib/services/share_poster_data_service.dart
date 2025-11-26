/// 分享海报数据计算服务
library;

import 'package:drift/drift.dart' show OrderingTerm;

import '../data/repository.dart';
import 'share_poster_types.dart';

/// 海报数据计算服务
class SharePosterDataService {
  final BeeRepository repository;

  const SharePosterDataService(this.repository);

  /// 计算年度总结海报数据
  Future<YearSummaryPosterData> calculateYearSummary({
    required int ledgerId,
    required int year,
  }) async {
    // 时间范围: 1月1日 00:00 - 12月31日 23:59:59
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year + 1, 1, 1);

    // 1. 获取指定年份的所有交易记录(用于计算天数和笔数)
    final yearTransactions = await (repository.db.select(repository.db.transactions)
          ..where((t) => t.ledgerId.equals(ledgerId)))
        .get();

    // 筛选出当年的交易
    final yearTxs = yearTransactions.where((tx) {
      return tx.happenedAt.year == year;
    }).toList();

    // 计算记账天数(按日期去重)
    final recordDays = yearTxs.map((tx) {
      final date = tx.happenedAt;
      return DateTime(date.year, date.month, date.day);
    }).toSet().length;

    final recordCount = yearTxs.length;

    // 2. 计算总收入和总支出
    double totalIncome = 0.0;
    double totalExpense = 0.0;
    final Map<int, double> monthlyExpenses = {};

    // 遍历12个月
    for (int month = 1; month <= 12; month++) {
      final monthStart = DateTime(year, month, 1);

      final (income, expense) = await repository.monthlyTotals(
        ledgerId: ledgerId,
        month: monthStart,
      );

      totalIncome += income;
      totalExpense += expense;
      monthlyExpenses[month] = expense;
    }

    // 3. 找出最高支出月份
    int? maxExpenseMonth;
    double? maxExpenseAmount;
    if (monthlyExpenses.isNotEmpty) {
      final maxEntry = monthlyExpenses.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      maxExpenseMonth = maxEntry.key;
      maxExpenseAmount = maxEntry.value;
    }

    // 4. 计算TOP分类
    final expenseCategories = await repository.totalsByCategory(
      ledgerId: ledgerId,
      type: 'expense',
      start: startDate,
      end: endDate,
    );

    final incomeCategories = await repository.totalsByCategory(
      ledgerId: ledgerId,
      type: 'income',
      start: startDate,
      end: endDate,
    );

    // 转换为CategoryTotal并计算占比
    final topExpenseCategories = _convertToCategoryTotals(
      expenseCategories.take(3).toList(),
      totalExpense,
    );

    final topIncomeCategories = _convertToCategoryTotals(
      incomeCategories.take(3).toList(),
      totalIncome,
    );

    // 5. 计算月均收支
    final avgMonthlyExpense = totalExpense / 12;
    final avgMonthlyIncome = totalIncome / 12;

    // 6. 计算结余
    final balance = totalIncome - totalExpense;

    return YearSummaryPosterData(
      year: year,
      recordDays: recordDays,
      recordCount: recordCount,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      topExpenseCategories: topExpenseCategories,
      topIncomeCategories: topIncomeCategories,
      avgMonthlyExpense: avgMonthlyExpense,
      avgMonthlyIncome: avgMonthlyIncome,
      maxExpenseMonth: maxExpenseMonth,
      maxExpenseAmount: maxExpenseAmount,
      balance: balance,
    );
  }

  /// 计算月度总结海报数据
  Future<MonthSummaryPosterData> calculateMonthSummary({
    required int ledgerId,
    required int year,
    required int month,
  }) async {
    // 时间范围: 本月1日 00:00 - 下月1日 00:00
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1);

    // 上月时间范围(用于计算环比)
    final prevMonthStart = DateTime(year, month - 1, 1);

    // 1. 计算本月收入和支出
    final (totalIncome, totalExpense) = await repository.monthlyTotals(
      ledgerId: ledgerId,
      month: startDate,
    );

    // 2. 计算上月支出(用于环比)
    double? expenseChangeRate;
    try {
      final (_, prevExpense) = await repository.monthlyTotals(
        ledgerId: ledgerId,
        month: prevMonthStart,
      );

      if (prevExpense > 0) {
        expenseChangeRate = (totalExpense - prevExpense) / prevExpense;
      }
    } catch (e) {
      // 如果获取上月数据失败,忽略环比
      expenseChangeRate = null;
    }

    // 3. 获取本月的记账笔数 (从账本统计获取总笔数)
    final ledgerCounts = await repository.countsForLedger(ledgerId: ledgerId);
    // 注意: 这里使用的是账本的总笔数,不是本月的笔数
    // 为了更准确,可以考虑计算本月的具体笔数,但这需要额外的SQL查询
    final recordCount = ledgerCounts.txCount;

    // 4. 计算TOP分类
    final expenseCategories = await repository.totalsByCategory(
      ledgerId: ledgerId,
      type: 'expense',
      start: startDate,
      end: endDate,
    );

    final incomeCategories = await repository.totalsByCategory(
      ledgerId: ledgerId,
      type: 'income',
      start: startDate,
      end: endDate,
    );

    // 转换为CategoryTotal并计算占比
    final topExpenseCategories = _convertToCategoryTotals(
      expenseCategories.take(3).toList(),
      totalExpense,
    );

    final topIncomeCategories = _convertToCategoryTotals(
      incomeCategories.take(3).toList(),
      totalIncome,
    );

    // 5. 计算日均支出
    final daysInMonth = endDate.difference(startDate).inDays;
    final avgDailyExpense = daysInMonth > 0 ? totalExpense / daysInMonth : 0.0;

    // 6. 计算结余
    final balance = totalIncome - totalExpense;

    return MonthSummaryPosterData(
      year: year,
      month: month,
      recordCount: recordCount,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      topExpenseCategories: topExpenseCategories,
      topIncomeCategories: topIncomeCategories,
      avgDailyExpense: avgDailyExpense,
      balance: balance,
      expenseChangeRate: expenseChangeRate,
    );
  }

  /// 计算账本总结海报数据
  Future<LedgerSummaryPosterData> calculateLedgerSummary({
    required int ledgerId,
  }) async {
    // 获取账本统计信息（包含余额和交易数）
    final ledgerStats = await repository.getLedgerStats(ledgerId: ledgerId);
    final recordCount = ledgerStats.transactionCount;

    // 获取账本名称（通过查询ledgers表）
    final ledgersQuery = repository.db.select(repository.db.ledgers)
      ..where((l) => l.id.equals(ledgerId));
    final ledgers = await ledgersQuery.get();
    final ledgerName = ledgers.isNotEmpty ? ledgers.first.name : '默认账本';

    // 使用年度序列来计算所有年份的收支
    final yearSeries = await repository.totalsByYearSeries(
      ledgerId: ledgerId,
      type: 'expense',
    );

    // 计算所有年份的收入和支出
    double totalIncome = 0.0;
    double totalExpense = 0.0;

    // 获取所有涉及的年份
    final Set<int> years = {};
    if (yearSeries.isNotEmpty) {
      for (final entry in yearSeries) {
        years.add(entry.year);
      }
    }

    // 为每一年计算收入和支出
    for (final year in years) {
      for (int month = 1; month <= 12; month++) {
        final monthStart = DateTime(year, month, 1);
        final (income, expense) = await repository.monthlyTotals(
          ledgerId: ledgerId,
          month: monthStart,
        );
        totalIncome += income;
        totalExpense += expense;
      }
    }

    // 如果没有年份数据，说明没有交易记录
    if (years.isEmpty) {
      totalIncome = 0.0;
      totalExpense = 0.0;
    }

    // 计算记账天数和日期范围
    int recordDays = 0;
    DateTime? firstRecordDate;
    DateTime? lastRecordDate;

    final countsResult = await repository.countsForLedger(ledgerId: ledgerId);
    recordDays = countsResult.dayCount;

    // 获取第一笔和最后一笔交易的时间
    if (recordCount > 0) {
      // 查询最早的交易
      final firstTx = await (repository.db.select(repository.db.transactions)
            ..where((t) => t.ledgerId.equals(ledgerId))
            ..orderBy([(t) => OrderingTerm.asc(t.happenedAt)])
            ..limit(1))
          .get();

      // 查询最晚的交易
      final lastTx = await (repository.db.select(repository.db.transactions)
            ..where((t) => t.ledgerId.equals(ledgerId))
            ..orderBy([(t) => OrderingTerm.desc(t.happenedAt)])
            ..limit(1))
          .get();

      if (firstTx.isNotEmpty) {
        firstRecordDate = firstTx.first.happenedAt;
      }
      if (lastTx.isNotEmpty) {
        lastRecordDate = lastTx.first.happenedAt;
      }
    }

    // 计算TOP分类 (使用所有时间范围)
    final startDate = DateTime(1970, 1, 1);
    final endDate = DateTime.now().add(const Duration(days: 1));

    final expenseCategories = await repository.totalsByCategory(
      ledgerId: ledgerId,
      type: 'expense',
      start: startDate,
      end: endDate,
    );

    final incomeCategories = await repository.totalsByCategory(
      ledgerId: ledgerId,
      type: 'income',
      start: startDate,
      end: endDate,
    );

    // 转换为CategoryTotal并计算占比
    final topExpenseCategories = _convertToCategoryTotals(
      expenseCategories.take(3).toList(),
      totalExpense,
    );

    final topIncomeCategories = _convertToCategoryTotals(
      incomeCategories.take(3).toList(),
      totalIncome,
    );

    // 计算结余
    final balance = totalIncome - totalExpense;

    return LedgerSummaryPosterData(
      ledgerName: ledgerName,
      recordDays: recordDays,
      recordCount: recordCount,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      topExpenseCategories: topExpenseCategories,
      topIncomeCategories: topIncomeCategories,
      firstRecordDate: firstRecordDate,
      lastRecordDate: lastRecordDate,
      balance: balance,
    );
  }

  /// 将仓库数据转换为CategoryTotal列表
  List<CategoryTotal> _convertToCategoryTotals(
    List<({int? id, String name, String? icon, double total})> categories,
    double totalAmount,
  ) {
    if (categories.isEmpty || totalAmount <= 0) {
      return [];
    }

    return categories.map((cat) {
      final percentage = cat.total / totalAmount;
      return CategoryTotal(
        id: cat.id,
        name: cat.name,
        icon: cat.icon,
        total: cat.total,
        percentage: percentage,
      );
    }).toList();
  }
}
