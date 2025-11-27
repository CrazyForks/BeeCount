import 'dart:io';

import 'package:flutter_ai_kit/flutter_ai_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart';

import 'package:flutter_ai_kit_zhipu/flutter_ai_kit_zhipu.dart';
import '../services/automation/ai_bill_service.dart';
import '../ai/tasks/bill_extraction_task.dart';
import '../data/db.dart';
import '../services/logger_service.dart';

/// AI 对话服务
///
/// 支持两种模式:
/// 1. 对话记账 - 复用 AIBillService 和 BillCreationService
/// 2. 自由对话 - 使用智谱 GLM 进行对话
class AIChatService {
  final AIBillService _aiBillService = AIBillService();
  final BeeDatabase _db;

  AIChatService({required BeeDatabase db}) : _db = db;

  /// 处理用户消息
  Future<AIResponse> processMessage(
    String userInput, {
    List<String>? expenseCategories,
    List<String>? incomeCategories,
    String? languageCode,
  }) async {
    logger.info('AIChat', '收到消息: $userInput');

    try {
      // 判断意图
      if (_isTransactionIntent(userInput)) {
        logger.debug('AIChat', '识别为记账意图');
        return await _handleTransaction(
          userInput,
          expenseCategories: expenseCategories,
          incomeCategories: incomeCategories,
        );
      } else {
        logger.debug('AIChat', '识别为自由对话');
        return await _handleFreeChat(userInput, languageCode: languageCode);
      }
    } catch (e, st) {
      logger.error('AIChat', '处理失败', e, st);
      return AIResponse.error('抱歉,处理失败,请重试');
    }
  }

  /// 判断是否是记账意图
  bool _isTransactionIntent(String input) {
    // 包含金额 → 记账意图
    final hasAmount = RegExp(r'\d+(?:\.\d+)?').hasMatch(input);

    // 或包含记账关键词
    const keywords = ['买', '花', '消费', '支付', '记账', '付', '收入', '赚', '工资'];
    final hasKeyword = keywords.any((k) => input.contains(k));

    return hasAmount || hasKeyword;
  }

  /// 处理记账 - 复用 AIBillService
  Future<AIResponse> _handleTransaction(
    String input, {
    List<String>? expenseCategories,
    List<String>? incomeCategories,
  }) async {
    logger.debug('AIChat', '识别为记账意图');

    // 调用 AIBillService
    final billInfo = await _aiBillService.extractBillInfo(
      input,
      expenseCategories: expenseCategories,
      incomeCategories: incomeCategories,
    );

    if (billInfo != null && billInfo.isComplete) {
      logger.info('AIChat', '账单提取成功: ${billInfo.toJson()}');

      // 保存到数据库
      final transactionId = await _saveBill(billInfo);

      // 返回账单卡片
      return AIResponse.billCard(billInfo, transactionId);
    } else {
      logger.warning('AIChat', '账单提取失败或信息不完整');

      // 提取失败
      return AIResponse.text(
        '抱歉,未识别到完整的记账信息。\n\n'
        '请这样说:\n'
        '• 买了杯奶茶28块\n'
        '• 今天午餐花了50\n'
        '• 打车回家花了35',
      );
    }
  }

  /// 处理自由对话 - 使用智谱 GLM
  Future<AIResponse> _handleFreeChat(String input, {String? languageCode}) async {
    logger.info('AIChat', '开始自由对话 (语言: ${languageCode ?? "默认"})');

    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('ai_glm_api_key');

    if (apiKey == null || apiKey.isEmpty) {
      logger.warning('AIChat', 'API Key 未配置');
      return AIResponse.error(
        '需要配置智谱 GLM API Key 才能使用对话功能。\n\n'
        '前往 设置 > AI设置 进行配置。',
      );
    }

    try {
      // 使用 flutter_ai_kit 的 ZhipuGLMProvider
      final aiKit = FlutterAIKit();

      // 注册智谱 Provider (使用 glm-4 通用对话模型)
      final zhipuProvider = ZhipuGLMProvider(
        apiKey: apiKey,
        model: 'glm-4',
        temperature: 0.7,
      );
      aiKit.registerProvider(zhipuProvider);

      // 创建对话任务 - 根据语言构建系统提示
      String systemPrompt;
      if (languageCode == 'en') {
        systemPrompt = 'You are BeeCount\'s AI assistant, mainly helping users with bookkeeping. '
            'If users ask about statistics, queries and other functions, please inform them that they are not supported yet and guide them to use the bookkeeping function. '
            'Please respond in English.';
      } else {
        systemPrompt = '你是蜜蜂记账的AI助手,主要帮助用户记账。'
            '如果用户询问统计、查询等功能,请告知暂不支持,引导用户使用记账功能。'
            '请用中文回复。';
      }

      final task = _SimpleChatTask('$systemPrompt\n\n用户: $input\nAI:');

      // 执行任务
      final result = await aiKit.execute(
        task,
        context: AIExecutionContext(
          hasNetwork: await _checkNetwork(),
          timeout: const Duration(seconds: 30),
        ),
      );

      if (result.success) {
        logger.info('AIChat', '对话响应成功');
        return AIResponse.text(result.data!);
      } else {
        logger.error('AIChat', '对话响应失败: ${result.error}');
        return AIResponse.error('AI服务暂时不可用,请稍后重试');
      }
    } catch (e, st) {
      logger.error('AIChat', '自由对话失败', e, st);
      return AIResponse.error('网络连接失败,请检查网络');
    }
  }

  /// 保存账单 - 复用 BillCreationService 的逻辑
  Future<int> _saveBill(BillInfo bill) async {
    logger.info('AIChat', '开始保存账单: amount=${bill.amount}, category=${bill.category}');

    // 获取当前账本 ID
    final ledgers = await (_db.select(_db.ledgers)).get();
    final ledgerId = ledgers.first.id;

    // 确定交易类型
    final transactionType = bill.type == BillType.expense ? 'expense' : 'income';

    // 获取对应类型的所有分类
    final typeCategories = await (_db.select(_db.categories)
          ..where((t) => t.kind.equals(transactionType)))
        .get();

    // 使用 BillCreationService 匹配分类 (复用图片记账的逻辑)
    final categoryId = await _matchCategory(
      bill.category ?? '其他',
      typeCategories,
    );

    // 使用 BillCreationService 匹配账户 (复用图片记账的逻辑)
    final accountId = await _matchAccount(
      bill.account,
      ledgerId,
      transactionType: transactionType,
    );

    // 插入交易记录 (金额使用绝对值)
    final amount = bill.amount!.abs();
    final id = await _db.into(_db.transactions).insert(
      TransactionsCompanion.insert(
        ledgerId: ledgerId,
        type: transactionType,
        amount: amount,
        categoryId: Value(categoryId),
        accountId: Value(accountId),
        note: Value(bill.merchant),
        happenedAt: Value(bill.time ?? DateTime.now()),
      ),
    );

    logger.info('AIChat', '记账成功: id=$id, amount=$amount, categoryId=$categoryId, accountId=$accountId');
    return id;
  }

  /// 匹配分类 - 复用图片记账的逻辑
  Future<int?> _matchCategory(
    String categoryName,
    List<Category> categories,
  ) async {
    if (categories.isEmpty) return null;

    try {
      // 优先精确匹配
      final matched = categories.firstWhere(
        (cat) => cat.name == categoryName,
      );
      logger.debug('AIChat', '[分类匹配] "$categoryName" → ID:${matched.id}');
      return matched.id;
    } catch (_) {
      // 未找到,使用"其他"或第一个一级分类
      try {
        final other = categories.firstWhere(
          (cat) => cat.name == '其他' && cat.level == 1,
        );
        logger.debug('AIChat', '[分类匹配] "$categoryName"未找到，使用"其他"');
        return other.id;
      } catch (_) {
        final firstLevel1 = categories.firstWhere(
          (cat) => cat.level == 1,
        );
        logger.debug('AIChat', '[分类匹配] "$categoryName"未找到，使用第一个一级分类');
        return firstLevel1.id;
      }
    }
  }

  /// 匹配账户 - 复用图片记账的逻辑
  Future<int?> _matchAccount(
    String? accountName,
    int ledgerId, {
    String transactionType = 'expense',
  }) async {
    // 检查账户功能是否启用
    final prefs = await SharedPreferences.getInstance();
    final accountFeatureEnabled = prefs.getBool('account_feature_enabled') ?? true;

    if (!accountFeatureEnabled) {
      logger.debug('AIChat', '[账户匹配] 账户功能未启用');
      return null;
    }

    if (accountName == null || accountName.isEmpty) {
      logger.debug('AIChat', '[账户匹配] 未识别账户，尝试使用默认账户');
      // 获取默认账户
      final defaultAccountKey = transactionType == 'income'
          ? 'default_income_account'
          : 'default_expense_account';
      return prefs.getInt(defaultAccountKey);
    }

    // 获取账本币种
    final ledger = await (_db.select(_db.ledgers)
          ..where((t) => t.id.equals(ledgerId)))
        .getSingleOrNull();

    if (ledger == null) return null;

    // 查询匹配账户
    final allAccounts = await (_db.select(_db.accounts)).get();
    final matchingAccounts = allAccounts
        .where((a) => a.currency == ledger.currency)
        .toList();

    // 精确匹配账户名称
    try {
      final matched = matchingAccounts.firstWhere(
        (a) => a.name.toLowerCase().trim() == accountName.toLowerCase().trim(),
      );
      logger.debug('AIChat', '[账户匹配] "$accountName" → ID:${matched.id}');
      return matched.id;
    } catch (_) {
      logger.debug('AIChat', '[账户匹配] "$accountName"未找到');
      return null;
    }
  }

  /// 撤销记账
  Future<bool> undoTransaction(int transactionId) async {
    try {
      await (_db.delete(_db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .go();
      logger.info('AIChat', '撤销记账: id=$transactionId');
      return true;
    } catch (e, st) {
      logger.error('AIChat', '撤销失败', e, st);
      return false;
    }
  }

  /// 检查网络连接
  Future<bool> _checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

/// AI 响应模型
class AIResponse {
  final String type; // 'text' | 'bill_card' | 'error'
  final String text;
  final BillInfo? billInfo;
  final int? transactionId;

  AIResponse({
    required this.type,
    required this.text,
    this.billInfo,
    this.transactionId,
  });

  factory AIResponse.text(String text) {
    return AIResponse(type: 'text', text: text);
  }

  factory AIResponse.billCard(BillInfo bill, int transactionId) {
    return AIResponse(
      type: 'bill_card',
      text: '✅ 记账成功',
      billInfo: bill,
      transactionId: transactionId,
    );
  }

  factory AIResponse.error(String message) {
    return AIResponse(type: 'error', text: message);
  }
}

/// 简单对话任务
class _SimpleChatTask extends AITask<String, String> {
  final String prompt;

  _SimpleChatTask(this.prompt);

  @override
  String get taskType => 'chat';

  @override
  String get input => prompt;

  @override
  Map<String, dynamic> toJson() => {
        'task_type': taskType,
        'prompt': prompt,
      };
}
