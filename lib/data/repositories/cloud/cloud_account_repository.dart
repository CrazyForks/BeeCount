import 'dart:async';

import 'package:flutter_cloud_sync_supabase/flutter_cloud_sync_supabase.dart';
import 'package:flutter_cloud_sync/flutter_cloud_sync.dart';

import '../../db.dart';
import '../account_repository.dart';
import '../../../services/system/logger_service.dart';

/// 云端账户Repository实现
/// 基于 Supabase 实现
class CloudAccountRepository implements AccountRepository {
  final SupabaseProvider supabase;

  CloudAccountRepository(this.supabase);

  @override
  Stream<List<Account>> watchAccountsForLedger(int ledgerId) {
    final controller = StreamController<List<Account>>();

    // 立即获取初始数据
    getAvailableAccountsForLedger(ledgerId).then((accounts) {
      if (!controller.isClosed) {
        controller.add(accounts);
      }
    });

    // 创建 Realtime 频道
    final channel =
        supabase.realtimeService!.channel('accounts:ledger:$ledgerId');

    channel.onPostgresChanges(
      event: '*',
      schema: 'public',
      table: 'accounts',
      callback: (payload) async {
        try {
          final accounts = await getAvailableAccountsForLedger(ledgerId);
          if (!controller.isClosed) {
            controller.add(accounts);
          }
        } catch (e) {
          if (!controller.isClosed) {
            controller.addError(e);
          }
        }
      },
    );

    channel.subscribe();

    controller.onCancel = () {
      channel.unsubscribe();
    };

    return controller.stream;
  }

  @override
  Stream<List<Account>> watchAllAccounts() {
    logger.info('CloudAccountRepository', '📡 watchAllAccounts 被调用（云端模式）');
    final controller = StreamController<List<Account>>();

    // 立即获取初始数据
    getAllAccounts().then((accounts) {
      logger.info('CloudAccountRepository', '✅ 获取到 ${accounts.length} 个云端账户');
      if (!controller.isClosed) {
        controller.add(accounts);
      }
    }).catchError((error) {
      logger.error('CloudAccountRepository', '❌ 获取云端账户失败', error, null);
    });

    // 创建 Realtime 频道
    final channel = supabase.realtimeService!.channel('accounts:all');

    channel.onPostgresChanges(
      event: '*',
      schema: 'public',
      table: 'accounts',
      callback: (payload) async {
        try {
          final accounts = await getAllAccounts();
          if (!controller.isClosed) {
            controller.add(accounts);
          }
        } catch (e) {
          if (!controller.isClosed) {
            controller.addError(e);
          }
        }
      },
    );

    channel.subscribe();

    controller.onCancel = () {
      channel.unsubscribe();
    };

    return controller.stream;
  }

  @override
  Future<List<Account>> getAllAccounts() async {
    final results = await supabase.databaseService!.query(
      table: 'accounts',
      orderBy: 'created_at',
      descending: true,
    );

    return results.map((data) => _accountFromJson(data)).toList();
  }

  @override
  Future<Account?> getAccount(int accountId) async {
    final results = await supabase.databaseService!.query(
      table: 'accounts',
      filters: [
        QueryFilter(column: 'id', operator: 'eq', value: accountId),
      ],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _accountFromJson(results.first);
  }

  @override
  Future<List<Account>> getAvailableAccountsForLedger(int ledgerId) async {
    final results = await supabase.databaseService!.query(
      table: 'accounts',
      filters: [
        QueryFilter(column: 'ledger_id', operator: 'eq', value: ledgerId),
      ],
      orderBy: 'created_at',
      descending: true,
    );

    return results.map((data) => _accountFromJson(data)).toList();
  }

  @override
  Future<List<Account>> getAccountsByCurrency(String currency) async {
    final results = await supabase.databaseService!.query(
      table: 'accounts',
      filters: [
        QueryFilter(column: 'currency', operator: 'eq', value: currency),
      ],
      orderBy: 'created_at',
      descending: true,
    );

    return results.map((data) => _accountFromJson(data)).toList();
  }

  @override
  Future<Map<String, List<Account>>> getAccountsGroupedByCurrency() async {
    final accounts = await getAllAccounts();
    final grouped = <String, List<Account>>{};

    for (final account in accounts) {
      grouped.putIfAbsent(account.currency, () => []).add(account);
    }

    return grouped;
  }

  @override
  Future<int> createAccount({
    required int ledgerId,
    required String name,
    String type = 'cash',
    String currency = 'CNY',
    double initialBalance = 0.0,
  }) async {
    logger.info('CloudAccountRepository', '📝 创建账户: name=$name, type=$type, currency=$currency, initialBalance=$initialBalance (ledgerId=$ledgerId 已忽略)');

    try {
      final result = await supabase.databaseService!.insert(
        table: 'accounts',
        data: {
          // 不传递 ledger_id，账户不绑定账本
          'name': name,
          'type': type,
          'currency': currency,
          'initial_balance': initialBalance,
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      final accountId = result['id'] as int;
      logger.info('CloudAccountRepository', '✅ 账户创建成功: id=$accountId');
      return accountId;
    } catch (e, stackTrace) {
      logger.error('CloudAccountRepository', '❌ 创建账户失败', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateAccount(
    int id, {
    String? name,
    String? type,
    String? currency,
    double? initialBalance,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (type != null) data['type'] = type;
    if (currency != null) data['currency'] = currency;
    if (initialBalance != null) data['initial_balance'] = initialBalance;

    if (data.isNotEmpty) {
      data['updated_at'] = DateTime.now().toIso8601String();
      await supabase.databaseService!.update(
        table: 'accounts',
        id: id.toString(),
        data: data,
      );
    }
  }

  @override
  Future<void> deleteAccount(int id) async {
    await supabase.databaseService!.delete(
      table: 'accounts',
      id: id.toString(),
    );
  }

  @override
  Future<double> getAccountBalance(int accountId) async {
    final account = await getAccount(accountId);
    if (account == null) return 0.0;

    // 获取该账户的所有交易
    final transactions = await supabase.databaseService!.query(
      table: 'transactions',
      filters: [
        QueryFilter(column: 'account_id', operator: 'eq', value: accountId),
      ],
    );

    double balance = account.initialBalance;

    for (final tx in transactions) {
      final type = tx['type'] as String;
      final amount = (tx['amount'] as num).toDouble();
      final toAccountId = tx['to_account_id'] as int?;

      if (type == 'income') {
        balance += amount;
      } else if (type == 'expense') {
        balance -= amount;
      } else if (type == 'transfer') {
        // 如果是转出
        if (tx['account_id'] == accountId) {
          balance -= amount;
        }
        // 如果是转入
        if (toAccountId == accountId) {
          balance += amount;
        }
      }
    }

    return balance;
  }

  @override
  Future<double> getAccountGlobalBalance(int accountId) async {
    return getAccountBalance(accountId);
  }

  @override
  Future<double> getAccountBalanceInLedger(int accountId, int ledgerId) async {
    final account = await getAccount(accountId);
    if (account == null) return 0.0;

    // 获取该账户在指定账本中的交易
    final transactions = await supabase.databaseService!.query(
      table: 'transactions',
      filters: [
        QueryFilter(column: 'account_id', operator: 'eq', value: accountId),
        QueryFilter(column: 'ledger_id', operator: 'eq', value: ledgerId),
      ],
    );

    double balance = account.initialBalance;

    for (final tx in transactions) {
      final type = tx['type'] as String;
      final amount = (tx['amount'] as num).toDouble();

      if (type == 'income') {
        balance += amount;
      } else if (type == 'expense') {
        balance -= amount;
      }
    }

    return balance;
  }

  @override
  Future<Map<int, double>> getAllAccountBalances(int ledgerId) async {
    final accounts = await getAvailableAccountsForLedger(ledgerId);
    final balances = <int, double>{};

    for (final account in accounts) {
      balances[account.id] = await getAccountBalanceInLedger(
        account.id,
        ledgerId,
      );
    }

    return balances;
  }

  @override
  Future<int> getTransactionCountByAccount(int accountId) async {
    final results = await supabase.databaseService!.query(
      table: 'transactions',
      filters: [
        QueryFilter(column: 'account_id', operator: 'eq', value: accountId),
      ],
    );

    return results.length;
  }

  @override
  Future<double> getAccountExpense(int accountId) async {
    final transactions = await supabase.databaseService!.query(
      table: 'transactions',
      filters: [
        QueryFilter(column: 'account_id', operator: 'eq', value: accountId),
        QueryFilter(column: 'type', operator: 'eq', value: 'expense'),
      ],
    );

    return transactions.fold<double>(
      0.0,
      (sum, tx) => sum + (tx['amount'] as num).toDouble(),
    );
  }

  @override
  Future<double> getAccountIncome(int accountId) async {
    final transactions = await supabase.databaseService!.query(
      table: 'transactions',
      filters: [
        QueryFilter(column: 'account_id', operator: 'eq', value: accountId),
        QueryFilter(column: 'type', operator: 'eq', value: 'income'),
      ],
    );

    return transactions.fold<double>(
      0.0,
      (sum, tx) => sum + (tx['amount'] as num).toDouble(),
    );
  }

  @override
  Future<({double balance, double expense, double income})> getAccountStats(
      int accountId) async {
    final balance = await getAccountBalance(accountId);
    final expense = await getAccountExpense(accountId);
    final income = await getAccountIncome(accountId);

    return (balance: balance, expense: expense, income: income);
  }

  @override
  Future<Map<int, ({double balance, double expense, double income})>>
      getAllAccountStats() async {
    final accounts = await getAllAccounts();
    final stats = <int, ({double balance, double expense, double income})>{};

    for (final account in accounts) {
      stats[account.id] = await getAccountStats(account.id);
    }

    return stats;
  }

  @override
  Future<({double totalBalance, double totalExpense, double totalIncome})>
      getAllAccountsTotalStats() async {
    final accounts = await getAllAccounts();

    double totalBalance = 0.0;
    double totalExpense = 0.0;
    double totalIncome = 0.0;

    for (final account in accounts) {
      final stats = await getAccountStats(account.id);
      totalBalance += stats.balance;
      totalExpense += stats.expense;
      totalIncome += stats.income;
    }

    return (
      totalBalance: totalBalance,
      totalExpense: totalExpense,
      totalIncome: totalIncome,
    );
  }

  @override
  Future<Map<int, int>> getAccountUsageInLedgers(int accountId) async {
    // 获取该账户在各账本中的交易数量
    final transactions = await supabase.databaseService!.query(
      table: 'transactions',
      filters: [
        QueryFilter(column: 'account_id', operator: 'eq', value: accountId),
      ],
    );

    final usage = <int, int>{};
    for (final tx in transactions) {
      final ledgerId = tx['ledger_id'] as int;
      usage[ledgerId] = (usage[ledgerId] ?? 0) + 1;
    }

    return usage;
  }

  @override
  Future<int> migrateAccount({
    required int fromAccountId,
    required int toAccountId,
  }) async {
    throw UnimplementedError('云端账户迁移暂不支持');
  }

  @override
  Future<bool> hasTransactions(int accountId) async {
    final count = await getTransactionCountByAccount(accountId);
    return count > 0;
  }

  @override
  Stream<Account?> watchAccount(int accountId) {
    final controller = StreamController<Account?>();

    // 立即获取初始数据
    getAccount(accountId).then((account) {
      if (!controller.isClosed) {
        controller.add(account);
      }
    });

    // 创建 Realtime 频道
    final channel = supabase.realtimeService!.channel('account:$accountId');

    channel.onPostgresChanges(
      event: '*',
      schema: 'public',
      table: 'accounts',
      callback: (payload) async {
        try {
          final account = await getAccount(accountId);
          if (!controller.isClosed) {
            controller.add(account);
          }
        } catch (e) {
          if (!controller.isClosed) {
            controller.addError(e);
          }
        }
      },
    );

    channel.subscribe();

    controller.onCancel = () {
      channel.unsubscribe();
    };

    return controller.stream;
  }

  @override
  Stream<List<Transaction>> watchAccountTransactions(int accountId) {
    final controller = StreamController<List<Transaction>>();

    // 立即获取初始数据
    _fetchAccountTransactions(accountId).then((transactions) {
      if (!controller.isClosed) {
        controller.add(transactions);
      }
    });

    // 创建 Realtime 频道
    final channel = supabase.realtimeService!
        .channel('transactions:account:$accountId');

    channel.onPostgresChanges(
      event: '*',
      schema: 'public',
      table: 'transactions',
      callback: (payload) async {
        try {
          final transactions = await _fetchAccountTransactions(accountId);
          if (!controller.isClosed) {
            controller.add(transactions);
          }
        } catch (e) {
          if (!controller.isClosed) {
            controller.addError(e);
          }
        }
      },
    );

    channel.subscribe();

    controller.onCancel = () {
      channel.unsubscribe();
    };

    return controller.stream;
  }

  Future<List<Transaction>> _fetchAccountTransactions(int accountId) async {
    final results = await supabase.databaseService!.query(
      table: 'transactions',
      filters: [
        QueryFilter(column: 'account_id', operator: 'eq', value: accountId),
      ],
      orderBy: 'happened_at',
      descending: true,
    );

    return results.map((data) => _transactionFromJson(data)).toList();
  }

  // ============================================
  // 辅助方法：数据转换
  // ============================================

  Account _accountFromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as int,
      ledgerId: (json['ledger_id'] as int?) ?? 0, // 账户不再强制绑定账本，默认为0
      name: json['name'] as String,
      type: json['type'] as String? ?? 'cash',
      currency: json['currency'] as String? ?? 'CNY',
      initialBalance: (json['initial_balance'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Transaction _transactionFromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      ledgerId: json['ledger_id'] as int,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['category_id'] as int?,
      accountId: json['account_id'] as int?,
      toAccountId: json['to_account_id'] as int?,
      happenedAt: DateTime.parse(json['happened_at'] as String),
      note: json['note'] as String?,
      recurringId: json['recurring_id'] as int?,
    );
  }

  @override
  Future<void> batchInsertAccounts(List<AccountsCompanion> accounts) async {
    throw UnimplementedError('云端批量插入账户暂不支持');
  }

  @override
  Future<List<Account>> getAccountsByIds(List<int> accountIds) async {
    if (accountIds.isEmpty) return [];

    final results = await supabase.databaseService!.query(
      table: 'accounts',
      filters: [
        QueryFilter(column: 'id', operator: 'in', value: accountIds),
      ],
    );

    return results.map((row) => _accountFromJson(row)).toList();
  }
}
