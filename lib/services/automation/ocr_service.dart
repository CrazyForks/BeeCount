import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_bill_service.dart';
import '../../data/db.dart';
import '../../data/repository.dart';

/// OCR识别结果
class OcrResult {
  final double? amount;
  final String? merchant;
  final DateTime? time;
  final String rawText;
  final List<String> allNumbers;
  final int? suggestedCategoryId; // 推荐的分类ID
  final String? aiCategoryName; // AI识别的分类名称
  final String? aiType; // AI识别的类型 (income/expense)
  final String? aiAccountName; // AI识别的账户名称
  final String? aiProvider; // AI提供商（用于日志）
  final bool aiEnhanced; // 是否经过AI增强

  OcrResult({
    this.amount,
    this.merchant,
    this.time,
    required this.rawText,
    required this.allNumbers,
    this.suggestedCategoryId,
    this.aiCategoryName,
    this.aiType,
    this.aiAccountName,
    this.aiProvider,
    this.aiEnhanced = false,
  });

  /// 创建副本并合并AI结果
  OcrResult copyWithAI({
    double? amount,
    String? merchant,
    DateTime? time,
    int? suggestedCategoryId,
    String? aiCategoryName,
    String? aiType,
    String? aiAccountName,
    String? aiProvider,
  }) {
    return OcrResult(
      amount: amount ?? this.amount,
      merchant: merchant ?? this.merchant,
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

/// OCR服务 - 识别支付截图中的金额等信息
class OcrService {
  // 使用中文识别 - 可以识别中文、数字、符号
  // 需要在 android/app/build.gradle 中添加依赖:
  // implementation 'com.google.mlkit:text-recognition-chinese:16.0.0'
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.chinese,
  );

  /// 识别图片中的文本并提取支付信息
  ///
  /// [imageFile] 图片文件
  /// [db] 数据库实例（可选，用于获取账户列表）
  Future<OcrResult> recognizePaymentImage(
    File imageFile, {
    BeeDatabase? db,
  }) async {
    final startTime = DateTime.now();
    print('\n🔍 ========== OCR识别开始 ==========');

    try {
      // 1. OCR文本识别
      print('⏱️ [OCR] 开始文本识别...');
      final ocrStartTime = DateTime.now();

      // 尝试不同的InputImage创建方式,解决华为权限问题
      RecognizedText recognizedText;

      try {
        // 方式1: 直接从文件路径读取(适用于大多数设备)
        print('📁 [OCR] 尝试方式1: 从文件路径读取');
        final inputImage = InputImage.fromFile(imageFile);
        recognizedText = await _textRecognizer.processImage(inputImage);
        print('✅ [OCR] 方式1成功');
      } catch (e) {
        print('⚠️ [OCR] 方式1失败: $e');
        print('📁 [OCR] 尝试方式2: 从文件字节读取(解决华为权限问题)');

        // 方式2: 先复制文件到App私有目录,再读取
        // 华为系统对Screenshots目录有特殊权限保护
        final appDir = await getTemporaryDirectory();
        final tempFile = File('${appDir.path}/temp_screenshot_${DateTime.now().millisecondsSinceEpoch}.jpg');

        // 复制文件
        await imageFile.copy(tempFile.path);
        print('✅ [OCR] 文件已复制到: ${tempFile.path}');

        // 从临时文件读取
        final inputImage = InputImage.fromFile(tempFile);
        recognizedText = await _textRecognizer.processImage(inputImage);
        print('✅ [OCR] 方式2成功');

        // 清理临时文件
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      final rawText = recognizedText.text;
      final ocrDuration = DateTime.now().difference(ocrStartTime);
      print('✅ [OCR] 文本识别完成，耗时: ${ocrDuration.inMilliseconds}ms');
      print('📄 [OCR] 识别文本:\n$rawText\n');

      // 2. 规则提取
      print('⏱️ [规则] 开始规则提取...');
      final ruleStartTime = DateTime.now();
      final allNumbers = _extractAllNumbers(rawText);
      final amount = _extractAmount(rawText);
      final merchant = _extractMerchant(rawText);
      final time = _extractTime(rawText);
      final ruleDuration = DateTime.now().difference(ruleStartTime);

      print('✅ [规则] 提取完成，耗时: ${ruleDuration.inMilliseconds}ms');
      print('💰 [规则] 金额: ${amount ?? "未识别"}');
      print('🏪 [规则] 商家: ${merchant ?? "未识别"}');
      print('⏰ [规则] 时间: ${time ?? "未识别"}');
      print('🔢 [规则] 候选金额: $allNumbers');

      final baseResult = OcrResult(
        amount: amount,
        merchant: merchant,
        time: time,
        rawText: rawText,
        allNumbers: allNumbers,
      );

      // 3. AI增强（如果启用）
      final enhancedResult = await _enhanceWithAI(
        baseResult,
        db: db,
        imageFile: imageFile,
      );

      final totalDuration = DateTime.now().difference(startTime);
      print('🏁 [总计] 识别完成，总耗时: ${totalDuration.inMilliseconds}ms');
      print('========== OCR识别结束 ==========\n');

      return enhancedResult;
    } catch (e) {
      print('❌ [OCR] 识别失败: $e');
      rethrow;
    }
  }

  /// AI增强识别结果
  ///
  /// [baseResult] 基础OCR识别结果
  /// [db] 数据库实例（可选，用于获取账户列表）
  /// [imageFile] 图片文件（用于Vision模型）
  Future<OcrResult> _enhanceWithAI(
    OcrResult baseResult, {
    BeeDatabase? db,
    File? imageFile,
  }) async {
    try {
      // 检查是否启用AI
      final prefs = await SharedPreferences.getInstance();
      final aiEnabled = prefs.getBool('ai_bill_extraction_enabled') ?? false;

      if (!aiEnabled) {
        return baseResult;
      }

      print('🤖 [AI增强] 开始...');
      final aiStartTime = DateTime.now();

      // 获取用户分类列表(从数据库读取)
      List<String> expenseCategories = [];
      List<String> incomeCategories = [];
      if (db != null) {
        try {
          final repository = BeeRepository(db);
          final expenseCats = await repository.getTopLevelCategories('expense');
          final incomeCats = await repository.getTopLevelCategories('income');
          expenseCategories = expenseCats.map((c) => c.name).toList();
          incomeCategories = incomeCats.map((c) => c.name).toList();
          print('📋 [分类列表] 获取到${expenseCategories.length}个支出分类, ${incomeCategories.length}个收入分类');
        } catch (e) {
          print('⚠️ [分类列表] 获取失败: $e');
        }
      }

      // 获取用户账户列表（如果账户功能已启用且提供了数据库实例）
      List<String>? accounts;
      final accountFeatureEnabled = prefs.getBool('account_feature_enabled') ?? true; // 默认启用
      if (accountFeatureEnabled && db != null) {
        try {
          final repository = BeeRepository(db);
          final allAccounts = await repository.getAllAccounts();
          accounts = allAccounts.map((a) => a.name).toList();
          print('📋 [账户列表] 获取到${accounts.length}个账户: ${accounts.join('、')}');
        } catch (e) {
          print('⚠️ [账户列表] 获取失败: $e');
          accounts = null;
        }
      }

      // 初始化AI服务
      final aiService = AIBillService();
      await aiService.initialize(
        expenseCategories: expenseCategories,
        incomeCategories: incomeCategories,
        accounts: accounts,
        imageFile: imageFile,
      );

      final billInfo = await aiService.extractBillInfo(
        baseResult.rawText,
        expenseCategories: expenseCategories,
        incomeCategories: incomeCategories,
        accounts: accounts,
        imageFile: imageFile,
      );
      final aiDuration = DateTime.now().difference(aiStartTime);

      if (billInfo != null) {
        // 智能合并策略：AI优先，规则兜底
        final mergedAmount = billInfo.amount ?? baseResult.amount;
        final mergedMerchant = billInfo.merchant ?? baseResult.merchant;
        final mergedTime = billInfo.time ?? baseResult.time;
        final mergedAccount = billInfo.account;

        final typeText = billInfo.type?.toString().split('.').last ?? '未知';
        final typeEmoji = typeText == 'expense' ? '💸' : (typeText == 'income' ? '💰' : '❓');
        print('✅ [AI增强] 成功 ${aiDuration.inMilliseconds}ms | $typeEmoji$typeText 金额:$mergedAmount 商家:$mergedMerchant 分类:${billInfo.category} 账户:${mergedAccount ?? "未识别"}');

        return baseResult.copyWithAI(
          amount: mergedAmount,
          merchant: mergedMerchant,
          time: mergedTime,
          aiCategoryName: billInfo.category,
          aiType: typeText,
          aiAccountName: mergedAccount,
          aiProvider: 'AI',
        );
      } else {
        print('⚠️ [AI增强] 失败或超时，使用规则识别结果');
        return baseResult;
      }
    } catch (e) {
      print('❌ [AI增强] 失败: $e');
      return baseResult;
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
