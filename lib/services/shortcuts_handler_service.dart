import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'automation/auto_billing_service.dart';

/// iOS快捷指令处理服务
/// 处理通过URL Scheme触发的快捷指令自动化
class ShortcutsHandlerService {
  final ProviderContainer _container;
  late final AutoBillingService _autoBillingService;
  final ImagePicker _imagePicker = ImagePicker();

  ShortcutsHandlerService(this._container) {
    _autoBillingService = AutoBillingService(_container);
  }

  /// 处理快捷指令URL
  /// 支持的URL格式:
  /// - beecount://auto-billing?text=文本内容 (推荐：直接传递文本，快捷指令需将换行替换为\n)
  /// - beecount://auto-billing (兼容：从剪贴板读取文本)
  /// - beecount://quick-billing (打开相册选择)
  Future<void> handleUrl(Uri uri) async {
    print('🔗 [Shortcuts] 收到URL: $uri');

    final action = uri.host;
    final queryParams = uri.queryParameters;

    switch (action) {
      case 'auto-billing':
        // 优先从URL参数获取文本
        String? text = queryParams['text'];

        if (text != null && text.isNotEmpty) {
          // 将转义的换行符还原为真实换行
          text = _decodeText(text);
          print('✅ [Shortcuts] 从URL参数读取文本，长度: ${text.length}');
          await _handleTextBilling(text);
        } else {
          // 兼容旧方式：从剪贴板读取
          // 延迟读取剪贴板，避免过早触发权限弹窗
          await Future.delayed(const Duration(milliseconds: 300));

          final clipboardText = await _getClipboardText();
          if (clipboardText != null && clipboardText.isNotEmpty) {
            print('✅ [Shortcuts] 从剪贴板读取文本，长度: ${clipboardText.length}');
            await _handleTextBilling(clipboardText);
          } else {
            print('⚠️ [Shortcuts] URL参数和剪贴板都为空');
          }
        }
        break;
      case 'quick-billing':
        await _handleQuickBilling();
        break;
      default:
        print('⚠️ [Shortcuts] 未知的action: $action');
    }
  }

  /// 解码文本：将逗号还原为换行符
  /// 快捷指令配置中将换行符替换为逗号以避免URL截断问题
  String _decodeText(String text) {
    // 将逗号替换为真实换行符
    return text.replaceAll(',', '\n');
  }

  /// 从剪贴板读取文本
  Future<String?> _getClipboardText() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      return clipboardData?.text;
    } catch (e) {
      print('❌ [Shortcuts] 读取剪贴板失败: $e');
      return null;
    }
  }

  /// 文本记账：直接处理快捷指令传递的文本(推荐方式)
  Future<void> _handleTextBilling(String text) async {
    print('📝 [Shortcuts] 开始处理文本记账');
    print('📝 [Shortcuts] 接收到的文本: $text');

    try {
      // 直接处理文本,无需OCR
      await _autoBillingService.processText(
        text,
        showNotification: true,
      );
    } catch (e) {
      print('❌ [Shortcuts] 文本记账失败: $e');
    }
  }

  /// 快速记账：打开相册选择截图
  Future<void> _handleQuickBilling() async {
    print('📸 [Shortcuts] 开始快速记账流程');

    try {
      // 从相册选择图片
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        print('⚠️ [Shortcuts] 用户取消选择');
        return;
      }

      print('📸 [Shortcuts] 用户选择了图片: ${pickedFile.path}');

      // 处理选中的图片
      await _autoBillingService.processScreenshot(
        pickedFile.path,
        showNotification: true,
      );
    } catch (e) {
      print('❌ [Shortcuts] 快速记账失败: $e');
    }
  }

  /// 释放资源
  void dispose() {
    _autoBillingService.dispose();
  }
}
