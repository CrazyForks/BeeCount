import 'dart:io';
import 'package:flutter_ai_kit/flutter_ai_kit.dart';
import 'package:flutter_ai_kit_zhipu/flutter_ai_kit_zhipu.dart';

/// 通用的语音转文字Provider
///
/// 使用GLM-4-Voice模型将语音转换为文字（ASR）
class SpeechToTextGLMProvider implements AIProvider<File, String> {
  final String apiKey;
  final String model;

  SpeechToTextGLMProvider({
    required this.apiKey,
    this.model = 'glm-4-voice',
  });

  @override
  String get id => 'speech_to_text_glm';

  @override
  String get name => '智谱GLM-语音转文字';

  @override
  AIProviderType get type => AIProviderType.cloud;

  @override
  bool get requiresNetwork => true;

  @override
  bool supportsTask(String taskType) => taskType == 'speech_to_text';

  @override
  Future<bool> isReady() async => apiKey.isNotEmpty;

  @override
  Future<AIResult<String>> execute(AITask<File, String> task) async {
    final startTime = DateTime.now();

    try {
      final audioFile = task.input;

      // 使用GLM-4-Voice做ASR
      final glmProvider = ZhipuGLMProvider(
        apiKey: apiKey,
        model: model,
        audioFile: audioFile,
      );

      final asrTask = _TextTask('请将语音内容转换为文字，只返回识别的文字内容，不要添加任何解释或标点修饰。');
      final result = await glmProvider.execute(asrTask);

      if (!result.success) {
        return AIResult.failure(
          result.error!,
          DateTime.now().difference(startTime),
        );
      }

      // 清理返回的文本（去除可能的前后缀）
      final recognizedText = result.data!.trim();

      return AIResult.success(
        recognizedText,
        DateTime.now().difference(startTime),
      );
    } catch (e) {
      return AIResult.failure(
        '语音识别失败: $e',
        DateTime.now().difference(startTime),
      );
    }
  }

  @override
  Future<double> estimateCost(AITask<File, String> task) async {
    // GLM-4-Voice API 成本估算
    return 0.01; // 约1分钱
  }
}

/// 语音转文字任务
class SpeechToTextTask extends AITask<File, String> {
  @override
  String get taskType => 'speech_to_text';

  @override
  final File input;

  SpeechToTextTask(this.input);

  @override
  Map<String, dynamic> toJson() => {'audioPath': input.path};
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
