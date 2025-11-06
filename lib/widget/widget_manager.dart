import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import '../data/repository.dart';
import 'home_widget_view.dart';

class WidgetManager {
  static final WidgetManager _instance = WidgetManager._internal();
  factory WidgetManager() => _instance;
  WidgetManager._internal();

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'zh_CN',
    symbol: '¥',
    decimalDigits: 2,
  );

  /// Update widget with latest transaction data for a specific ledger
  Future<void> updateWidget(
    BeeRepository repository,
    int ledgerId,
    Color themeColor, {
    String appName = '蜜蜂记账',
    String monthSuffix = '月',
    String todayExpenseLabel = '今日支出',
    String todayIncomeLabel = '今日收入',
    String monthExpenseLabel = '本月支出',
    String monthIncomeLabel = '本月收入',
  }) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = DateTime(now.year, now.month + 1, 1);

      // Get today's totals
      final todayExpenseCategories = await repository.totalsByCategory(
        ledgerId: ledgerId,
        type: 'expense',
        start: today,
        end: tomorrow,
      );
      final todayIncomeCategories = await repository.totalsByCategory(
        ledgerId: ledgerId,
        type: 'income',
        start: today,
        end: tomorrow,
      );

      // Get this month's totals
      final monthExpenseCategories = await repository.totalsByCategory(
        ledgerId: ledgerId,
        type: 'expense',
        start: monthStart,
        end: monthEnd,
      );
      final monthIncomeCategories = await repository.totalsByCategory(
        ledgerId: ledgerId,
        type: 'income',
        start: monthStart,
        end: monthEnd,
      );

      // Calculate totals
      final todayExpenseTotal = todayExpenseCategories.fold<double>(
        0.0,
        (sum, item) => sum + item.total,
      );
      final todayIncomeTotal = todayIncomeCategories.fold<double>(
        0.0,
        (sum, item) => sum + item.total,
      );
      final monthExpenseTotal = monthExpenseCategories.fold<double>(
        0.0,
        (sum, item) => sum + item.total,
      );
      final monthIncomeTotal = monthIncomeCategories.fold<double>(
        0.0,
        (sum, item) => sum + item.total,
      );

      // Render Flutter widget as image for home screen widget
      // iOS uses 364x169 (2.15:1), Android needs 2:1 ratio
      // For Android, we'll render at 364x169 then add padding to make it 364x182 (2:1)
      final widgetSize = Platform.isIOS
          ? const Size(364, 169)  // iOS systemMedium
          : const Size(364, 182); // Android 2:1 ratio (364/2=182)

      print('📱 Widget rendering - Platform: ${Platform.isIOS ? "iOS" : "Android"}, Size: ${widgetSize.width}x${widgetSize.height}, Ratio: ${(widgetSize.width / widgetSize.height).toStringAsFixed(2)}:1');

      print('🎨 开始渲染小组件...');
      await HomeWidget.renderFlutterWidget(
        HomeWidgetView(
          todayExpense: _currencyFormat.format(todayExpenseTotal),
          todayIncome: _currencyFormat.format(todayIncomeTotal),
          monthExpense: _currencyFormat.format(monthExpenseTotal),
          monthIncome: _currencyFormat.format(monthIncomeTotal),
          themeColor: themeColor,
          appName: appName,
          monthSuffix: monthSuffix,
          todayExpenseLabel: todayExpenseLabel,
          todayIncomeLabel: todayIncomeLabel,
          monthExpenseLabel: monthExpenseLabel,
          monthIncomeLabel: monthIncomeLabel,
          width: widgetSize.width,
          height: widgetSize.height,
        ),
        key: 'widgetImage',
        logicalSize: widgetSize,
        pixelRatio: 4.0, // @4x for high resolution
      );
      print('✅ 小组件渲染完成');

      // 获取保存的图片路径用于调试
      final savedPath = await HomeWidget.getWidgetData<String>('widgetImage');
      print('📁 图片保存路径: $savedPath');

      // Update the widget
      print('📲 触发小组件更新...');
      await HomeWidget.updateWidget(
        qualifiedAndroidName: 'com.example.beecount.BeeCountWidgetProvider',
        iOSName: 'BeeCountWidget',
      );
      print('✅ 小组件更新命令已发送');
    } catch (e) {
      print('[Widget] 更新失败: $e');
    }
  }

  /// Register widget update callback
  static Future<void> registerCallback() async {
    try {
      await HomeWidget.registerInteractivityCallback(
        _backgroundCallback,
      );
    } catch (e) {
      // Silently fail
      return;
    }
  }

  /// Background callback for widget interactions
  @pragma('vm:entry-point')
  static Future<void> _backgroundCallback(Uri? uri) async {
    // Handle widget tap events
    // Could be used to navigate to specific pages
  }
}
