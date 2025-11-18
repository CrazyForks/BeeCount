import 'dart:io';
import 'dart:ui' show Locale;

import 'package:drift/drift.dart';
import '../l10n/app_localizations.dart';
import '../services/category_service.dart';
import '../services/seed_service.dart';
import '../services/logger_service.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'db.g.dart';

// --- Tables ---

class Ledgers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get currency => text().withDefault(const Constant('CNY'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ledgerId => integer()(); // 保留用于v2迁移，后续会移除
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant('cash'))();
  TextColumn get currency =>
      text().withDefault(const Constant('CNY'))(); // v1.15.0新增：币种
  RealColumn get initialBalance => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt =>
      dateTime().nullable()(); // v1.15.0: 改为可空，避免迁移问题
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get kind => text()(); // expense / income
  TextColumn get icon => text().nullable()();
  IntColumn get sortOrder =>
      integer().withDefault(const Constant(0))(); // 排序顺序，数字越小越靠前
  IntColumn get parentId => integer().nullable()(); // 父分类ID，null 表示一级分类
  IntColumn get level =>
      integer().withDefault(const Constant(1))(); // 层级：1=一级，2=二级
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ledgerId => integer()();
  TextColumn get type => text()(); // expense / income / transfer
  RealColumn get amount => real()();
  IntColumn get categoryId => integer().nullable()();
  IntColumn get accountId => integer().nullable()();
  IntColumn get toAccountId => integer().nullable()();
  DateTimeColumn get happenedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().nullable()();
  IntColumn get recurringId => integer().nullable()(); // 关联到重复交易模板
}

class RecurringTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ledgerId => integer()();
  TextColumn get type => text()(); // expense / income
  RealColumn get amount => real()();
  IntColumn get categoryId => integer()();
  IntColumn get accountId => integer().nullable()();
  TextColumn get note => text().nullable()();

  // 重复规则
  TextColumn get frequency => text()(); // daily / weekly / monthly / yearly
  IntColumn get interval =>
      integer().withDefault(const Constant(1))(); // 间隔（每1天、每2周等）
  IntColumn get dayOfMonth => integer().nullable()(); // 月的第几天（1-31）
  IntColumn get dayOfWeek => integer().nullable()(); // 周几（1=周一, 7=周日）
  IntColumn get monthOfYear => integer().nullable()(); // 哪个月（1-12，用于yearly）

  // 时间范围
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()(); // 为空表示永久
  DateTimeColumn get lastGeneratedDate =>
      dateTime().nullable()(); // 最后一次生成交易的日期

  // 状态
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [
  Ledgers,
  Accounts,
  Categories,
  Transactions,
  RecurringTransactions
])
class BeeDatabase extends _$BeeDatabase {
  BeeDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6; // v6: 二级分类支持（添加parentId、level字段）

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            // 添加 sortOrder 字段（使用原始 SQL，因为此时代码还未生成）
            await customStatement(
                'ALTER TABLE categories ADD COLUMN sort_order INTEGER NOT NULL DEFAULT 0;');

            // 为现有分类设置默认的 sortOrder（按 id 顺序）
            await customStatement('''
          UPDATE categories
          SET sort_order = (
            SELECT COUNT(*)
            FROM categories AS c2
            WHERE c2.id <= categories.id
          ) - 1;
        ''');
          }
          if (from < 3) {
            // 创建重复交易表
            await migrator.createTable(recurringTransactions);

            // 为 transactions 表添加 recurring_id 字段
            await customStatement(
                'ALTER TABLE transactions ADD COLUMN recurring_id INTEGER;');
          }
          if (from < 4) {
            // 为 accounts 表添加 initial_balance 字段
            await customStatement(
                'ALTER TABLE accounts ADD COLUMN initial_balance REAL NOT NULL DEFAULT 0.0;');
          }
          if (from < 5) {
            // v5: 账户独立改造
            // 注意：数据迁移逻辑在 MigrationService 中统一处理
            // 这里只添加必要的字段

            // 检查字段是否已存在，避免重复添加
            final tableInfo =
                await customSelect('PRAGMA table_info(accounts)').get();
            final hasCurrency =
                tableInfo.any((row) => row.data['name'] == 'currency');
            final hasCreatedAt =
                tableInfo.any((row) => row.data['name'] == 'created_at');
            final hasUpdatedAt =
                tableInfo.any((row) => row.data['name'] == 'updated_at');

            if (!hasCurrency) {
              await customStatement(
                  'ALTER TABLE accounts ADD COLUMN currency TEXT NOT NULL DEFAULT \'CNY\';');
            }

            if (!hasCreatedAt) {
              // SQLite 不支持非常量默认值，先添加可空字段，然后更新
              await customStatement(
                  'ALTER TABLE accounts ADD COLUMN created_at INTEGER;');
              await customStatement(
                  'UPDATE accounts SET created_at = strftime(\'%s\', \'now\') WHERE created_at IS NULL;');
            }

            if (!hasUpdatedAt) {
              await customStatement(
                  'ALTER TABLE accounts ADD COLUMN updated_at INTEGER;');
            }

            // 注意：不在onUpgrade中更新currency数据
            // 数据迁移统一由 MigrationService 处理，避免重复逻辑
          }
          if (from < 6) {
            // v6: 二级分类支持
            // 检查字段是否已存在，避免重复添加
            final tableInfo =
                await customSelect('PRAGMA table_info(categories)').get();
            final hasParentId =
                tableInfo.any((row) => row.data['name'] == 'parent_id');
            final hasLevel =
                tableInfo.any((row) => row.data['name'] == 'level');

            if (!hasParentId) {
              await customStatement(
                  'ALTER TABLE categories ADD COLUMN parent_id INTEGER;');
            }

            if (!hasLevel) {
              await customStatement(
                  'ALTER TABLE categories ADD COLUMN level INTEGER NOT NULL DEFAULT 1;');
            }

            // 确保所有现有分类的 level 都为 1（一级分类）
            await customStatement(
                'UPDATE categories SET level = 1 WHERE level IS NULL OR level = 0;');
          }
        },
      );

  // Seed minimal data
  /// [l10n] 国际化对象，如果为null则使用英文作为默认语言
  /// [currency] 货币代码
  /// [useHierarchicalCategories] 是否使用二级分类
  ///
  /// 注意：此方法只应在真正的首次初始化时调用（欢迎页完成时）
  Future<void> ensureSeed({
    AppLocalizations? l10n,
    String currency = 'CNY',
    bool useHierarchicalCategories = false,
  }) async {
    logger.info('db', 'ensureSeed 被调用');
    logger.info('db', 'l10n 是否提供: ${l10n != null}');
    logger.info('db', '货币: $currency');
    logger.info('db', '使用二级分类: $useHierarchicalCategories');

    // 如果没有提供l10n，使用Lookup创建默认的英文版本
    final effectiveL10n = l10n ?? lookupAppLocalizations(const Locale('en'));
    logger.info('db', '使用的语言环境: ${l10n != null ? "提供的l10n" : "默认英文"}');

    await SeedService.seedDatabase(
      this,
      effectiveL10n,
      currency: currency,
      useHierarchicalCategories: useHierarchicalCategories,
    );
    logger.info('db', '数据库初始化完成');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'beecount.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
