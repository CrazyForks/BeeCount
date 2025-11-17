import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_ai_kit/flutter_ai_kit.dart';

/// 智谱GLM Provider
///
/// 支持智谱AI的GLM系列模型
///
/// 示例:
/// ```dart
/// final provider = ZhipuGLMProvider(
///   apiKey: 'your_api_key',
///   model: 'glm-4-flash', // 默认使用免费的glm-4-flash
/// );
/// ```
class ZhipuGLMProvider implements AIProvider<String, String> {
  @override
  String get id => 'zhipu_glm_$model';

  @override
  String get name => '智谱GLM-${model.toUpperCase()}';

  @override
  AIProviderType get type => AIProviderType.cloud;

  @override
  bool get requiresNetwork => true;

  /// API密钥
  final String apiKey;

  /// 模型名称（默认: glm-4-flash 免费）
  final String model;

  /// 温度参数（0.0 - 1.0，越低越确定性）
  final double temperature;

  /// 图片文件（可选，用于GLM-4V视觉模型）
  final File? imageFile;

  final Dio _dio = Dio();

  ZhipuGLMProvider({
    required this.apiKey,
    this.model = 'glm-4-flash',
    this.temperature = 0.1,
    this.imageFile,
  });

  @override
  bool supportsTask(String taskType) {
    // 支持通用文本处理任务
    return [
      'text_extraction',
      'chat',
      'summarization',
      'translation',
    ].contains(taskType);
  }

  @override
  Future<bool> isReady() async => apiKey.isNotEmpty;

  @override
  Future<AIResult<String>> execute(AITask<String, String> task) async {
    final startTime = DateTime.now();

    try {
      // 准备消息内容
      final messageContent = await _prepareMessageContent(task.input);

      final response = await _dio.post(
        'https://open.bigmodel.cn/api/paas/v4/chat/completions',
        options: Options(headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        }),
        data: {
          'model': model,
          'messages': [
            {'role': 'user', 'content': messageContent}
          ],
          'temperature': temperature,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      final tokens = response.data['usage']['total_tokens'];

      return AIResult.success(
        content,
        DateTime.now().difference(startTime),
        metadata: AIResultMetadata(
          providerName: name,
          modelName: model,
          tokensUsed: tokens,
        ),
      );
    } on DioException catch (e) {
      return AIResult.failure(
        _parseDioError(e),
        DateTime.now().difference(startTime),
        metadata: AIResultMetadata(providerName: name),
      );
    } catch (e) {
      return AIResult.failure(
        e.toString(),
        DateTime.now().difference(startTime),
        metadata: AIResultMetadata(providerName: name),
      );
    }
  }

  @override
  Future<double> estimateCost(AITask<String, String> task) async {
    // GLM-4-Flash 完全免费
    if (model == 'glm-4-flash') return 0.0;

    // 其他模型按字符数粗略估算
    final charCount = task.input.length;
    final estimatedTokens = charCount ~/ 2; // 粗略估算

    // 价格（示例，实际需查看官方文档）
    switch (model) {
      case 'glm-4':
        return estimatedTokens * 0.00001; // $0.01/1k tokens
      case 'glm-3-turbo':
        return estimatedTokens * 0.000005; // $0.005/1k tokens
      default:
        return 0.0;
    }
  }

  /// 准备消息内容（支持图片上传）
  Future<dynamic> _prepareMessageContent(String text) async {
    // 如果没有图片，直接返回文本
    if (imageFile == null) {
      return text;
    }

    // 如果有图片，准备multimodal content（用于GLM-4V）
    try {
      // 读取图片并转换为base64
      final imageBytes = await imageFile!.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // 返回包含文本和图片的多模态内容
      return [
        {
          'type': 'image_url',
          'image_url': {
            'url': base64Image,
          }
        },
        {
          'type': 'text',
          'text': text,
        }
      ];
    } catch (e) {
      print('⚠️ [GLM] 图片编码失败: $e，降级使用纯文本');
      return text;
    }
  }

  String _parseDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timeout';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['error']?['message'];
        return 'API error ($statusCode): ${message ?? "Unknown error"}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error: ${e.message}';
      default:
        return 'Network error: ${e.message}';
    }
  }
}
