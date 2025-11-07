import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// OCR识别结果
class OcrResult {
  final double? amount;
  final String? merchant;
  final DateTime? time;
  final String rawText;
  final List<String> allNumbers;
  final int? suggestedCategoryId; // 推荐的分类ID

  OcrResult({
    this.amount,
    this.merchant,
    this.time,
    required this.rawText,
    required this.allNumbers,
    this.suggestedCategoryId,
  });
}

/// OCR服务 - 识别支付截图中的金额等信息
class OcrService {
  // 使用中文识别 - 可以识别中文、数字、符号
  // 需要在 android/app/build.gradle 中添加依赖:
  // implementation 'com.google.mlkit:text-recognition-chinese:16.0.0'
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.chinese,
  );

  /// 识别图片中的文本并提取支付信息
  Future<OcrResult> recognizePaymentImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      final rawText = recognizedText.text;

      // 提取所有可能的金额数字
      final allNumbers = _extractAllNumbers(rawText);

      // 提取金额
      final amount = _extractAmount(rawText);

      // 提取商家名称
      final merchant = _extractMerchant(rawText);

      // 提取时间
      final time = _extractTime(rawText);

      return OcrResult(
        amount: amount,
        merchant: merchant,
        time: time,
        rawText: rawText,
        allNumbers: allNumbers,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 直接解析文本并提取支付信息(无需OCR)
  /// 用于快捷指令传递的已识别文本
  OcrResult parsePaymentText(String rawText) {
    // 提取所有可能的金额数字
    final allNumbers = _extractAllNumbers(rawText);

    // 提取金额
    final amount = _extractAmount(rawText);

    // 提取商家名称
    final merchant = _extractMerchant(rawText);

    // 提取时间
    final time = _extractTime(rawText);

    return OcrResult(
      amount: amount,
      merchant: merchant,
      time: time,
      rawText: rawText,
      allNumbers: allNumbers,
    );
  }

  /// 提取所有可能的数字（供用户选择）
  List<String> _extractAllNumbers(String text) {
    final numbers = <String>[];

    // 匹配各种金额格式
    final patterns = [
      RegExp(r'¥\s*(\d+\.?\d*)'), // ¥123.45
      RegExp(r'￥\s*(\d+\.?\d*)'), // ￥123.45
      RegExp(r'(\d+\.\d{2})\s*元'), // 123.45元
      RegExp(r'(\d+\.\d{2})'), // 纯数字带小数点
      RegExp(r'(\d{1,6})\s*\.\s*(\d{2})'), // 123 . 45 (可能有空格)
    ];

    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        if (match.groupCount > 0) {
          final numStr = match.group(1);
          if (numStr != null && numStr.isNotEmpty) {
            final num = double.tryParse(numStr);
            if (num != null && num > 0 && num < 1000000) {
              numbers.add(numStr);
            }
          }
        }
      }
    }

    // 去重并排序
    final uniqueNumbers = numbers.toSet().toList();
    uniqueNumbers.sort((a, b) {
      final numA = double.parse(a);
      final numB = double.parse(b);
      return numB.compareTo(numA); // 从大到小排序
    });

    return uniqueNumbers;
  }

  /// 提取金额 - 优先识别支付宝/微信支付的特征
  double? _extractAmount(String text) {
    // 移除所有空格和换行，方便匹配
    final cleanText = text.replaceAll(RegExp(r'\s+'), '');

    // 支付宝特征：付款 ¥123.45 或 实付 ¥123.45
    final alipayPatterns = [
      RegExp(r'[付实付收款]款?[¥￥]\s*(\d+\.?\d*)'),
      RegExp(r'[¥￥]\s*(\d+\.\d{2})', caseSensitive: false),
    ];

    for (final pattern in alipayPatterns) {
      final match = pattern.firstMatch(cleanText);
      if (match != null && match.groupCount > 0) {
        final amountStr = match.group(1);
        if (amountStr != null) {
          final amount = double.tryParse(amountStr);
          if (amount != null && amount > 0) {
            return amount;
          }
        }
      }
    }

    // 微信支付特征：¥123.45 通常在顶部较大字体
    final wechatPattern = RegExp(r'[¥￥](\d+\.\d{2})');
    final matches = wechatPattern.allMatches(cleanText);

    // 取第一个匹配（通常是金额）
    if (matches.isNotEmpty) {
      final match = matches.first;
      final amountStr = match.group(1);
      if (amountStr != null) {
        final amount = double.tryParse(amountStr);
        if (amount != null && amount > 0) {
          return amount;
        }
      }
    }

    // 通用金额匹配：xx.xx元
    final generalPattern = RegExp(r'(\d+\.\d{2})元');
    final generalMatch = generalPattern.firstMatch(cleanText);
    if (generalMatch != null) {
      final amountStr = generalMatch.group(1);
      if (amountStr != null) {
        return double.tryParse(amountStr);
      }
    }

    // 如果前面都没匹配到,尝试匹配负号金额: -14.00 或 -14.93
    // 只匹配带小数点的金额，避免误匹配时间等
    final negativePattern = RegExp(r'-(\d+\.\d{2})');
    final negativeMatches = negativePattern.allMatches(cleanText);
    if (negativeMatches.isNotEmpty) {
      // 过滤掉小额红包（小于1元的），优先选择最大的负数金额
      double? maxAmount;
      for (final match in negativeMatches) {
        final amountStr = match.group(1);
        if (amountStr != null) {
          final amount = double.tryParse(amountStr);
          if (amount != null &&
              amount >= 0.01 &&
              amount < 100000 &&
              (maxAmount == null || amount > maxAmount)) {
            maxAmount = amount;
          }
        }
      }
      if (maxAmount != null && maxAmount >= 1.0) {
        // 只返回大于等于1元的金额，过滤小额红包
        return maxAmount;
      }
    }

    // 最后尝试: 如果 allNumbers 中有有效金额,使用第一个
    final allNumbers = _extractAllNumbers(text);
    if (allNumbers.isNotEmpty) {
      return double.tryParse(allNumbers.first);
    }

    return null;
  }

  /// 提取商家名称
  String? _extractMerchant(String text) {
    // 支付宝特征：收款方全称：xxx 或 收款方：xxx
    final patterns = [
      // 收款方全称后面可能换行，匹配下一行的公司名
      RegExp(r'收款方全称[:：]\s*\n?\s*([^\n]{3,30})'),
      RegExp(r'收款方全称[:：]\s*([^\n]{3,30})'),
      RegExp(r'收款方[:：]\s*\n?\s*([^\n]{3,30})'),
      RegExp(r'收款方[:：]\s*([^\n]{3,30})'),
      RegExp(r'商家[:：]\s*([^\n]{3,30})'),
      RegExp(r'店铺[:：]\s*([^\n]{3,30})'),
      // 匹配公司名称特征（包含"公司"、"店"等）
      RegExp(r'([^\n]{2,20}(?:有限公司|责任公司|股份公司|公司|店|商行))'),
      // 微信支付特征：向xxx付款
      RegExp(r'向\s*([^\n付款]{2,20})\s*付款'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.groupCount > 0) {
        var merchant = match.group(1)?.trim();
        if (merchant != null && merchant.isNotEmpty) {
          // 过滤掉一些无用信息
          merchant = merchant.split(RegExp(r'[,，。\.]')).first.trim();
          // 过滤掉数字、日期等
          if (merchant.length >= 3 &&
              !RegExp(r'^\d+$').hasMatch(merchant) &&
              !RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(merchant)) {
            return merchant;
          }
        }
      }
    }

    return null;
  }

  /// 提取支付时间
  DateTime? _extractTime(String text) {
    // 时间格式：支持多种格式
    final patterns = [
      // 2025-11-06 14:30:25
      RegExp(r'(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2}):(\d{2})'),
      // 2025-11-06 14:30
      RegExp(r'(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})'),
      // 2025年11月06日 14:30:25
      RegExp(r'(\d{4})年(\d{1,2})月(\d{1,2})日\s+(\d{2}):(\d{2}):(\d{2})'),
      // 2025年8月30日 16:06:30
      RegExp(r'(\d{4})年(\d{1,2})月(\d{1,2})日\s+(\d{1,2}):(\d{2}):(\d{2})'),
      // 2025年11月06日 14:30
      RegExp(r'(\d{4})年(\d{1,2})月(\d{1,2})日\s+(\d{2}):(\d{2})'),
      // MM-DD HH:mm
      RegExp(r'(\d{2})-(\d{2})\s+(\d{2}):(\d{2})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          if (match.groupCount == 6) {
            // 完整日期时间带秒
            final year = int.parse(match.group(1)!);
            final month = int.parse(match.group(2)!);
            final day = int.parse(match.group(3)!);
            final hour = int.parse(match.group(4)!);
            final minute = int.parse(match.group(5)!);
            final second = int.parse(match.group(6)!);
            return DateTime(year, month, day, hour, minute, second);
          } else if (match.groupCount == 5) {
            // 完整日期时间不带秒
            final year = int.parse(match.group(1)!);
            final month = int.parse(match.group(2)!);
            final day = int.parse(match.group(3)!);
            final hour = int.parse(match.group(4)!);
            final minute = int.parse(match.group(5)!);
            return DateTime(year, month, day, hour, minute);
          } else if (match.groupCount == 4) {
            // MM-DD格式，使用当前年份
            final now = DateTime.now();
            final month = int.parse(match.group(1)!);
            final day = int.parse(match.group(2)!);
            final hour = int.parse(match.group(3)!);
            final minute = int.parse(match.group(4)!);
            return DateTime(now.year, month, day, hour, minute);
          }
        } catch (e) {
          continue;
        }
      }
    }

    return null;
  }

  /// 释放资源
  void dispose() {
    _textRecognizer.close();
  }
}
