import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'widget_data.dart';
import 'widget_provider.dart';
import '../providers.dart';

class WidgetService {
  static const String widgetDataKey = 'widget_data';
  static const String appGroupId = 'group.com.example.beecount';

  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(appGroupId);
    } catch (e) {
      // 在模拟器上可能会失败，但不应该阻止应用启动
      // print('Widget initialization failed (this is normal on emulator): $e');
    }
  }

  static Future<void> updateWidget(dynamic ref) async {
    try {
      final widgetData = await ref.read(widgetDataProvider.future);

      // 将数据编码为JSON字符串
      final jsonData = jsonEncode(widgetData.toJson());

      // 保存到共享存储
      await HomeWidget.saveWidgetData(widgetDataKey, jsonData);

      // 更新小组件 - 添加错误处理，在模拟器上可能会失败
      try {
        // 更新中等尺寸小组件
        await HomeWidget.updateWidget(
          name: 'BeeCountWidget',
          androidName: 'BeeCountWidgetProvider',
          iOSName: 'BeeCountWidget',
        );

        // 更新小尺寸小组件
        await HomeWidget.updateWidget(
          name: 'BeeCountWidgetSmall',
          androidName: 'BeeCountWidgetSmallProvider',
          iOSName: 'BeeCountWidget',
        );

        // 更新大尺寸小组件
        await HomeWidget.updateWidget(
          name: 'BeeCountWidgetLarge',
          androidName: 'BeeCountWidgetLargeProvider',
          iOSName: 'BeeCountWidget',
        );
      } catch (widgetError) {
        // 在模拟器上小组件更新可能会失败，但不应该阻止应用运行
        // print('Widget update failed (this is normal on emulator): $widgetError');
      }

      // 调试输出
      // print('Widget updated successfully');
    } catch (e) {
      // print('Failed to update widget: $e');
      // 不再重新抛出错误，避免崩溃
      // rethrow;
    }
  }

  // 强制刷新小组件外观（用于主题/语言变化后）
  static Future<void> forceRefreshWidgets() async {
    try {
      // 重新启动所有小组件
      await HomeWidget.updateWidget(
        name: 'BeeCountWidget',
        androidName: 'BeeCountWidgetProvider',
        iOSName: 'BeeCountWidget',
      );

      await HomeWidget.updateWidget(
        name: 'BeeCountWidgetSmall',
        androidName: 'BeeCountWidgetSmallProvider',
        iOSName: 'BeeCountWidget',
      );

      await HomeWidget.updateWidget(
        name: 'BeeCountWidgetLarge',
        androidName: 'BeeCountWidgetLargeProvider',
        iOSName: 'BeeCountWidget',
      );
    } catch (e) {
      // 错误处理
    }
  }

  static Future<void> handleWidgetClick(String action) async {
    switch (action) {
      case 'add_transaction':
        // 处理添加交易的点击
        // print('Widget clicked: add transaction');
        break;
      case 'open_app':
        // 处理打开应用的点击
        // print('Widget clicked: open app');
        break;
      default:
        // print('Unknown widget action: $action');
        break;
    }
  }

  static Future<void> registerInteractivity() async {
    HomeWidget.widgetClicked.listen((Uri? uri) {
      final action = uri?.queryParameters['action'] ?? 'open_app';
      handleWidgetClick(action);
    });
  }
}

// 简化的小组件更新监听器 - 暂时禁用以避免在开发环境中的错误
final widgetDataWatcherProvider = Provider<void>((ref) {
  // 监听账本变化 - 暂时注释掉
  // ref.listen(currentLedgerProvider, (previous, next) {
  //   if (next.hasValue && next.value != null) {
  //     WidgetService.updateWidget(ref);
  //   }
  // });

  // 监听小组件数据变化 - 暂时注释掉
  // ref.listen(widgetDataProvider, (previous, next) {
  //   if (next.hasValue) {
  //     WidgetService.updateWidget(ref);
  //   }
  // });

  return;
});