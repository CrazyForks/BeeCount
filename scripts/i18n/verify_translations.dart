#!/usr/bin/env dart
/// 验证中英文翻译的完整性
///
/// 使用方法：
/// dart scripts/verify_translations.dart

import 'dart:io';
import 'dart:convert';

void main() async {
  print('🔍 验证中英文翻译完整性...\n');

  // 读取中英文文件
  final zhFile = File('lib/l10n/app_zh.arb');
  final enFile = File('lib/l10n/app_en.arb');

  if (!zhFile.existsSync() || !enFile.existsSync()) {
    print('❌ 找不到源文件');
    exit(1);
  }

  final zhData = json.decode(await zhFile.readAsString()) as Map<String, dynamic>;
  final enData = json.decode(await enFile.readAsString()) as Map<String, dynamic>;

  // 获取所有非元数据的 keys
  final zhKeys = zhData.keys.where((key) => !key.startsWith('@')).toSet();
  final enKeys = enData.keys.where((key) => !key.startsWith('@')).toSet();

  print('📊 统计信息：');
  print('  简体中文 keys: ${zhKeys.length}');
  print('  英文 keys: ${enKeys.length}\n');

  // 检查中文缺失的 keys
  final zhMissing = enKeys.difference(zhKeys);
  if (zhMissing.isNotEmpty) {
    print('❌ 简体中文缺失的翻译 (${zhMissing.length})：');
    for (final key in zhMissing) {
      print('  • $key: "${enData[key]}"');
    }
    print('');
  }

  // 检查英文缺失的 keys
  final enMissing = zhKeys.difference(enKeys);
  if (enMissing.isNotEmpty) {
    print('❌ 英文缺失的翻译 (${enMissing.length})：');
    for (final key in enMissing) {
      print('  • $key: "${zhData[key]}"');
    }
    print('');
  }

  // 检查空值
  final zhEmpty = <String>[];
  final enEmpty = <String>[];

  for (final key in zhKeys) {
    final value = zhData[key]?.toString() ?? '';
    if (value.trim().isEmpty) {
      zhEmpty.add(key);
    }
  }

  for (final key in enKeys) {
    final value = enData[key]?.toString() ?? '';
    if (value.trim().isEmpty) {
      enEmpty.add(key);
    }
  }

  if (zhEmpty.isNotEmpty) {
    print('⚠️  简体中文空值翻译 (${zhEmpty.length})：');
    for (final key in zhEmpty) {
      print('  • $key');
    }
    print('');
  }

  if (enEmpty.isNotEmpty) {
    print('⚠️  英文空值翻译 (${enEmpty.length})：');
    for (final key in enEmpty) {
      print('  • $key');
    }
    print('');
  }

  // 总结
  print('=' * 60);
  if (zhMissing.isEmpty && enMissing.isEmpty && zhEmpty.isEmpty && enEmpty.isEmpty) {
    print('✅ 中英文翻译完整！');
  } else {
    print('⚠️  发现问题：');
    if (zhMissing.isNotEmpty) print('  • 简体中文缺失 ${zhMissing.length} 个翻译');
    if (enMissing.isNotEmpty) print('  • 英文缺失 ${enMissing.length} 个翻译');
    if (zhEmpty.isNotEmpty) print('  • 简体中文有 ${zhEmpty.length} 个空值');
    if (enEmpty.isNotEmpty) print('  • 英文有 ${enEmpty.length} 个空值');
    print('\n💡 建议：补全缺失的翻译后再翻译其他语言');
  }
  print('=' * 60);
}
