import 'dart:io';
import 'dart:convert';
import 'package:flutter_ai_kit/flutter_ai_kit.dart';
import 'package:flutter_ai_kit_zhipu/flutter_ai_kit_zhipu.dart';
import '../../services/system/logger_service.dart';
import '../tasks/bill_extraction_task.dart';
import 'bill_extraction_glm_base_provider.dart';

/// 账单提取专用GLM Provider（语音模型）
///
/// 直接使用GLM-4-Voice从语音中提取账单信息JSON
class BillExtractionGLMVoiceProvider extends BillExtractionGLMBaseProvider {
  final String apiKey;
  final File audioFile;

  BillExtractionGLMVoiceProvider(
    this.apiKey, {
    super.expenseCategories,
    super.incomeCategories,
    super.accounts,
    required this.audioFile,
  }) : super(
          baseProvider: ZhipuGLMProvider(
            apiKey: apiKey,
            model: 'glm-4-voice',
            temperature: 0.0,
          ),
        );

  @override
  String get id => 'bill_extraction_glm_voice';

  @override
  String get name => '智谱GLM-语音记账';

  @override
  String getInputSourceDescription() => '识别语音内容，从中';

  @override
  Future<AIResult<BillInfo>> execute(AITask<String, BillInfo> task) async {
    final startTime = DateTime.now();

    try {
      logger.info('VoiceASR', '使用GLM-4-Voice直接提取账单信息');

      // 构建prompt（使用父类方法）
      final prompt = buildPrompt('');  // 语音模式下ocrText为空

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

      // 尝试解析JSON（使用父类方法）
      try {
        final billInfo = parseResponse(response);
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

  /// 从对话文本中提取信息（fallback方案）
  BillInfo? _extractFromText(String text) {
    // 方案1：尝试解析CSV格式
    // 格式：amount, time, note, category, type, account
    // 示例：-35.00, "2023-11-25T14:30:00", "星巴克", "餐饮","支出", "微信支付"
    final csvMatch = RegExp(
      r'(-?\d+(?:\.\d+)?)\s*,\s*(?:"([^"]*)"|\s*null)\s*,\s*"([^"]*)"\s*,\s*"([^"]*)"\s*,\s*"?([^",]*)"?\s*(?:,\s*"([^"]*)")?'
    ).firstMatch(text);

    if (csvMatch != null) {
      final amount = double.tryParse(csvMatch.group(1)!);
      final timeStr = csvMatch.group(2);
      final note = csvMatch.group(3);
      final category = csvMatch.group(4);
      final typeStr = csvMatch.group(5);
      final account = csvMatch.group(6);

      return BillInfo(
        amount: amount,
        time: timeStr != null && timeStr.isNotEmpty ? DateTime.tryParse(timeStr) : null,
        note: note,
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
      note: '语音记录',
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
