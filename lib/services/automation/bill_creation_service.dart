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

    // 5. 使用Repository创建交易
    final repository = BeeRepository(db);
    final transactionId = await repository.addTransaction(
      ledgerId: ledgerId,
      type: transactionType,
      amount: result.amount!.abs(), // 金额使用绝对值，类型由type字段决定
      categoryId: categoryId,
      accountId: null,
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
