import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class CurrencyInfo {
  final String code;
  final String name;
  const CurrencyInfo(this.code, this.name);
}

const List<String> kCurrencyCodes = [
  'CNY',
  'USD',
  'EUR',
  'JPY',
  'HKD',
  'TWD',
  'GBP',
  'AUD',
  'CAD',
  'KRW',
  'SGD',
  'MYR',
  'THB',
  'IDR',
  'PHP',
  'VND',
  'INR',
  'RUB',
  'BYN',
  'NZD',
  'CHF',
  'SEK',
  'NOK',
  'DKK',
  'BRL',
  'MXN',
];

/// 获取本地化的货币信息列表
List<CurrencyInfo> getCurrencies(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return [
    CurrencyInfo('CNY', l10n.currencyCNY),
    CurrencyInfo('USD', l10n.currencyUSD),
    CurrencyInfo('EUR', l10n.currencyEUR),
    CurrencyInfo('JPY', l10n.currencyJPY),
    CurrencyInfo('HKD', l10n.currencyHKD),
    CurrencyInfo('TWD', l10n.currencyTWD),
    CurrencyInfo('GBP', l10n.currencyGBP),
    CurrencyInfo('AUD', l10n.currencyAUD),
    CurrencyInfo('CAD', l10n.currencyCAD),
    CurrencyInfo('KRW', l10n.currencyKRW),
    CurrencyInfo('SGD', l10n.currencySGD),
    CurrencyInfo('MYR', l10n.currencyMYR),
    CurrencyInfo('THB', l10n.currencyTHB),
    CurrencyInfo('IDR', l10n.currencyIDR),
    CurrencyInfo('PHP', l10n.currencyPHP),
    CurrencyInfo('VND', l10n.currencyVND),
    CurrencyInfo('INR', l10n.currencyINR),
    CurrencyInfo('RUB', l10n.currencyRUB),
    CurrencyInfo('BYN', l10n.currencyBYN),
    CurrencyInfo('NZD', l10n.currencyNZD),
    CurrencyInfo('CHF', l10n.currencyCHF),
    CurrencyInfo('SEK', l10n.currencySEK),
    CurrencyInfo('NOK', l10n.currencyNOK),
    CurrencyInfo('DKK', l10n.currencyDKK),
    CurrencyInfo('BRL', l10n.currencyBRL),
    CurrencyInfo('MXN', l10n.currencyMXN),
  ];
}

String displayCurrency(String code, BuildContext context) {
  final currencies = getCurrencies(context);
  final m = currencies.where((c) => c.code == code).toList();
  if (m.isEmpty) return code;
  return '${m.first.name} (${m.first.code})';
}

/// 获取指定货币代码的本地化名称
String getCurrencyName(String code, BuildContext context) {
  final currencies = getCurrencies(context);
  final m = currencies.where((c) => c.code == code).toList();
  if (m.isEmpty) return code;
  return m.first.name;
}

/// 获取币种符号
String getCurrencySymbol(String code) {
  switch (code) {
    case 'CNY':
      return '¥';
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';
    case 'JPY':
      return '¥';
    case 'HKD':
      return 'HK\$';
    case 'TWD':
      return 'NT\$';
    case 'GBP':
      return '£';
    case 'AUD':
      return 'A\$';
    case 'CAD':
      return 'C\$';
    case 'KRW':
      return '₩';
    case 'SGD':
      return 'S\$';
    case 'MYR':
      return 'RM';
    case 'THB':
      return '฿';
    case 'IDR':
      return 'Rp';
    case 'PHP':
      return '₱';
    case 'VND':
      return '₫';
    case 'INR':
      return '₹';
    case 'RUB':
      return '₽';
    case 'BYN':
      return 'Br';
    case 'NZD':
      return 'NZ\$';
    case 'CHF':
      return 'CHF';
    case 'SEK':
      return 'kr';
    case 'NOK':
      return 'kr';
    case 'DKK':
      return 'kr';
    case 'BRL':
      return 'R\$';
    case 'MXN':
      return 'MX\$';
    default:
      return code;
  }
}
