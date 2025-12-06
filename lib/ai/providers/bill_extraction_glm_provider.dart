import 'package:flutter_ai_kit_zhipu/flutter_ai_kit_zhipu.dart';
import 'bill_extraction_glm_base_provider.dart';

/// 账单提取专用GLM Provider（文本模型）
///
/// 使用GLM-4-Flash文本模型进行账单信息提取（速度优化版）
class BillExtractionGLMProvider extends BillExtractionGLMBaseProvider {
  BillExtractionGLMProvider(
    String apiKey, {
    super.expenseCategories,
    super.incomeCategories,
    super.accounts,
    super.customPromptTemplate,
  }) : super(
          baseProvider: ZhipuGLMProvider(
            apiKey: apiKey,
            model: 'glm-4-flash', // 使用GLM-4-Flash模型（更快）
          ),
        );

  @override
  String get id => 'bill_extraction_glm';

  @override
  String get name => '智谱GLM-账单提取';

  @override
  String getInputSourceDescription() {
    return '从以下支付账单文本中';
  }
}
