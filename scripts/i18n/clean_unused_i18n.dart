#!/usr/bin/env dart
/// 清理未使用的 i18n keys
///
/// 使用方法：
/// dart scripts/clean_unused_i18n.dart

import 'dart:io';
import 'dart:convert';

void main() async {
  print('🧹 开始清理未使用的 i18n keys...\n');

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

  for (final key in allKeys) {
    bool isUsed = false;

    for (final file in dartFiles) {
      final content = await file.readAsString();

      // 检查各种可能的使用方式
      // 1. 基本使用模式
      if (content.contains('l10n.$key') ||
          content.contains('l10n!.$key')) {
        isUsed = true;
        break;
      }

      // 2. AppLocalizations 使用模式
      if (content.contains('AppLocalizations.of(') &&
          content.contains(').$key')) {
        isUsed = true;
        break;
      }

      // 3. 使用正则表达式匹配更复杂的模式
      // 匹配: .keyName (考虑任何变量名、可选的!或?)
      final pattern = RegExp(r'[.\s]\??!?' + key + r'\b');

      if (pattern.hasMatch(content)) {
        isUsed = true;
        break;
      }
    }

    if (!isUsed) {
      unusedKeys.add(key);
    }
  }

  if (unusedKeys.isEmpty) {
    print('✅ 没有发现未使用的 keys，无需清理！');
    return;
  }

  print('❌ 发现 ${unusedKeys.length} 个未使用的 keys\n');
  print('📝 即将删除的 keys：');
  for (final key in unusedKeys) {
    print('  • $key');
  }

  print('\n⚠️  确认要删除这些 keys 吗？(y/N): ');
  final confirm = stdin.readLineSync()?.toLowerCase();

  if (confirm != 'y' && confirm != 'yes') {
    print('❌ 已取消清理操作');
    return;
  }

  // 获取所有语言的 arb 文件
  final l10nDir = Directory('lib/l10n');
  final arbFiles = await l10nDir
      .list()
      .where((entity) => entity is File && entity.path.endsWith('.arb'))
      .cast<File>()
      .toList();

  print('\n🔄 清理所有语言文件...\n');

  for (final file in arbFiles) {
    final fileName = file.path.split('/').last;
    final content = await file.readAsString();
    final data = json.decode(content) as Map<String, dynamic>;

    // 删除未使用的 keys 及其元数据
    for (final key in unusedKeys) {
      data.remove(key);
      data.remove('@$key'); // 删除元数据
    }

    // 写回文件（格式化 JSON）
    final encoder = JsonEncoder.withIndent('  ');
    final formatted = encoder.convert(data);
    await file.writeAsString('$formatted\n');

    print('  ✓ $fileName');
  }

  print('\n✅ 清理完成！共删除 ${unusedKeys.length} 个未使用的 keys');
  print('💡 请运行 flutter gen-l10n 重新生成本地化代码');
}
