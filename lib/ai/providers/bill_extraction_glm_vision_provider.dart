import 'dart:io';
import 'package:flutter_ai_kit/flutter_ai_kit.dart';
import 'package:flutter_ai_kit_zhipu/flutter_ai_kit_zhipu.dart';
import '../tasks/bill_extraction_task.dart';
import 'bill_extraction_glm_base_provider.dart';

/// 账单提取GLM Vision Provider（视觉模型）
///
/// 使用GLM-4V-Flash视觉模型，支持图片识别
class BillExtractionGLMVisionProvider extends BillExtractionGLMBaseProvider {
  final File? imageFile;

  BillExtractionGLMVisionProvider(
    String apiKey, {
    super.expenseCategories,
    super.incomeCategories,
    super.accounts,
    super.customPromptTemplate,
    this.imageFile,
  }) : super(
          baseProvider: ZhipuGLMProvider(
            apiKey: apiKey,
            model: 'glm-4v-flash', // 使用免费的视觉模型
            imageFile: imageFile,
          ),
        );

  @override
  String get id => 'bill_extraction_glm_vision';

  @override
  String get name => '智谱GLM-4V-账单提取';

  @override
  Future<double> estimateCost(AITask<String, BillInfo> task) async {
    // GLM-4V-Flash 完全免费
    return 0.0;
  }

  @override
  String getInputSourceDescription() {
    return '分析支付账单截图，从中';
  }
}
