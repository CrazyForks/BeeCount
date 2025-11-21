import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../widget/widget_manager.dart';
import '../providers.dart';

// 主题模式Provider（默认跟随系统）
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// 主题模式持久化初始化
final themeModeInitProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('themeMode');
  if (saved != null) {
    switch (saved) {
      case 'light':
        ref.read(themeModeProvider.notifier).state = ThemeMode.light;
        break;
      case 'dark':
        ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
        break;
      default:
        ref.read(themeModeProvider.notifier).state = ThemeMode.system;
    }
  }
  ref.listen<ThemeMode>(themeModeProvider, (prev, next) async {
    String value;
    switch (next) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      default:
        value = 'system';
    }
    await prefs.setString('themeMode', value);
  });
});

// 暗黑模式下头部图案样式Provider
// 可选值：'none'（无图案）、'icons'（图标平铺）、'particles'（粒子星星）、'honeycomb'（蜂巢六边形）
final darkModePatternStyleProvider = StateProvider<String>((ref) => 'icons');

// 暗黑模式图案样式持久化初始化
final darkModePatternStyleInitProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('darkModePatternStyle');
  if (saved != null) {
    ref.read(darkModePatternStyleProvider.notifier).state = saved;
  }
  ref.listen<String>(darkModePatternStyleProvider, (prev, next) async {
    await prefs.setString('darkModePatternStyle', next);
  });
});

// 可变主色（个性化换装使用）
final primaryColorProvider = StateProvider<Color>((ref) => BeeTheme.honeyGold);

// 是否隐藏金额显示
final hideAmountsProvider = StateProvider<bool>((ref) => false);

// 字体选择Provider - 已移除，仅使用系统默认字体

// 主题色持久化初始化：
// - 启动时加载保存的主色
// - 监听主色变化并写入本地
final primaryColorInitProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getInt('primaryColor');
  if (saved != null) {
    ref.read(primaryColorProvider.notifier).state = Color(saved);
  }
  ref.listen<Color>(primaryColorProvider, (prev, next) async {
    final colorValue = (next.a * 255).toInt() << 24 | (next.r * 255).toInt() << 16 | (next.g * 255).toInt() << 8 | (next.b * 255).toInt();
    await prefs.setInt('primaryColor', colorValue);
    // Update widget with new theme color
    try {
      final repository = ref.read(repositoryProvider);
      final currentLedgerId = ref.read(currentLedgerIdProvider);
      final widgetManager = WidgetManager();
      await widgetManager.updateWidget(repository, currentLedgerId, next);
    } catch (e) {
      // Silently fail
    }
  });
});

// 隐私模式持久化初始化：
// - 启动时加载保存的隐私模式状态
// - 监听隐私模式变化并写入本地
final hideAmountsInitProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getBool('hideAmounts');
  if (saved != null) {
    ref.read(hideAmountsProvider.notifier).state = saved;
  }
  ref.listen<bool>(hideAmountsProvider, (prev, next) async {
    await prefs.setBool('hideAmounts', next);
  });
});

// 字体持久化初始化 - 已移除，仅使用系统默认字体

// Header装饰样式Provider
// 可选值：'icons'（图标平铺）、'particles'（粒子星星）、'honeycomb'（蜂巢六边形）
final headerDecorationStyleProvider = StateProvider<String>((ref) => 'icons');

// 金额显示格式Provider（默认显示完整金额）
// false = 完整金额（如 123,456.78）
// true = 简洁显示（如 12.3万）
final compactAmountProvider = StateProvider<bool>((ref) => false);

// 金额显示格式持久化初始化
final compactAmountInitProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getBool('compactAmount');
  if (saved != null) {
    ref.read(compactAmountProvider.notifier).state = saved;
  }
  ref.listen<bool>(compactAmountProvider, (prev, next) async {
    await prefs.setBool('compactAmount', next);
  });
});

// Header装饰样式持久化初始化
final headerDecorationStyleInitProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('headerDecorationStyle');
  if (saved != null) {
    ref.read(headerDecorationStyleProvider.notifier).state = saved;
  }
  ref.listen<String>(headerDecorationStyleProvider, (prev, next) async {
    await prefs.setString('headerDecorationStyle', next);
  });
});