import 'dart:convert';
import 'package:flutter_ai_kit/flutter_ai_kit.dart';
import 'package:flutter_ai_kit_zhipu/flutter_ai_kit_zhipu.dart';
import '../tasks/bill_extraction_task.dart';
import '../../services/logger_service.dart';

/// 账单提取GLM Provider基类
///
/// 封装公共逻辑，供文本和视觉Provider继承
abstract class BillExtractionGLMBaseProvider implements AIProvider<String, BillInfo> {
  final ZhipuGLMProvider baseProvider;
  final List<String>? expenseCategories;
  final List<String>? incomeCategories;
  final List<String>? accounts;

  BillExtractionGLMBaseProvider({
    required this.baseProvider,
    this.expenseCategories,
    this.incomeCategories,
    this.accounts,
  });

  @override
  AIProviderType get type => baseProvider.type;

  @override
  bool get requiresNetwork => baseProvider.requiresNetwork;

  @override
  bool supportsTask(String taskType) => taskType == 'bill_extraction';

  @override
  Future<bool> isReady() => baseProvider.isReady();

  @override
  Future<AIResult<BillInfo>> execute(AITask<String, BillInfo> task) async {
    // 1. 构建账单提取Prompt（由子类实现）
    final prompt = buildPrompt(task.input);
    logger.debug('AI', '[Prompt长度] ${prompt.length}');
    logger.debug('AI', '[完整Prompt]\n$prompt');

    // 2. 调用底层GLM Provider
    final textTask = _TextTask(prompt);
    final result = await baseProvider.execute(textTask);

    if (!result.success) {
      return AIResult.failure(
        result.error!,
        result.duration,
        metadata: result.metadata,
      );
    }

    // 3. 打印AI原始返回结果
    logger.debug('AI', '[原始返回] ${result.data}');

    // 4. 解析业务结果
    try {
      final billInfo = parseResponse(result.data!);
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
      baseProvider.estimateCost(_TextTask(task.input));

  /// 构建Prompt（统一模板，由子类提供输入源描述）
  String buildPrompt(String ocrText) {
    final categoryHint = buildCategoryHint();
    final accountHint = buildAccountHint();
    final inputSource = getInputSourceDescription();

    // 获取当前日期时间
    final now = DateTime.now();
    final currentDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final currentHour = now.hour.toString().padLeft(2, '0');
    final currentMinute = now.minute.toString().padLeft(2, '0');

    return '''
$inputSource提取记账信息，返回JSON。

当前时间：$currentDate $currentHour:$currentMinute

$ocrText

$categoryHint$accountHint

字段说明：
1. amount: 金额（支出负数，收入正数）
2. time: ISO8601格式，尽量推断时间：
   - 明确时间（如"14:30"、"2025-11-25"）→直接使用
   - 相对日期（昨天、前天、上周）→推算具体日期
   - 时间段（早上、中午、晚上）→使用合理时刻（早上09:00、中午12:00、晚上19:00）
   - 完全没提时间→使用当前时间
3. merchant: 商家名称（如果没有明确商家信息，省略此字段或返回空字符串，不要返回"未知"）
4. category: 从分类列表选择
5. type: income或expense
6. account: 支付账户（可选）

示例：
输入"昨天中午吃饭50" → {"amount":-50,"time":"2025-11-24T12:00:00","category":"餐饮","type":"expense"}
输入"早上买咖啡30" → {"amount":-30,"time":"${currentDate}T09:00:00","category":"咖啡","type":"expense"}
输入"买了件衣服200" → {"amount":-200,"time":"${currentDate}T$currentHour:$currentMinute:00","category":"服装","type":"expense"}

注意：只返回JSON，尽量推断时间不要返回null，merchant没有时省略或留空
''';
  }

  /// 获取输入源描述（由子类实现）
  /// 例如："从以下支付账单文本中"、"识别图片中的账单，从中"、"识别语音内容，从中"
  String getInputSourceDescription();

  /// 构建分类提示（公共方法）
  String buildCategoryHint() {
    if ((expenseCategories != null && expenseCategories!.isNotEmpty) ||
        (incomeCategories != null && incomeCategories!.isNotEmpty)) {
      final parts = <String>[];
      if (expenseCategories != null && expenseCategories!.isNotEmpty) {
        parts.add('支出：${expenseCategories!.join('、')}');
      }
      if (incomeCategories != null && incomeCategories!.isNotEmpty) {
        parts.add('收入：${incomeCategories!.join('、')}');
      }
      return '分类列表：\n${parts.join('\n')}';
    } else {
      return '分类列表：\n支出：餐饮、交通、购物、娱乐、居家、通讯、水电、医疗、教育\n收入：工资、理财、红包、奖金、报销、兼职';
    }
  }

  /// 构建账户提示（公共方法）
  String buildAccountHint() {
    if (accounts != null && accounts!.isNotEmpty) {
      return '\n账户列表：${accounts!.join('、')}';
    }
    return '';
  }

  /// 解析GLM响应（公共方法）
  BillInfo parseResponse(String response) {
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
