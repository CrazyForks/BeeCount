import 'dart:convert';

import 'package:drift/drift.dart' as d;

import '../data/db.dart';
import '../data/repository.dart';

/// 账本交易数据的 JSON 导入导出工具
///
/// 用于云同步时序列化和反序列化交易数据

// --- 字符串清理 ---

/// 清理字符串中的控制字符，防止 JSON 解析错误
String _sanitizeString(String? input) {
  if (input == null) return '';
  // 移除所有控制字符（ASCII 0-31，除了常见的制表符、换行符等）
  // 并替换换行符和制表符为空格
  return input
      .replaceAll(RegExp(r'[\x00-\x08\x0B-\x0C\x0E-\x1F\x7F]'), '')
      .replaceAll('\n', ' ')
      .replaceAll('\r', ' ')
      .replaceAll('\t', ' ')
      .trim();
}

// --- 导出 ---

/// 导出账本交易数据为 JSON 字符串
///
/// [db] - 数据库实例
/// [ledgerId] - 账本ID
///
/// 返回包含以下字段的 JSON：
/// - version: 数据格式版本
/// - exportedAt: 导出时间戳
/// - ledgerId: 账本ID
/// - ledgerName: 账本名称
/// - currency: 货币
/// - count: 交易条数
/// - accounts: 账户列表
/// - items: 交易明细
Future<String> exportTransactionsJson(BeeDatabase db, int ledgerId) async {
  final txs = await (db.select(db.transactions)
        ..where((t) => t.ledgerId.equals(ledgerId)))
      .get();

  // 稳定排序，避免不同平台/查询导致顺序差异
  txs.sort((a, b) {
    final c = a.happenedAt.compareTo(b.happenedAt);
    if (c != 0) return c;
    return a.id.compareTo(b.id);
  });

  // Map categoryId -> name/kind for used categories
  final usedCatIds = txs.map((t) => t.categoryId).whereType<int>().toSet();
  final cats = <int, Map<String, dynamic>>{};
  for (final cid in usedCatIds) {
    final c = await (db.select(db.categories)..where((c) => c.id.equals(cid)))
        .getSingleOrNull();
    if (c != null) {
      final sanitizedName = _sanitizeString(c.name);
      cats[cid] = {"name": sanitizedName, "kind": c.kind};
    }
  }

  final items = txs
      .map((t) => {
            'type': t.type,
            'amount': t.amount,
            'categoryName':
                t.categoryId != null ? cats[t.categoryId]!['name'] : null,
            'categoryKind':
                t.categoryId != null ? cats[t.categoryId]!['kind'] : null,
            'happenedAt': t.happenedAt.toUtc().toIso8601String(),
            'note': _sanitizeString(t.note),
          })
      .toList();

  // ledger meta
  final ledger = await (db.select(db.ledgers)
        ..where((l) => l.id.equals(ledgerId)))
      .getSingleOrNull();

  // 账户信息
  final accounts = await (db.select(db.accounts)
        ..where((a) => a.ledgerId.equals(ledgerId)))
      .get();
  final accountItems = accounts
      .map((a) => {
            'name': _sanitizeString(a.name),
            'type': a.type,
            'initialBalance': a.initialBalance,
          })
      .toList();

  final payload = {
    'version': 2, // 版本升级,新增账户信息
    'exportedAt': DateTime.now().toUtc().toIso8601String(),
    'ledgerId': ledgerId,
    'ledgerName': ledger?.name,
    'currency': ledger?.currency,
    'count': items.length,
    'accounts': accountItems,
    'items': items,
  };

  return jsonEncode(payload);
}

// --- 导入 ---

/// 解析 JSON 并增量导入，使用签名去重（与本地现有数据合并）
///
/// [repo] - 数据仓库
/// [ledgerId] - 目标账本ID
/// [jsonStr] - JSON 字符串
/// [onProgress] - 进度回调 (已处理数, 总数)
///
/// 返回 (inserted, skipped) 元组：
/// - inserted: 新增条数
/// - skipped: 因重复而跳过的条数
Future<({int inserted, int skipped})> importTransactionsJson(
  BeeRepository repo,
  int ledgerId,
  String jsonStr, {
  void Function(int done, int total)? onProgress,
}) async {
  final data = jsonDecode(jsonStr) as Map<String, dynamic>;
  final items = (data['items'] as List).cast<Map<String, dynamic>>();

  // optional: update local ledger name & currency if present
  final ledgerName = data['ledgerName'] as String?;
  final currency = data['currency'] as String?;
  if (ledgerName != null || currency != null) {
    try {
      await repo.updateLedger(
          id: ledgerId, name: ledgerName, currency: currency);
    } catch (_) {}
  }

  // 导入账户信息 (version 2+)
  final accounts = data['accounts'] as List?;
  if (accounts != null) {
    try {
      // 获取现有账户
      final existingAccounts = await repo.accountsForLedger(ledgerId).first;
      final existingAccountNames =
          existingAccounts.map((a) => a.name).toSet();

      // 只导入不存在的账户,避免重复
      for (final acc in accounts.cast<Map<String, dynamic>>()) {
        final name = acc['name'] as String;
        if (!existingAccountNames.contains(name)) {
          final type = acc['type'] as String? ?? 'cash';
          final initialBalance =
              (acc['initialBalance'] as num?)?.toDouble() ?? 0.0;
          await repo.createAccount(
            ledgerId: ledgerId,
            name: name,
            type: type,
            initialBalance: initialBalance,
          );
        }
      }
    } catch (_) {
      // 账户导入失败不影响交易导入
    }
  }

  int inserted = 0;
  int skipped = 0;
  int processed = 0;
  final total = items.length;

  // 先构建现有签名集合，避免 N^2
  final existing = await repo.signatureSetForLedger(ledgerId);

  // 构建批量待插入列表，分批写入
  final toInsert = <TransactionsCompanion>[];
  const batchSize = 500;

  // 预热：用于减少 upsertCategory 的重复查询
  final categoryCache = <String, int>{}; // key: kind|name -> id

  for (final it in items) {
    final type = it['type'] as String;
    final amount = (it['amount'] as num).toDouble();
    final categoryName = it['categoryName'] as String?;
    final categoryKind = it['categoryKind'] as String?;
    final happenedAt = DateTime.parse(it['happenedAt'] as String).toLocal();
    final note = it['note'] as String?;

    int? categoryId;
    if (categoryName != null && categoryKind != null) {
      final key = '$categoryKind|$categoryName';
      final cached = categoryCache[key];
      if (cached != null) {
        categoryId = cached;
      } else {
        categoryId =
            await repo.upsertCategory(name: categoryName, kind: categoryKind);
        categoryCache[key] = categoryId;
      }
    }

    final sig = repo.txSignature(
      type: type,
      amount: amount,
      categoryId: categoryId,
      happenedAt: happenedAt,
      note: note,
    );

    if (existing.contains(sig)) {
      skipped++;
      processed++;
      // 节流触发进度（每 200 条或最后）
      if (onProgress != null && (processed % 200 == 0)) {
        onProgress(processed, total);
      }
      continue;
    }

    toInsert.add(TransactionsCompanion.insert(
      ledgerId: ledgerId,
      type: type,
      amount: amount,
      categoryId: d.Value(categoryId),
      accountId: const d.Value(null),
      toAccountId: const d.Value(null),
      happenedAt: d.Value(happenedAt),
      note: d.Value(note),
    ));
    existing.add(sig);

    // 批量写入达到阈值时落盘并更新进度
    if (toInsert.length >= batchSize) {
      final n = await repo.insertTransactionsBatch(List.of(toInsert));
      toInsert.clear();
      inserted += n;
      processed += n;
      if (onProgress != null) onProgress(processed, total);
    }
  }

  if (toInsert.isNotEmpty) {
    final n = await repo.insertTransactionsBatch(toInsert);
    inserted += n;
    processed += n;
  }

  if (onProgress != null) onProgress(processed, total);

  return (inserted: inserted, skipped: skipped);
}
