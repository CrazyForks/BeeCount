#!/usr/bin/env dart
/// 检测未使用的 i18n keys
///
/// 使用方法：
/// dart scripts/check_unused_i18n.dart

import 'dart:io';
import 'dart:convert';

void main() async {
  print('🔍 开始检测未使用的 i18n keys...\n');

  // 读取中文 arb 文件获取所有 keys
  final arbFile = File('lib/l10n/app_zh.arb');
  if (!arbFile.existsSync()) {
    print('❌ 找不到 lib/l10n/app_zh.arb 文件');
    exit(1);
  }

  final arbContent = await arbFile.readAsString();
  final arbData = json.decode(arbContent) as Map<String, dynamic>;

  // 获取所有非元数据的 keys
  final allKeys = arbData.keys
      .where((key) => !key.startsWith('@'))
      .toList();

  print('📊 总共有 ${allKeys.length} 个翻译 keys\n');

  // 搜索 Dart 文件中的使用情况
  final libDir = Directory('lib');
  final dartFiles = <File>[];

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      dartFiles.add(entity);
    }
  }

  print('📁 扫描 ${dartFiles.length} 个 Dart 文件...\n');

  final unusedKeys = <String>[];
  final usedKeys = <String>{};

  for (final key in allKeys) {
    bool isUsed = false;

    for (final file in dartFiles) {
      final content = await file.readAsString();

      // 检查各种可能的使用方式
      // 1. 基本使用模式
      if (content.contains('l10n.$key') ||
          content.contains('l10n!.$key')) {
        isUsed = true;
        usedKeys.add(key);
        break;
      }

      // 2. AppLocalizations 使用模式
      if (content.contains('AppLocalizations.of(') &&
          content.contains(').$key')) {
        isUsed = true;
        usedKeys.add(key);
        break;
      }

      // 3. 使用正则表达式匹配更复杂的模式
      // 匹配: .keyName (考虑任何变量名、可选的!或?)
      final pattern = RegExp(r'[.\s]\??!?' + key + r'\b');

      if (pattern.hasMatch(content)) {
        isUsed = true;
        usedKeys.add(key);
        break;
      }
    }

    if (!isUsed) {
      unusedKeys.add(key);
    }
  }

  // 输出结果
  print('✅ 使用中的 keys: ${usedKeys.length}');
  print('❌ 未使用的 keys: ${unusedKeys.length}\n');

  if (unusedKeys.isNotEmpty) {
    print('📝 未使用的 keys 列表：');
    print('=' * 60);
    for (final key in unusedKeys) {
      final value = arbData[key];
      print('  • $key: "$value"');
    }
    print('=' * 60);
    print('\n💡 提示：运行 dart scripts/clean_unused_i18n.dart 可以自动清理这些未使用的 keys');
  } else {
    print('🎉 太好了！没有发现未使用的 keys！');
  }
}
