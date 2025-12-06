import 'package:drift/drift.dart' as d;

import '../../db.dart';
import '../transaction_repository.dart';

/// 本地交易Repository实现
/// 基于 Drift 数据库实现
class LocalTransactionRepository implements TransactionRepository {
  final BeeDatabase db;

  LocalTransactionRepository(this.db);

  @override
  Stream<List<Transaction>> watchRecentTransactions({
    required int ledgerId,
    int limit = 20,
  }) {
    return (db.select(db.transactions)
          ..where((t) => t.ledgerId.equals(ledgerId))
          ..orderBy([
            (t) => d.OrderingTerm(
                expression: t.happenedAt, mode: d.OrderingMode.desc)
          ])
          ..limit(limit))
        .watch();
  }

  @override
  Stream<List<Transaction>> watchTransactionsInMonth({
    required int ledgerId,
    required DateTime month,
  }) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    return (db.select(db.transactions)
          ..where((t) =>
              t.ledgerId.equals(ledgerId) &
              t.happenedAt.isBetweenValues(start, end))
          ..orderBy([
            (t) => d.OrderingTerm(
                expression: t.happenedAt, mode: d.OrderingMode.desc)
          ]))
        .watch();
  }

  @override
  Stream<List<({Transaction t, Category? category})>>
      watchTransactionsWithCategoryAll({
    required int ledgerId,
  }) {
    final q = (db.select(db.transactions)
          ..where((t) => t.ledgerId.equals(ledgerId))
          ..orderBy([
            (t) => d.OrderingTerm(
                expression: t.happenedAt, mode: d.OrderingMode.desc)
          ]))
        .join([
      d.leftOuterJoin(db.categories,
          db.categories.id.equalsExp(db.transactions.categoryId)),
    ]);
    return q.watch().map((rows) => rows
        .map((r) => (
              t: r.readTable(db.transactions),
              category: r.readTableOrNull(db.categories)
            ))
        .toList());
  }

  @override
  Stream<List<({Transaction t, Category? category})>>
      watchTransactionsWithCategoryInMonth({
    required int ledgerId,
    required DateTime month,
  }) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final q = (db.select(db.transactions)
          ..where((t) =>
              t.ledgerId.equals(ledgerId) &
              t.happenedAt.isBetweenValues(start, end))
          ..orderBy([
            (t) => d.OrderingTerm(
                expression: t.happenedAt, mode: d.OrderingMode.desc)
          ]))
        .join([
      d.leftOuterJoin(db.categories,
          db.categories.id.equalsExp(db.transactions.categoryId)),
    ]);
    return q.watch().map((rows) => rows
        .map((r) => (
              t: r.readTable(db.transactions),
              category: r.readTableOrNull(db.categories)
            ))
        .toList());
  }

  @override
  Stream<List<({Transaction t, Category? category})>>
      watchTransactionsWithCategoryInYear({
    required int ledgerId,
    required int year,
  }) {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);
    final q = (db.select(db.transactions)
          ..where((t) =>
              t.ledgerId.equals(ledgerId) &
              t.happenedAt.isBetweenValues(start, end))
          ..orderBy([
            (t) => d.OrderingTerm(
                expression: t.happenedAt, mode: d.OrderingMode.desc)
          ]))
        .join([
      d.leftOuterJoin(db.categories,
          db.categories.id.equalsExp(db.transactions.categoryId)),
    ]);
    return q.watch().map((rows) => rows
        .map((r) => (
              t: r.readTable(db.transactions),
              category: r.readTableOrNull(db.categories)
            ))
        .toList());
  }

  @override
  Stream<List<({Transaction t, Category? category})>>
      watchTransactionsForCategoryInRange({
    required int ledgerId,
    required DateTime start,
    required DateTime end,
    int? categoryId,
    required String type,
  }) {
    final base = (db.select(db.transactions)
          ..where((t) =>
              t.ledgerId.equals(ledgerId) &
              t.type.equals(type) &
              t.happenedAt.isBetweenValues(start, end))
          ..orderBy([
            (t) => d.OrderingTerm(
                expression: t.happenedAt, mode: d.OrderingMode.desc)
          ]))
        .join([
      d.leftOuterJoin(db.categories,
          db.categories.id.equalsExp(db.transactions.categoryId)),
    ]);
    if (categoryId == null) {
      base.where(db.transactions.categoryId.isNull());
    } else {
      base.where(db.transactions.categoryId.equals(categoryId));
    }
    return base.watch().map((rows) => rows
        .map((r) => (
              t: r.readTable(db.transactions),
              category: r.readTableOrNull(db.categories)
            ))
        .toList());
  }

  @override
  Future<int> addTransaction({
    required int ledgerId,
    required String type,
    required double amount,
    int? categoryId,
    int? accountId,
    int? toAccountId,
    required DateTime happenedAt,
    String? note,
  }) async {
    return db.into(db.transactions).insert(TransactionsCompanion.insert(
          ledgerId: ledgerId,
          type: type,
          amount: amount,
          categoryId: d.Value(categoryId),
          accountId: d.Value(accountId),
          toAccountId: d.Value(toAccountId),
          happenedAt: d.Value(happenedAt),
          note: d.Value(note),
        ));
  }

  @override
  Future<int> insertTransactionsBatch(List<TransactionsCompanion> items) async {
    if (items.isEmpty) return 0;
    return db.transaction(() async {
      await db.batch((b) => b.insertAll(db.transactions, items));
      return items.length;
    });
  }

  @override
  Future<void> updateTransaction({
    required int id,
    required String type,
    required double amount,
    int? categoryId,
    String? note,
    DateTime? happenedAt,
    dynamic accountId,
  }) async {
    // 处理 accountId 参数
    final d.Value<int?> accountIdValue;
    if (accountId == null) {
      accountIdValue = const d.Value.absent();
    } else if (accountId is d.Value<int?>) {
      accountIdValue = accountId;
    } else {
      accountIdValue = d.Value(accountId as int?);
    }

    await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        type: d.Value(type),
        amount: d.Value(amount),
        categoryId: d.Value(categoryId),
        note: d.Value(note),
        happenedAt:
            happenedAt != null ? d.Value(happenedAt) : const d.Value.absent(),
        accountId: accountIdValue,
      ),
    );
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await (db.delete(db.transactions)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<Transaction?> getTransactionById(int id) async {
    return await (db.select(db.transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<int> insertTransactionCompanion(TransactionsCompanion item) async {
    return await db.into(db.transactions).insert(item);
  }

  @override
  Stream<List<({Transaction t, Category? category})>>
      transactionsWithCategoryAll({
    required int ledgerId,
  }) =>
          watchTransactionsWithCategoryAll(ledgerId: ledgerId);

  @override
  Future<int> countByTypeInRange({
    required int ledgerId,
    required String type,
    required DateTime start,
    required DateTime end,
  }) async {
    final row = await db.customSelect(
      'SELECT COUNT(*) AS c FROM transactions WHERE ledger_id = ?1 AND type = ?2 AND happened_at >= ?3 AND happened_at < ?4',
      variables: [
        d.Variable<int>(ledgerId),
        d.Variable<String>(type),
        d.Variable<DateTime>(start),
        d.Variable<DateTime>(end),
      ],
      readsFrom: {db.transactions},
    ).getSingle();
    final v = row.data['c'];
    if (v is int) return v;
    if (v is BigInt) return v.toInt();
    if (v is num) return v.toInt();
    return 0;
  }

  @override
  String txSignature({
    required String type,
    required double amount,
    required int? categoryId,
    required DateTime happenedAt,
    required String? note,
  }) {
    final ts = happenedAt.millisecondsSinceEpoch;
    final cat = categoryId?.toString() ?? '';
    final n = note ?? '';
    final amt = amount.toStringAsFixed(6);
    return '$type|$amt|$cat|$ts|$n';
  }

  @override
  Future<Set<String>> signatureSetForLedger(int ledgerId) async {
    final rows = await (db.select(db.transactions)
          ..where((t) => t.ledgerId.equals(ledgerId)))
        .get();
    final set = <String>{};
    for (final t in rows) {
      set.add(txSignature(
          type: t.type,
          amount: t.amount,
          categoryId: t.categoryId,
          happenedAt: t.happenedAt,
          note: t.note));
    }
    return set;
  }

  @override
  Future<int> deduplicateLedgerTransactions(int ledgerId) async {
    final rows = await (db.select(db.transactions)
          ..where((t) => t.ledgerId.equals(ledgerId))
          ..orderBy([(t) => d.OrderingTerm(expression: t.id)]))
        .get();
    final firstIdForSig = <String, int>{};
    final toDelete = <int>[];
    for (final t in rows) {
      final sig = txSignature(
          type: t.type,
          amount: t.amount,
          categoryId: t.categoryId,
          happenedAt: t.happenedAt,
          note: t.note);
      final id = t.id;
      final existed = firstIdForSig[sig];
      if (existed == null) {
        firstIdForSig[sig] = id;
      } else {
        toDelete.add(id);
      }
    }
    if (toDelete.isEmpty) return 0;
    await (db.delete(db.transactions)..where((t) => t.id.isIn(toDelete))).go();
    return toDelete.length;
  }

  @override
  Future<List<Transaction>> getTransactionsByLedger(int ledgerId) async {
    return await (db.select(db.transactions)
          ..where((t) => t.ledgerId.equals(ledgerId))
          ..orderBy([
            (t) =>
                d.OrderingTerm(expression: t.happenedAt, mode: d.OrderingMode.desc)
          ]))
        .get();
  }

  @override
  Future<List<Transaction>> getTransactionsByLedgerInRange({
    required int ledgerId,
    required DateTime start,
    required DateTime end,
  }) async {
    return await (db.select(db.transactions)
          ..where((t) =>
              t.ledgerId.equals(ledgerId) &
              t.happenedAt.isBiggerOrEqualValue(start) &
              t.happenedAt.isSmallerThanValue(end))
          ..orderBy([
            (t) =>
                d.OrderingTerm(expression: t.happenedAt, mode: d.OrderingMode.desc)
          ]))
        .get();
  }

  @override
  Future<void> updateTransactionFields({
    required int id,
    int? accountId,
    int? toAccountId,
  }) async {
    await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        accountId:
            accountId != null ? d.Value(accountId) : const d.Value.absent(),
        toAccountId:
            toAccountId != null ? d.Value(toAccountId) : const d.Value.absent(),
      ),
    );
  }

  @override
  Future<Transaction?> getFirstTransactionByLedger(int ledgerId) async {
    return await (db.select(db.transactions)
          ..where((t) => t.ledgerId.equals(ledgerId))
          ..orderBy([
            (t) =>
                d.OrderingTerm(expression: t.happenedAt, mode: d.OrderingMode.asc)
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<Transaction?> getLastTransactionByLedger(int ledgerId) async {
    return await (db.select(db.transactions)
          ..where((t) => t.ledgerId.equals(ledgerId))
          ..orderBy([
            (t) =>
                d.OrderingTerm(expression: t.happenedAt, mode: d.OrderingMode.desc)
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<void> updateTransactionLedger({
    required int id,
    required int ledgerId,
  }) async {
    await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(ledgerId: d.Value(ledgerId)),
    );
  }
}
