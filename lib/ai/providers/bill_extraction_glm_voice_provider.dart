import 'dart:io';
import 'dart:convert';
import 'package:flutter_ai_kit/flutter_ai_kit.dart';
import 'package:flutter_ai_kit_zhipu/flutter_ai_kit_zhipu.dart';
import '../../services/logger_service.dart';
import '../tasks/bill_extraction_task.dart';

/// 账单提取专用GLM Provider（语音模型）
///
/// 直接使用GLM-4-Voice从语音中提取账单信息JSON
class BillExtractionGLMVoiceProvider implements AIProvider<String, BillInfo> {
  final String apiKey;
  final File audioFile;
  final List<String>? expenseCategories;
  final List<String>? incomeCategories;
  final List<String>? accounts;

  BillExtractionGLMVoiceProvider(
    this.apiKey, {
    this.expenseCategories,
    this.incomeCategories,
    this.accounts,
    required this.audioFile,
  });

  @override
  String get id => 'bill_extraction_glm_voice';

  @override
  String get name => '智谱GLM-语音记账';

  @override
  AIProviderType get type => AIProviderType.cloud;

  @override
  bool get requiresNetwork => true;

  @override
  bool supportsTask(String taskType) => taskType == 'bill_extraction';

  @override
  Future<bool> isReady() async => apiKey.isNotEmpty;

  @override
  Future<AIResult<BillInfo>> execute(AITask<String, BillInfo> task) async {
    final startTime = DateTime.now();

    try {
      logger.info('VoiceASR', '使用GLM-4-Voice直接提取账单信息');

      // 构建prompt
      final prompt = _buildPrompt();

      final glmProvider = ZhipuGLMProvider(
        apiKey: apiKey,
        model: 'glm-4-voice',
        audioFile: audioFile,
        temperature: 0.0, // 设置为0以获得确定性输出
      );

      final voiceTask = _TextTask(prompt);
      final result = await glmProvider.execute(voiceTask);

      if (!result.success) {
        return AIResult.failure(
          '语音识别失败: ${result.error}',
          DateTime.now().difference(startTime),
        );
      }

      final response = result.data!;
      logger.debug('VoiceASR', '原始响应: $response');

      // 尝试解析JSON
      try {
        final billInfo = _parseResponse(response);
        logger.info('VoiceASR', '账单提取成功: ${billInfo.category}');
        return AIResult.success(
          billInfo,
          DateTime.now().difference(startTime),
        );
      } catch (e) {
        logger.warning('VoiceASR', 'JSON解析失败，尝试文本提取: $e');

        // 如果JSON解析失败，尝试从对话文本中提取信息
        final billInfo = _extractFromText(response);
        if (billInfo != null) {
          return AIResult.success(
            billInfo,
            DateTime.now().difference(startTime),
          );
        }

        throw Exception('无法从响应中提取账单信息: $response');
      }
    } catch (e, stackTrace) {
      logger.error('VoiceASR', '语音账单提取失败', e, stackTrace);
      return AIResult.failure(
        '语音账单提取失败: $e',
        DateTime.now().difference(startTime),
      );
    }
  }

  /// 构建Prompt
  String _buildPrompt() {
    final categoryHint = _buildCategoryHint();
    final accountHint = _buildAccountHint();

    return '''你是一个专业的账单提取助手。用户会通过语音告诉你记账信息，你必须严格按照JSON格式返回，不要返回任何其他文字或解释。

用户的分类列表：
$categoryHint$accountHint

请识别语音内容并提取记账信息，返回以下JSON格式（不要包含```json标记）：

{
  "amount": -35.00,
  "time": null,
  "merchant": "星巴克",
  "category": "餐饮",
  "type": "expense",
  "account": "微信支付"
}

字段说明：
1. amount: 金额（支出为负数，收入为正数）。如"花了50块"→-50，"收入100"→100
2. time: 交易时间（ISO8601格式，如"2025-11-25T14:30:00"）。如果没有明确时间，必须设置为null
3. merchant: 商家名称或交易描述。如"在星巴克买咖啡"→"星巴克"
4. category: 从上述分类列表中选择最匹配的一个（必须完全匹配）
5. type: "income"或"expense"
6. account: 支付账户名称（可选），从用户账户列表中选择或识别常见账户

重要：只返回JSON对象，不要任何解释或对话。''';
  }

  /// 构建分类提示
  String _buildCategoryHint() {
    if ((expenseCategories != null && expenseCategories!.isNotEmpty) ||
        (incomeCategories != null && incomeCategories!.isNotEmpty)) {
      final expenseHint = expenseCategories != null && expenseCategories!.isNotEmpty
          ? '支出分类：${expenseCategories!.join('、')}'
          : '';
      final incomeHint = incomeCategories != null && incomeCategories!.isNotEmpty
          ? '收入分类：${incomeCategories!.join('、')}'
          : '';

      return [expenseHint, incomeHint].where((s) => s.isNotEmpty).join('\n');
    } else {
      return '''支出分类：餐饮、交通、购物、娱乐、居家等
收入分类：工资、理财、红包、奖金等''';
    }
  }

  /// 构建账户提示
  String _buildAccountHint() {
    if (accounts != null && accounts!.isNotEmpty) {
      return '\n用户的账户列表：\n${accounts!.join('、')}';
    }
    return '';
  }

  /// 解析响应
  BillInfo _parseResponse(String response) {
    // 提取JSON
    final jsonMatch = RegExp(r'\{[\s\S]*?\}').firstMatch(response);
    if (jsonMatch == null) {
      throw Exception('响应中没有找到JSON');
    }

    final jsonStr = jsonMatch.group(0)!;
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;

    return BillInfo.fromJson(json);
  }

  /// 从对话文本中提取信息（fallback方案）
  BillInfo? _extractFromText(String text) {
    // 方案1：尝试解析CSV格式
    // 格式：amount, time, merchant, category, type, account
    // 示例：-35.00, "2023-11-25T14:30:00", "星巴克", "餐饮","支出", "微信支付"
    final csvMatch = RegExp(
      r'(-?\d+(?:\.\d+)?)\s*,\s*(?:"([^"]*)"|\s*null)\s*,\s*"([^"]*)"\s*,\s*"([^"]*)"\s*,\s*"?([^",]*)"?\s*(?:,\s*"([^"]*)")?'
    ).firstMatch(text);

    if (csvMatch != null) {
      final amount = double.tryParse(csvMatch.group(1)!);
      final timeStr = csvMatch.group(2);
      final merchant = csvMatch.group(3);
      final category = csvMatch.group(4);
      final typeStr = csvMatch.group(5);
      final account = csvMatch.group(6);

      return BillInfo(
        amount: amount,
        time: timeStr != null && timeStr.isNotEmpty ? DateTime.tryParse(timeStr) : null,
        merchant: merchant,
        category: category,
        type: _parseBillType(typeStr),
        account: account,
        confidence: 0.8,
      );
    }

    // 方案2：尝试提取金额
    final amountMatch = RegExp(r'(-?\d+(?:\.\d+)?)\s*块|元|yuan').firstMatch(text);
    if (amountMatch == null) return null;

    final amount = double.parse(amountMatch.group(1)!);

    // 尝试识别分类关键词
    String? category;
    if (text.contains('吃饭') || text.contains('午餐') || text.contains('晚餐') || text.contains('早餐')) {
      category = '餐饮';
    } else if (text.contains('打车') || text.contains('地铁') || text.contains('公交')) {
      category = '交通';
    } else if (text.contains('购物') || text.contains('买')) {
      category = '购物';
    }

    return BillInfo(
      amount: amount,
      time: null,
      merchant: '语音记录',
      category: category,
      type: amount < 0 ? BillType.expense : BillType.income,
      confidence: 0.5, // 低置信度
    );
  }

  /// 解析账单类型
  BillType? _parseBillType(String? value) {
    if (value == null) return null;
    final str = value.toLowerCase().trim();
    if (str.contains('income') || str == '收入') return BillType.income;
    if (str.contains('expense') || str == '支出') return BillType.expense;
    return null;
  }

  @override
  Future<double> estimateCost(AITask<String, BillInfo> task) async {
    return 0.01;
  }
}

/// 内部文本任务
class _TextTask extends AITask<String, String> {
  @override
  String get taskType => 'text_extraction';

  @override
  final String input;

  _TextTask(this.input);

  @override
  Map<String, dynamic> toJson() => {'input': input};
}
