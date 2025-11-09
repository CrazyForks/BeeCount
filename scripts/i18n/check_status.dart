#!/usr/bin/env dart
// 检查各语言翻译文件的状态和完成度
import 'dart:io';
import 'dart:convert';

void main() {
  final l10nDir = Directory('lib/l10n');

  // 支持的语言列表
  final languages = ['zh', 'en', 'ja', 'ko', 'zh_TW', 'es', 'fr', 'de'];

  print('');
  print('=' * 70);
  print('  BeeCount 国际化翻译状态检查');
  print('=' * 70);
  print('');

  // 存储每个语言的键数量
  final Map<String, int> keyCount = {};
  final Map<String, Set<String>> allKeys = {};

  // 读取所有语言文件
  for (final lang in languages) {
    final file = File('${l10nDir.path}/app_$lang.arb');

    if (!file.existsSync()) {
      print('⚠️  文件不存在: app_$lang.arb');
      keyCount[lang] = 0;
      allKeys[lang] = {};
      continue;
    }

    try {
      final content = file.readAsStringSync();
      final Map<String, dynamic> data = json.decode(content);

      // 过滤掉元数据键（以@开头的键）
      final keys = data.keys.where((key) => !key.startsWith('@')).toSet();

      keyCount[lang] = keys.length;
      allKeys[lang] = keys;
    } catch (e) {
      print('❌ 解析失败: app_$lang.arb - $e');
      keyCount[lang] = 0;
      allKeys[lang] = {};
    }
  }

  // 以中文为基准
  final zhKeys = allKeys['zh'] ?? {};
  final zhCount = zhKeys.length;

  // 打印统计表格
  print('语言代码 | 文件名称        | 键数量   | 完成度   | 状态');
  print('-' * 70);

  final languageNames = {
    'zh': '简体中文',
    'en': 'English',
    'ja': '日本語',
    'ko': '한국어',
    'zh_TW': '繁體中文',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
  };

  for (final lang in languages) {
    final count = keyCount[lang] ?? 0;
    final name = languageNames[lang] ?? lang;
    final percentage = zhCount > 0 ? (count / zhCount * 100).toStringAsFixed(1) : '0.0';

    String status;
    if (count == 0) {
      status = '❌ 缺失';
    } else if (count >= zhCount) {
      status = '✅ 完整';
    } else if (count >= zhCount * 0.9) {
      status = '⚠️  接近完成';
    } else {
      status = '🔴 不完整';
    }

    final langCode = lang.padRight(8);
    final fileName = 'app_$lang.arb'.padRight(15);
    final countStr = count.toString().padLeft(7);
    final percentStr = '$percentage%'.padLeft(8);

    print('$langCode | $fileName | $countStr | $percentStr | $status');
  }

  print('-' * 70);
  print('');

  // 详细差异分析
  print('📊 详细分析:');
  print('');

  for (final lang in languages) {
    if (lang == 'zh') continue; // 跳过基准语言

    final langKeys = allKeys[lang] ?? {};
    final missing = zhKeys.difference(langKeys);
    final extra = langKeys.difference(zhKeys);

    if (missing.isEmpty && extra.isEmpty) {
      print('✅ $lang (${languageNames[lang]}): 完全匹配中文版本');
    } else {
      if (missing.isNotEmpty) {
        print('🔴 $lang (${languageNames[lang]}): 缺少 ${missing.length} 个键');
        if (missing.length <= 10) {
          for (final key in missing.take(10)) {
            print('   - $key');
          }
        }
      }
      if (extra.isNotEmpty) {
        print('⚠️  $lang (${languageNames[lang]}): 多出 ${extra.length} 个键 (可能来自英文版本)');
        if (extra.length <= 5) {
          for (final key in extra.take(5)) {
            print('   - $key');
          }
        }
      }
    }
    print('');
  }

  // 总结
  print('=' * 70);
  print('📈 总结:');
  print('');
  print('  基准语言: 简体中文 (zh) - $zhCount 个键');

  final complete = languages.where((l) =>
    (keyCount[l] ?? 0) >= zhCount
  ).length;
  final incomplete = languages.length - complete;

  print('  完整翻译: $complete/${languages.length} 个语言');
  print('  待完善: $incomplete 个语言');
  print('');
  print('=' * 70);
  print('');
}
