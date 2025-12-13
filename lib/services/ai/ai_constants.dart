/// AI 服务相关常量
class AIConstants {
  AIConstants._();

  // SharedPreferences Keys & YAML Keys (统一使用)
  static const String keyGlmApiKey = 'ai_glm_api_key';
  static const String keyGlmModel = 'ai_glm_model';
  static const String keyGlmVisionModel = 'ai_glm_vision_model';
  static const String keyAiStrategy = 'ai_strategy';
  static const String keyAiBillExtractionEnabled = 'ai_bill_extraction_enabled';
  static const String keyAiUseVision = 'ai_use_vision';
  static const String keyAiCustomPrompt = 'ai_custom_prompt';

  // 默认模型
  /// 默认文本模型
  static const String defaultGlmModel = 'glm-4-flash';

  /// 默认视觉模型
  static const String defaultGlmVisionModel = 'glm-4v-flash';

  /// 默认执行策略
  static const String defaultStrategy = 'cloud_first';
}
