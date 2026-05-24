/// 账单识别结果(AI 视觉 / 文本提取 / 语音 → 文本 后的统一格式)
///
/// 历史上叫 `OcrResult`(google_mlkit_text_recognition 时代),v3.2.1 删 OCR
/// 改走 AI 视觉后留下的数据载体。`BillCreationService.createBillTransaction`
/// / `auto_billing_service._createTransaction` 等下游都以本类为入参。
class OcrResult {
  /// 金额(绝对值;`aiType` 区分收入/支出)
  final double? amount;

  /// 商家 / 备注信息
  final String? note;

  /// 交易发生时间(AI 从图片/文本里解析,没解析到就是 null,后续 fallback 当前时间)
  final DateTime? time;

  /// 原始 OCR 文本 — AI 视觉路径下通常为空字符串。保留字段是为了向后兼容
  /// (老代码可能 read 但不会再 write)。
  final String rawText;

  /// 文本里抠到的所有数字 — 同上,AI 路径下为空 list。
  final List<String> allNumbers;

  /// AI 推荐的本地 categoryId(已经过 CategoryMatcher 匹配)。null 表示
  /// 让用户手动选。
  final int? suggestedCategoryId;

  /// AI 识别出的分类名(用于 fallback 匹配 / 创建新分类)
  final String? aiCategoryName;

  /// AI 识别的类型('income' / 'expense' / 'transfer')
  final String? aiType;

  /// AI 识别的账户名
  final String? aiAccountName;

  /// AI 提供商(GLM / Zhipu / OpenAI 等,用于日志)
  final String? aiProvider;

  /// 是否经过 AI 处理。v3.2.1 之后默认 true,因为所有识别都走 AI。
  final bool aiEnhanced;

  const OcrResult({
    this.amount,
    this.note,
    this.time,
    this.rawText = '',
    this.allNumbers = const [],
    this.suggestedCategoryId,
    this.aiCategoryName,
    this.aiType,
    this.aiAccountName,
    this.aiProvider,
    this.aiEnhanced = true,
  });

  /// 创建副本并合并 AI 结果(历史 OCR → AI 增强两步走的产物;v3.2.1 起 AI 就是
  /// 唯一识别路径,本方法保留兼容老 caller)。
  OcrResult copyWithAI({
    double? amount,
    String? note,
    DateTime? time,
    int? suggestedCategoryId,
    String? aiCategoryName,
    String? aiType,
    String? aiAccountName,
    String? aiProvider,
  }) {
    return OcrResult(
      amount: amount ?? this.amount,
      note: note ?? this.note,
      time: time ?? this.time,
      rawText: rawText,
      allNumbers: allNumbers,
      suggestedCategoryId: suggestedCategoryId ?? this.suggestedCategoryId,
      aiCategoryName: aiCategoryName ?? this.aiCategoryName,
      aiType: aiType ?? this.aiType,
      aiAccountName: aiAccountName ?? this.aiAccountName,
      aiProvider: aiProvider,
      aiEnhanced: true,
    );
  }
}
