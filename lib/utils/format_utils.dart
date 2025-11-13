/// 格式化工具函数
///
/// 包含各种数据格式化的工具函数
library;

import 'package:flutter/material.dart';
import 'currencies.dart';
import '../l10n/app_localizations.dart';

/// 格式化余额显示，支持多语言单位和多币种
///
/// [balance] 金额
/// [currencyCode] 币种代码 (如 'CNY', 'USD')
/// [isChineseLocale] 是否为中文环境，中文显示万单位，其他语言显示k/M单位
String formatBalance(double balance, String currencyCode,
    {bool isChineseLocale = true}) {
  final absBalance = balance.abs();
  final currencySymbol = getCurrencySymbol(currencyCode);
  final sign = balance >= 0 ? currencySymbol : '-$currencySymbol';

  if (isChineseLocale) {
    // 中文环境：使用万作为单位，小于10000显示具体数字
    if (absBalance >= 10000) {
      final wan = absBalance / 10000;
      return '$sign${wan.toStringAsFixed(1)}万';
    } else {
      return '$sign${absBalance.toStringAsFixed(2)}';
    }
  } else {
    // 其他语言环境：使用k、M作为单位
    if (absBalance >= 1000000) {
      final million = absBalance / 1000000;
      return '$sign${million.toStringAsFixed(1)}M';
    } else if (absBalance >= 1000) {
      final thousand = absBalance / 1000;
      return '$sign${thousand.toStringAsFixed(1)}k';
    } else {
      return '$sign${absBalance.toStringAsFixed(2)}';
    }
  }
}

/// 翻译账本名称
///
/// 如果账本名称是 "Default Ledger"，则返回国际化后的名称
/// 否则返回原始名称
String translateLedgerName(BuildContext context, String ledgerName) {
  final l10n = AppLocalizations.of(context);

  // 处理默认账本名称的多种形式
  if (ledgerName == 'Default Ledger' ||
      ledgerName == '默认账本' ||
      ledgerName == 'デフォルト家計簿' ||
      ledgerName == '기본 가계부' ||
      ledgerName == 'Standard-Kontenbuch' ||
      ledgerName == 'Livre par Défaut' ||
      ledgerName == 'Libro Predeterminado' ||
      ledgerName == '預設帳本') {
    return l10n.ledgersDefaultLedgerName;
  }

  return ledgerName;
}
