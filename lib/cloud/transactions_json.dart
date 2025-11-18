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
/// - version: 数据格式版本（当前为3）
/// - exportedAt: 导出时间戳
/// - ledgerId: 账本ID
/// - ledgerName: 账本名称
/// - currency: 货币
/// - count: 交易条数
/// - accounts: 账户列表（name, type, currency, initialBalance）
/// - categories: 分类列表（name, kind, level, icon, parentName）
/// - items: 交易明细（type, amount, categoryName, categoryKind, happenedAt, note）
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
  final allCategoriesSet = <int>{}; // 存储所有相关分类ID（包括父分类）

  for (final cid in usedCatIds) {
    final c = await (db.select(db.categories)..where((c) => c.id.equals(cid)))
        .getSingleOrNull();
    if (c != null) {
      final sanitizedName = _sanitizeString(c.name);
      cats[cid] = {"name": sanitizedName, "kind": c.kind};
      allCategoriesSet.add(cid);

      // 如果是二级分类，也需要导出其父分类
      if (c.level == 2 && c.parentId != null) {
        allCategoriesSet.add(c.parentId!);
      }
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

  // v1.15.0: 导出该账本交易中使用的账户
  final usedAccountIds = txs.map((t) => t.accountId).whereType<int>().toSet();
  final accounts = <Account>[];
  for (final aid in usedAccountIds) {
    final a = await (db.select(db.accounts)..where((a) => a.id.equals(aid)))
        .getSingleOrNull();
    if (a != null) {
      accounts.add(a);
    }
  }
  final accountItems = accounts
      .map((a) => {
            'name': _sanitizeString(a.name),
            'type': a.type,
            'currency': a.currency, // v1.15.0: 导出币种
            'initialBalance': a.initialBalance,
          })
      .toList();

  // 构建 categories 数组（包含图标、层级、父分类信息）
  final categoryItems = <Map<String, dynamic>>[];
  final allCategoriesList = await (db.select(db.categories)
        ..where((c) => c.id.isIn(allCategoriesSet.toList())))
      .get();

  // 先导出一级分类，再导出二级分类（便于导入时先创建父分类）
  allCategoriesList.sort((a, b) {
    if (a.level != b.level) return a.level.compareTo(b.level);
    return a.id.compareTo(b.id);
  });

  for (final cat in allCategoriesList) {
    final categoryItem = <String, dynamic>{
      'name': _sanitizeString(cat.name),
      'kind': cat.kind,
      'level': cat.level,
    };

    // 添加图标信息（如果存在）
    if (cat.icon != null && cat.icon!.isNotEmpty) {
      categoryItem['icon'] = cat.icon;
    }

    // 添加父分类名称（如果是二级分类）
    if (cat.level == 2 && cat.parentId != null) {
      final parentCat = allCategoriesList.firstWhere(
        (c) => c.id == cat.parentId,
        orElse: () => allCategoriesList.first, // 不应该发生
      );
      categoryItem['parentName'] = _sanitizeString(parentCat.name);
    }

    categoryItems.add(categoryItem);
  }

  final payload = {
    'version': 3, // 版本升级,新增分类信息
    'exportedAt': DateTime.now().toUtc().toIso8601String(),
    'ledgerId': ledgerId,
    'ledgerName': ledger?.name,
    'currency': ledger?.currency,
    'count': items.length,
    'accounts': accountItems,
    'categories': categoryItems, // 新增：分类信息
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
      // v1.15.0: 获取所有现有账户（全局去重）
      final existingAccounts = await repo.getAllAccounts();
      final existingAccountNames =
          existingAccounts.map((a) => a.name).toSet();

      // v1.15.0: 只导入不存在的账户（按名称全局去重）
      for (final acc in accounts.cast<Map<String, dynamic>>()) {
        final name = acc['name'] as String;
        if (!existingAccountNames.contains(name)) {
          final type = acc['type'] as String? ?? 'cash';
          final initialBalance =
              (acc['initialBalance'] as num?)?.toDouble() ?? 0.0;
          // v1.15.0: 优先使用账户自己的币种，否则使用账本币种
          final accountCurrency = acc['currency'] as String? ?? currency ?? 'CNY';
          await repo.createAccount(
            ledgerId: 0, // v1.15.0: 账户独立，不绑定账本
            name: name,
            type: type,
            currency: accountCurrency, // v1.15.0: 使用账户币种
            initialBalance: initialBalance,
          );
        }
      }
    } catch (_) {
      // 账户导入失败不影响交易导入
    }
  }

  // 导入分类信息 (version 3+)
  final categories = data['categories'] as List?;
  final categoryCacheForImport = <String, int>{}; // key: kind|name -> id

  if (categories != null) {
    try {
      // 获取所有现有分类
      final existingCategories = await repo.db.select(repo.db.categories).get();
      final existingCategoryMap = <String, Category>{};
      for (final cat in existingCategories) {
        existingCategoryMap['${cat.kind}|${cat.name}'] = cat;
      }

      // 先导入一级分类，再导入二级分类
      final level1Categories = <Map<String, dynamic>>[];
      final level2Categories = <Map<String, dynamic>>[];

      for (final cat in categories.cast<Map<String, dynamic>>()) {
        final level = cat['level'] as int? ?? 1;
        if (level == 1) {
          level1Categories.add(cat);
        } else {
          level2Categories.add(cat);
        }
      }

      // 导入一级分类
      for (final cat in level1Categories) {
        final name = cat['name'] as String;
        final kind = cat['kind'] as String;
        final icon = cat['icon'] as String?;
        final key = '$kind|$name';

        if (existingCategoryMap.containsKey(key)) {
          // 分类已存在，使用现有ID
          categoryCacheForImport[key] = existingCategoryMap[key]!.id;
        } else {
          // 创建新分类
          final id = await repo.db.into(repo.db.categories).insert(
            CategoriesCompanion.insert(
              name: name,
              kind: kind,
              level: const d.Value(1),
              icon: d.Value(icon),
            ),
          );
          categoryCacheForImport[key] = id;
        }
      }

      // 导入二级分类
      for (final cat in level2Categories) {
        final name = cat['name'] as String;
        final kind = cat['kind'] as String;
        final icon = cat['icon'] as String?;
        final parentName = cat['parentName'] as String?;
        final key = '$kind|$name';

        if (existingCategoryMap.containsKey(key)) {
          // 分类已存在，使用现有ID
          categoryCacheForImport[key] = existingCategoryMap[key]!.id;
        } else if (parentName != null) {
          // 查找父分类ID
          final parentKey = '$kind|$parentName';
          final parentId = categoryCacheForImport[parentKey];

          if (parentId != null) {
            // 创建二级分类
            final id = await repo.db.into(repo.db.categories).insert(
              CategoriesCompanion.insert(
                name: name,
                kind: kind,
                level: const d.Value(2),
                parentId: d.Value(parentId),
                icon: d.Value(icon),
              ),
            );
            categoryCacheForImport[key] = id;
          }
        }
      }
    } catch (_) {
      // 分类导入失败不影响交易导入
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
  // 如果有 categories 数组，优先使用其中的分类信息
  final categoryCache = <String, int>{}; // key: kind|name -> id
  categoryCache.addAll(categoryCacheForImport); // 优先使用从 categories 导入的分类

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
        // 如果 categories 数组中没有，回退到 upsertCategory（兼容旧版本）
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
