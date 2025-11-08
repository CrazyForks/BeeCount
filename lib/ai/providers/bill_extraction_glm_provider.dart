import 'dart:convert';
import 'package:flutter_ai_kit/flutter_ai_kit.dart';
import 'package:flutter_ai_kit_zhipu/flutter_ai_kit_zhipu.dart';
import '../tasks/bill_extraction_task.dart';

/// 账单提取专用GLM Provider
///
/// 包装ZhipuGLMProvider，处理账单提取业务逻辑
class BillExtractionGLMProvider implements AIProvider<String, BillInfo> {
  final ZhipuGLMProvider _baseProvider;
  final List<String>? expenseCategories;
  final List<String>? incomeCategories;

  BillExtractionGLMProvider(
    String apiKey, {
    this.expenseCategories,
    this.incomeCategories,
  }) : _baseProvider = ZhipuGLMProvider(
          apiKey: apiKey,
          model: 'glm-4-flash', // 使用免费模型
        );

  @override
  String get id => 'bill_extraction_glm';

  @override
  String get name => '智谱GLM-账单提取';

  @override
  AIProviderType get type => _baseProvider.type;

  @override
  bool get requiresNetwork => _baseProvider.requiresNetwork;

  @override
  bool supportsTask(String taskType) => taskType == 'bill_extraction';

  @override
  Future<bool> isReady() => _baseProvider.isReady();

  @override
  Future<AIResult<BillInfo>> execute(AITask<String, BillInfo> task) async {
    // 1. 构建账单提取Prompt
    final prompt = _buildPrompt(task.input);

    // 2. 调用底层GLM Provider
    final textTask = _TextTask(prompt);
    final result = await _baseProvider.execute(textTask);

    if (!result.success) {
      return AIResult.failure(
        result.error!,
        result.duration,
        metadata: result.metadata,
      );
    }

    // 3. 解析业务结果
    try {
      final billInfo = _parseResponse(result.data!);
      return AIResult.success(
        billInfo,
        result.duration,
        metadata: result.metadata,
      );
    } catch (e) {
      return AIResult.failure(
        '解析账单信息失败: $e',
        result.duration,
        metadata: result.metadata,
      );
    }
  }

  @override
  Future<double> estimateCost(AITask<String, BillInfo> task) =>
      _baseProvider.estimateCost(_TextTask(task.input));

  /// 构建账单提取Prompt
  String _buildPrompt(String ocrText) {
    // 构建分类提示
    String categoryHint;
    if ((expenseCategories != null && expenseCategories!.isNotEmpty) ||
        (incomeCategories != null && incomeCategories!.isNotEmpty)) {
      final expenseHint = expenseCategories != null && expenseCategories!.isNotEmpty
          ? '支出分类：${expenseCategories!.join('、')}'
          : '';
      final incomeHint = incomeCategories != null && incomeCategories!.isNotEmpty
          ? '收入分类：${incomeCategories!.join('、')}'
          : '';

      categoryHint = [expenseHint, incomeHint].where((s) => s.isNotEmpty).join('\n');
    } else {
      categoryHint = '''
支出分类：餐饮、交通、购物、娱乐、居家、通讯、水电、医疗、教育等
收入分类：工资、理财、红包、奖金、报销、兼职等''';
    }

    return '''
从以下支付账单文本中提取信息，返回JSON格式。

账单文本：
$ocrText

用户的分类列表：
$categoryHint

要求：
1. amount: 实际支付金额（数字，支出为负数，收入为正数）
   - 优先选择带负号的金额（如-14.93）
   - 如果有"订单金额"和"实付款"，选择实付款
   - 忽略优惠券、红包等金额
2. time: 支付时间（ISO8601格式，如"2025-11-08T14:30:00"）
   - 查找"支付时间"字段
3. merchant: 收款方全称或商家名称
   - 优先使用"收款方全称"字段
   - 避免使用优惠券名称（如"晚餐到店红包"）
4. category: 从上述分类列表中选择最匹配的一个（必须完全匹配用户的分类名称）
   - 根据商家名称和交易描述判断
   - 例如：停车场→停车，餐厅→餐饮，超市→购物
5. type: 类型（income 或 expense）

示例输出：
{
  "amount": -14.93,
  "time": "2025-11-05T17:05:39",
  "merchant": "杭州西溪湿地运营管理有限公司",
  "category": "停车",
  "type": "expense"
}

注意：
- 只返回JSON，不要其他文字
- 如果无法提取某个字段，设置为null
- category必须从上述分类列表中选择，支出选支出分类，收入选收入分类
- 支出金额为负数，收入金额为正数
- 优先使用准确的字段名称（如"收款方全称"），而不是模糊的描述
''';
  }

  /// 解析GLM响应
  BillInfo _parseResponse(String response) {
    // 提取JSON（可能包含```json包裹）
    final jsonMatch = RegExp(r'\{[\s\S]*?\}').firstMatch(response);
    if (jsonMatch == null) {
      throw Exception('响应中没有找到JSON: $response');
    }

    final jsonStr = jsonMatch.group(0)!;
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;

    return BillInfo.fromJson(json);
  }
}

/// 内部文本任务（用于调用ZhipuGLMProvider）
class _TextTask extends AITask<String, String> {
  @override
  String get taskType => 'text_extraction';

  @override
  final String input;

  _TextTask(this.input);

  @override
  Map<String, dynamic> toJson() => {'input': input};
}
