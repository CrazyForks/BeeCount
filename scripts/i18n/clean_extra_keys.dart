#!/usr/bin/env dart
// 清理各语言文件中多余的翻译键
// 用法: dart scripts/i18n/clean_extra_keys.dart

import 'dart:io';
import 'dart:convert';

void main() async {
  print('🧹 开始清理多余的翻译键...\n');

  final l10nDir = Directory('lib/l10n');

  // 读取中文文件作为基准
  final zhFile = File('${l10nDir.path}/app_zh.arb');
  if (!zhFile.existsSync()) {
    print('❌ 找不到 app_zh.arb 文件');
    exit(1);
  }

  final zhContent = await zhFile.readAsString();
  final zhData = json.decode(zhContent) as Map<String, dynamic>;
  final zhKeys = zhData.keys.where((key) => !key.startsWith('@')).toSet();

  print('📊 基准文件 (app_zh.arb): ${zhKeys.length} 个键\n');

  // 支持的语言列表 (排除中文)
  final languages = ['en', 'ja', 'ko', 'zh_TW', 'es', 'fr', 'de'];

  // 收集每个语言的多余键
  final Map<String, Set<String>> extraKeysMap = {};

  for (final lang in languages) {
    final file = File('${l10nDir.path}/app_$lang.arb');
    if (!file.existsSync()) {
      print('⚠️  跳过不存在的文件: app_$lang.arb');
      continue;
    }

    final content = await file.readAsString();
    final data = json.decode(content) as Map<String, dynamic>;
    final keys = data.keys.where((key) => !key.startsWith('@')).toSet();

    // 找出多余的键
    final extraKeys = keys.difference(zhKeys);

    if (extraKeys.isNotEmpty) {
      extraKeysMap[lang] = extraKeys;
    }
  }

  if (extraKeysMap.isEmpty) {
    print('✅ 没有发现多余的键！');
    return;
  }

  // 显示所有多余的键
  print('═══════════════════════════════════════════════════════════════');
  print('📋 发现以下语言有多余的键：\n');

  for (final entry in extraKeysMap.entries) {
    final lang = entry.key;
    final keys = entry.value;

    print('🔴 $lang (app_$lang.arb): ${keys.length} 个多余的键');
    print('─'.padRight(60, '─'));

    // 按字母排序显示
    final sortedKeys = keys.toList()..sort();
    for (var i = 0; i < sortedKeys.length; i++) {
      print('  ${(i + 1).toString().padLeft(3)}. ${sortedKeys[i]}');
    }
    print('');
  }

  print('═══════════════════════════════════════════════════════════════');
  print('\n⚠️  警告：此操作将删除上述所有多余的键！');
  print('💡 建议：先检查这些键是否确实不需要\n');
  print('确认要删除这些键吗？(y/N): ');

  final confirm = stdin.readLineSync()?.toLowerCase();

  if (confirm != 'y' && confirm != 'yes') {
    print('❌ 已取消清理操作');
    return;
  }

  // 执行清理
  print('\n🔄 开始清理...\n');

  int totalDeleted = 0;

  for (final entry in extraKeysMap.entries) {
    final lang = entry.key;
    final extraKeys = entry.value;
    final file = File('${l10nDir.path}/app_$lang.arb');

    final content = await file.readAsString();
    final data = json.decode(content) as Map<String, dynamic>;

    // 删除多余的键及其元数据
    for (final key in extraKeys) {
      data.remove(key);
      data.remove('@$key');
      totalDeleted++;
    }

    // 写回文件
    final encoder = JsonEncoder.withIndent('  ');
    final formatted = encoder.convert(data);
    await file.writeAsString('$formatted\n');

    print('  ✅ app_$lang.arb: 删除 ${extraKeys.length} 个键');
  }

  print('\n═══════════════════════════════════════════════════════════════');
  print('✅ 清理完成！');
  print('📊 统计：');
  print('  • 处理文件数: ${extraKeysMap.length}');
  print('  • 删除键总数: $totalDeleted');
  print('\n💡 建议：');
  print('  1. 运行 dart scripts/i18n/check_status.dart 检查状态');
  print('  2. 运行 flutter gen-l10n 重新生成本地化代码');
  print('═══════════════════════════════════════════════════════════════\n');
}
