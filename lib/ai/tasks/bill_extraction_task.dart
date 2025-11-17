import 'package:flutter_ai_kit/flutter_ai_kit.dart';

/// 账单提取任务
///
/// 从OCR文本中提取账单信息
class BillExtractionTask extends AITask<String, BillInfo> {
  @override
  String get taskType => 'bill_extraction';

  @override
  final String input;

  BillExtractionTask(this.input);

  @override
  Map<String, dynamic> toJson() => {
        'task_type': taskType,
        'ocr_text': input,
      };
}

/// 账单信息
class BillInfo {
  /// 金额
  final double? amount;

  /// 时间
  final DateTime? time;

  /// 商家/备注
  final String? merchant;

  /// 分类
  final String? category;

  /// 类型（收入/支出）
  final BillType? type;

  /// 账户名称
  final String? account;

  /// 置信度 (0.0 - 1.0)
  final double confidence;

  const BillInfo({
    this.amount,
    this.time,
    this.merchant,
    this.category,
    this.type,
    this.account,
    this.confidence = 0.0,
  });

  /// 是否包含完整信息
  bool get isComplete => amount != null && time != null;

  /// 从JSON创建
  factory BillInfo.fromJson(Map<String, dynamic> json) {
    return BillInfo(
      amount: json['amount']?.toDouble(),
      time: json['time'] != null ? DateTime.tryParse(json['time']) : null,
      merchant: json['merchant'],
      category: json['category'],
      type: json['type'] != null ? _parseBillType(json['type']) : null,
      account: json['account'],
      confidence: json['confidence']?.toDouble() ?? 0.8,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'time': time?.toIso8601String(),
        'merchant': merchant,
        'category': category,
        'type': type?.toString().split('.').last,
        'account': account,
        'confidence': confidence,
      };

  static BillType? _parseBillType(dynamic value) {
    if (value == null) return null;
    final str = value.toString().toLowerCase();
    if (str.contains('income') || str == '收入') return BillType.income;
    if (str.contains('expense') || str == '支出') return BillType.expense;
    return null;
  }

  @override
  String toString() {
    return 'BillInfo(amount: $amount, time: $time, merchant: $merchant, category: $category, type: $type, account: $account)';
  }
}

/// 账单类型
enum BillType {
  /// 收入
  income,

  /// 支出
  expense,
}
