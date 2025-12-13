import 'dart:io';
import 'package:flutter_ai_kit/flutter_ai_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ai/tasks/bill_extraction_task.dart';
import '../../ai/providers/bill_extraction_glm_provider.dart';
import '../../ai/providers/bill_extraction_glm_vision_provider.dart';
import '../../ai/providers/bill_extraction_tflite_provider.dart';
import '../system/logger_service.dart';
import 'ai_constants.dart';

/// AI账单提取服务
///
/// 使用Flutter AI Kit处理账单识别
class AIBillService {
  final FlutterAIKit _aiKit = FlutterAIKit();
  bool _initialized = false;

  /// 初始化AI服务
  ///
  /// [expenseCategories] 支出分类列表（可选）
  /// [incomeCategories] 收入分类列表（可选）
  /// [accounts] 账户列表（可选）
  /// [imageFile] 图片文件（可选，用于Vision模型）
  Future<void> initialize({
    List<String>? expenseCategories,
    List<String>? incomeCategories,
    List<String>? accounts,
    File? imageFile,
  }) async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();

    // 读取用户自定义提示词
    final customPrompt = prefs.getString(AIConstants.keyAiCustomPrompt);

    // 1. 注册智谱GLM Provider（如果配置了API Key）
    final glmApiKey = prefs.getString(AIConstants.keyGlmApiKey);
    final glmVisionModel = prefs.getString(AIConstants.keyGlmVisionModel) ?? AIConstants.defaultGlmVisionModel;
    final glmModel = prefs.getString(AIConstants.keyGlmModel) ?? AIConstants.defaultGlmVisionModel;
    if (glmApiKey != null && glmApiKey.isNotEmpty) {
      // 检查是否启用图片上传
      final useVision = prefs.getBool(AIConstants.keyAiUseVision) ?? true; // 默认开启

      if (useVision && imageFile != null) {
        // 使用Vision模型
        logger.info('AIBillService', '使用GLM视觉模型: $glmVisionModel');
        _aiKit.registerProvider(BillExtractionGLMVisionProvider(
          glmApiKey,
          glmVisionModel,
          expenseCategories: expenseCategories,
          incomeCategories: incomeCategories,
          accounts: accounts,
          customPromptTemplate: customPrompt,
          imageFile: imageFile,
        ));
      } else {
        // 使用纯文本模型
        logger.info('AIBillService', '使用GLM文本模型: $glmModel');
        _aiKit.registerProvider(BillExtractionGLMProvider(
          glmApiKey,
          glmModel,
          expenseCategories: expenseCategories,
          incomeCategories: incomeCategories,
          accounts: accounts,
          customPromptTemplate: customPrompt,
        ));
      }
    }

    // 2. 注册本地TFLite Provider（如果模型已下载）
    final tfliteProvider = BillExtractionTFLiteProvider();
    if (await tfliteProvider.isReady()) {
      _aiKit.registerProvider(tfliteProvider);
    }

    // 3. 设置执行策略（从用户配置读取）
    final strategyType = prefs.getString(AIConstants.keyAiStrategy) ?? AIConstants.defaultStrategy;
    _aiKit.setStrategy(_getStrategy(strategyType));

    _initialized = true;
  }

  /// 提取账单信息
  ///
  /// [ocrText] OCR识别的文本
  /// [expenseCategories] 支出分类列表（可选）
  /// [incomeCategories] 收入分类列表（可选）
  /// [accounts] 账户列表（可选）
  /// [imageFile] 图片文件（可选，用于Vision模型）
  /// 返回 [BillInfo] 或 null（提取失败）
  Future<BillInfo?> extractBillInfo(
    String ocrText, {
    List<String>? expenseCategories,
    List<String>? incomeCategories,
    List<String>? accounts,
    File? imageFile,
  }) async {
    if (!_initialized) {
      await initialize(
        expenseCategories: expenseCategories,
        incomeCategories: incomeCategories,
        accounts: accounts,
        imageFile: imageFile,
      );
    }

    // 检查是否有可用Provider
    if (_aiKit.providers.isEmpty) {
      return null;
    }

    final task = BillExtractionTask(ocrText);

    final result = await _aiKit.execute(
      task,
      context: AIExecutionContext(
        hasNetwork: await _checkNetwork(),
        allowCloudFallback: true,
        allowLocalFallback: true,
        timeout: const Duration(seconds: 30), // 增加到30秒，避免网络慢时超时
      ),
    );

    return result.success ? result.data : null;
  }

  /// 获取执行策略
  AIExecutionStrategy _getStrategy(String type) {
    switch (type) {
      case 'local_first':
        return const LocalFirstStrategy();
      case 'cloud_first':
        return const CloudFirstStrategy();
      case 'local_only':
        return const LocalOnlyStrategy();
      case 'cloud_only':
        return const CloudOnlyStrategy();
      case 'cost_optimized':
        return const CostOptimizedStrategy();
      default:
        return const LocalFirstStrategy();
    }
  }

  /// 检查网络连接
  Future<bool> _checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// 获取AI Kit实例（用于配置界面）
  FlutterAIKit get aiKit => _aiKit;

  /// 是否已初始化
  bool get isInitialized => _initialized;
}
