import 'package:shared_preferences/shared_preferences.dart';
import '../../data/db.dart';
import '../../data/repository.dart';
import 'category_matcher.dart';
import 'ocr_service.dart';

/// 账单创建服务
///
/// 提供统一的账单创建接口，供OCR手动扫描和自动记账使用
class BillCreationService {
  final BeeDatabase db;

  BillCreationService(this.db);

  /// 匹配分类
  ///
  /// 优先使用AI识别的分类名称，失败则降级到规则匹配
  /// 返回匹配的分类ID，如果都失败则返回null
  Future<int?> matchCategory(
    OcrResult result,
    List<Category> categories,
  ) async {
    // 1. 优先使用AI识别的分类
    if (result.aiCategoryName != null &&
        result.aiCategoryName!.isNotEmpty &&
        categories.isNotEmpty) {
      try {
        final matchedCategory = categories.firstWhere(
          (cat) => cat.name == result.aiCategoryName,
        );
        final transactionType = result.aiType ?? 'expense';
        print(
            '✅ [分类匹配] AI分类"${result.aiCategoryName}"($transactionType) → ID:${matchedCategory.id}');
        return matchedCategory.id;
      } catch (_) {
        print('⚠️ [分类匹配] AI分类"${result.aiCategoryName}"未找到，降级使用规则匹配');
      }
    }

    // 2. 降级使用规则匹配
    if (categories.isNotEmpty) {
      return CategoryMatcher.smartMatch(
        merchant: result.merchant,
        fullText: result.rawText,
        categories: categories,
      );
    }

    return null;
  }

  /// 匹配账户
  ///
  /// 在账户功能启用的前提下，根据AI识别的账户名称匹配账户ID
  /// 只匹配与当前账本币种相同的账户
  Future<int?> matchAccount(
    OcrResult result,
    int ledgerId,
  ) async {
    print('🔍 [账户匹配] 开始匹配账户...');

    // 1. 检查账户功能是否启用
    final prefs = await SharedPreferences.getInstance();
    final accountFeatureEnabled = prefs.getBool('account_feature_enabled') ?? true; // 默认启用，与provider保持一致
    print('   账户功能状态: ${accountFeatureEnabled ? "已启用" : "未启用"}');
    print('   SharedPreferences值: ${prefs.getBool('account_feature_enabled')}');

    if (!accountFeatureEnabled) {
      print('   ❌ 账户功能未启用，跳过匹配');
      return null;
    }

    // 2. 检查是否有AI识别的账户名称
    print('   AI识别的账户名称: "${result.aiAccountName}"');
    if (result.aiAccountName == null || result.aiAccountName!.isEmpty) {
      print('   ❌ AI未识别到账户名称，跳过匹配');
      return null;
    }

    // 3. 获取账本信息以确定币种
    final ledger = await (db.select(db.ledgers)
          ..where((t) => t.id.equals(ledgerId)))
        .getSingleOrNull();

    if (ledger == null) {
      print('   ❌ 账本不存在，跳过匹配');
      return null;
    }
    print('   账本币种: ${ledger.currency}');

    // 4. 查询与账本币种相同的所有账户
    final repository = BeeRepository(db);
    final allAccounts = await repository.getAllAccounts();
    final matchingAccounts = allAccounts
        .where((a) => a.currency == ledger.currency)
        .toList();

    print('   可用账户列表(${matchingAccounts.length}个): ${matchingAccounts.map((a) => a.name).join('、')}');

    // 5. 根据账户名称匹配（多级优先级匹配）
    final aiAccountName = result.aiAccountName!.toLowerCase().trim();
    print('   开始多级优先级匹配: "$aiAccountName"');

    // 第一优先级：名称完全相等（忽略大小写和空格）
    print('   [优先级1] 尝试完全匹配...');
    for (final account in matchingAccounts) {
      final accountNameLower = account.name.toLowerCase().trim();
      if (accountNameLower == aiAccountName) {
        print('✅ [账户匹配-完全] AI账户"${result.aiAccountName}" → ID:${account.id} (${account.name})');
        return account.id;
      }
    }

    // 第二优先级：名称包含关系（模糊匹配）
    print('   [优先级2] 尝试模糊匹配...');
    for (final account in matchingAccounts) {
      final accountNameLower = account.name.toLowerCase().trim();

      if (accountNameLower.contains(aiAccountName) ||
          aiAccountName.contains(accountNameLower)) {
        print('✅ [账户匹配-模糊] AI账户"${result.aiAccountName}" → ID:${account.id} (${account.name})');
        return account.id;
      }
    }

    // 第三优先级：账户类型匹配（如"余额宝"可能匹配"支付宝"类型的账户）
    print('   [优先级3] 尝试类型匹配...');
    final accountTypeMap = {
      '余额宝': ['支付宝', 'alipay'],
      '花呗': ['支付宝', 'alipay'],
      '微信支付': ['微信', 'wechat'],
      '微信钱包': ['微信', 'wechat'],
      '零钱': ['微信', 'wechat'],
      '零钱通': ['微信', 'wechat'],
    };

    final relatedTypes = accountTypeMap[aiAccountName] ?? [];
    if (relatedTypes.isNotEmpty) {
      for (final account in matchingAccounts) {
        final accountNameLower = account.name.toLowerCase().trim();
        for (final type in relatedTypes) {
          if (accountNameLower.contains(type.toLowerCase())) {
            print('✅ [账户匹配-类型] AI账户"${result.aiAccountName}" → ID:${account.id} (${account.name}) [通过类型映射]');
            return account.id;
          }
        }
      }
    }

    print('⚠️ [账户匹配] AI账户"${result.aiAccountName}"未找到匹配');
    print('   可用账户: ${matchingAccounts.map((a) => a.name).join('、')}');
    return null;
  }

  /// 创建账单交易
  ///
  /// [result] OCR识别结果（包含AI增强）
  /// [ledgerId] 账本ID
  /// [note] 备注（可选）
  /// 返回创建的交易ID，如果创建失败则返回null
  Future<int?> createBillTransaction({
    required OcrResult result,
    required int ledgerId,
    String? note,
  }) async {
    // 1. 验证金额
    if (result.amount == null || result.amount!.abs() <= 0) {
      return null;
    }

    // 2. 确定交易类型（优先使用AI识别的类型）
    final transactionType = result.aiType ?? 'expense';

    // 3. 查询对应类型的分类
    final categories = await (db.select(db.categories)
          ..where((t) => t.kind.equals(transactionType)))
        .get();

    // 4. 匹配分类
    final categoryId = await matchCategory(result, categories);

    // 5. 匹配账户（在账户功能启用的前提下）
    final accountId = await matchAccount(result, ledgerId);

    // 6. 使用Repository创建交易
    final repository = BeeRepository(db);
    final transactionId = await repository.addTransaction(
      ledgerId: ledgerId,
      type: transactionType,
      amount: result.amount!.abs(), // 金额使用绝对值，类型由type字段决定
      categoryId: categoryId,
      accountId: accountId,
      happenedAt: result.time ?? DateTime.now(),
      note: note,
    );

    return transactionId;
  }

  /// 获取分类列表（按类型）
  ///
  /// [type] 'income' 或 'expense'
  Future<List<Category>> getCategoriesByType(String type) async {
    return await (db.select(db.categories)..where((t) => t.kind.equals(type)))
        .get();
  }
}
