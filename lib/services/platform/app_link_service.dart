import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repositories/base_repository.dart';
import '../../providers/database_providers.dart';
import '../../providers/sync_providers.dart';
import '../../providers/statistics_providers.dart';
import '../../providers/tag_providers.dart';
import '../automation/auto_billing_service.dart';
import '../system/logger_service.dart';

/// AppLink 动作类型
enum AppLinkAction {
  /// 语音记账
  voice,

  /// 图片记账（从相册选择）
  image,

  /// 拍照记账
  camera,

  /// AI 小助手
  aiChat,

  /// 自动记账（带参数）
  add,

  /// 自动记账（从文本）
  autoBilling,

  /// 快速记账（从相册）
  quickBilling,

  /// 未知
  unknown,
}

/// 自动记账参数
class AddTransactionParams {
  final double amount;
  final String type; // expense, income, transfer
  final String? category;
  final String? note;
  final String? account;
  final String? toAccount;
  final List<String>? tags;
  final DateTime? date;
  final bool silent;

  const AddTransactionParams({
    required this.amount,
    this.type = 'expense',
    this.category,
    this.note,
    this.account,
    this.toAccount,
    this.tags,
    this.date,
    this.silent = false,
  });

  factory AddTransactionParams.fromQueryParams(Map<String, String> params) {
    final amountStr = params['amount'];
    if (amountStr == null || amountStr.isEmpty) {
      throw ArgumentError('amount is required');
    }

    final amount = double.tryParse(amountStr);
    if (amount == null || amount <= 0) {
      throw ArgumentError('amount must be a positive number');
    }

    // 解析日期
    DateTime? date;
    final dateStr = params['date'];
    if (dateStr != null && dateStr.isNotEmpty) {
      date = DateTime.tryParse(dateStr);
    }

    // 解析标签
    List<String>? tags;
    final tagsStr = params['tags'];
    if (tagsStr != null && tagsStr.isNotEmpty) {
      tags = tagsStr.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
    }

    return AddTransactionParams(
      amount: amount,
      type: params['type'] ?? 'expense',
      category: params['category'],
      note: params['note'],
      account: params['account'],
      toAccount: params['to_account'],
      tags: tags,
      date: date,
      silent: params['silent'] == '1' || params['silent'] == 'true',
    );
  }
}

/// AppLink 处理结果
class AppLinkResult {
  final bool success;
  final String? message;
  final int? transactionId;

  const AppLinkResult({
    required this.success,
    this.message,
    this.transactionId,
  });

  factory AppLinkResult.success({String? message, int? transactionId}) =>
      AppLinkResult(success: true, message: message, transactionId: transactionId);

  factory AppLinkResult.failure(String message) =>
      AppLinkResult(success: false, message: message);
}

/// AppLink 服务
///
/// 处理所有 beecount:// 开头的链接
///
/// 支持的链接格式:
/// - beecount://voice - 语音记账
/// - beecount://image - 图片记账（从相册）
/// - beecount://camera - 拍照记账
/// - beecount://ai-chat - AI 小助手
/// - beecount://add?amount=100&type=expense&category=餐饮 - 自动记账
/// - beecount://auto-billing?text=... - 文本自动记账（兼容旧版）
/// - beecount://quick-billing - 快速记账（兼容旧版）
class AppLinkService {
  final ProviderContainer _container;
  late final AutoBillingService _autoBillingService;
  final ImagePicker _imagePicker = ImagePicker();

  /// 导航回调，由外部设置
  void Function(AppLinkAction action, {AddTransactionParams? params})? onNavigate;

  /// Toast 回调，由外部设置
  void Function(String message)? onShowToast;

  AppLinkService(this._container) {
    _autoBillingService = AutoBillingService(_container);
  }

  /// 解析 URI 获取动作类型
  static AppLinkAction parseAction(Uri uri) {
    final host = uri.host.toLowerCase();
    switch (host) {
      case 'voice':
        return AppLinkAction.voice;
      case 'image':
        return AppLinkAction.image;
      case 'camera':
        return AppLinkAction.camera;
      case 'ai-chat':
      case 'aichat':
      case 'ai':
        return AppLinkAction.aiChat;
      case 'add':
        return AppLinkAction.add;
      case 'auto-billing':
        return AppLinkAction.autoBilling;
      case 'quick-billing':
        return AppLinkAction.quickBilling;
      default:
        return AppLinkAction.unknown;
    }
  }

  /// 处理 URL
  Future<AppLinkResult> handleUrl(Uri uri) async {
    logger.info('AppLink', '收到URL: $uri');

    final action = parseAction(uri);
    final queryParams = uri.queryParameters;

    switch (action) {
      case AppLinkAction.voice:
        logger.info('AppLink', '打开语音记账');
        onNavigate?.call(AppLinkAction.voice);
        return AppLinkResult.success(message: '打开语音记账');

      case AppLinkAction.image:
        logger.info('AppLink', '打开图片记账');
        return await _handleImageBilling();

      case AppLinkAction.camera:
        logger.info('AppLink', '打开拍照记账');
        return await _handleCameraBilling();

      case AppLinkAction.aiChat:
        logger.info('AppLink', '打开AI小助手');
        onNavigate?.call(AppLinkAction.aiChat);
        return AppLinkResult.success(message: '打开AI小助手');

      case AppLinkAction.add:
        logger.info('AppLink', '自动记账: $queryParams');
        return await _handleAddTransaction(queryParams);

      case AppLinkAction.autoBilling:
        // 兼容旧版
        return await _handleAutoBilling(queryParams);

      case AppLinkAction.quickBilling:
        // 兼容旧版
        return await _handleImageBilling();

      case AppLinkAction.unknown:
        logger.warning('AppLink', '未知的action: ${uri.host}');
        return AppLinkResult.failure('未知的操作: ${uri.host}');
    }
  }

  /// 处理图片记账（从相册选择）
  Future<AppLinkResult> _handleImageBilling() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        logger.info('AppLink', '用户取消选择图片');
        return AppLinkResult.failure('已取消');
      }

      logger.info('AppLink', '用户选择了图片: ${pickedFile.path}');

      await _autoBillingService.processScreenshot(
        pickedFile.path,
        showNotification: true,
      );

      return AppLinkResult.success(message: '图片处理完成');
    } catch (e, st) {
      logger.error('AppLink', '图片记账失败', e, st);
      return AppLinkResult.failure('图片记账失败: $e');
    }
  }

  /// 处理拍照记账
  Future<AppLinkResult> _handleCameraBilling() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        logger.info('AppLink', '用户取消拍照');
        return AppLinkResult.failure('已取消');
      }

      logger.info('AppLink', '用户拍摄了照片: ${pickedFile.path}');

      await _autoBillingService.processScreenshot(
        pickedFile.path,
        showNotification: true,
      );

      return AppLinkResult.success(message: '照片处理完成');
    } catch (e, st) {
      logger.error('AppLink', '拍照记账失败', e, st);
      return AppLinkResult.failure('拍照记账失败: $e');
    }
  }

  /// 处理自动记账（带参数）
  Future<AppLinkResult> _handleAddTransaction(Map<String, String> params) async {
    try {
      final txParams = AddTransactionParams.fromQueryParams(params);

      final repo = _container.read(repositoryProvider);
      final currentLedger = _container.read(currentLedgerProvider).valueOrNull;

      if (currentLedger == null) {
        return AppLinkResult.failure('请先选择账本');
      }

      final ledgerId = currentLedger.id;

      // 解析分类
      int? categoryId;
      if (txParams.category != null) {
        categoryId = await _findCategoryId(
          repo,
          txParams.category!,
          txParams.type == 'income' ? 'income' : 'expense',
        );
      }

      // 解析账户（不存在则自动创建）
      int? accountId;
      if (txParams.account != null) {
        accountId = await _findOrCreateAccountId(repo, txParams.account!, ledgerId);
      }

      // 解析转入账户（不存在则自动创建）
      int? toAccountId;
      if (txParams.type == 'transfer' && txParams.toAccount != null) {
        toAccountId = await _findOrCreateAccountId(repo, txParams.toAccount!, ledgerId);
      }

      // 创建交易
      final transactionId = await repo.addTransaction(
        ledgerId: ledgerId,
        type: txParams.type,
        amount: txParams.type == 'expense' ? -txParams.amount.abs() : txParams.amount.abs(),
        categoryId: categoryId,
        accountId: accountId,
        toAccountId: toAccountId,
        happenedAt: txParams.date ?? DateTime.now(),
        note: txParams.note,
      );

      // 关联标签
      if (txParams.tags != null && txParams.tags!.isNotEmpty) {
        final tagIds = <int>[];
        for (final tagName in txParams.tags!) {
          final tag = await repo.getTagByName(tagName);
          if (tag != null) {
            tagIds.add(tag.id);
          } else {
            // 创建新标签
            final newTagId = await repo.createTag(name: tagName);
            tagIds.add(newTagId);
          }
        }
        if (tagIds.isNotEmpty) {
          await repo.updateTransactionTags(
            transactionId: transactionId,
            tagIds: tagIds,
          );
        }
      }

      logger.info('AppLink', '自动记账成功: id=$transactionId, amount=${txParams.amount}');

      // 触发 UI 刷新
      _triggerRefresh();

      if (!txParams.silent) {
        final typeText = txParams.type == 'income' ? '收入' : (txParams.type == 'transfer' ? '转账' : '支出');
        onShowToast?.call('已记录 $typeText ${txParams.amount.toStringAsFixed(2)} 元');
      }

      return AppLinkResult.success(
        message: '记账成功',
        transactionId: transactionId,
      );
    } on ArgumentError catch (e) {
      logger.warning('AppLink', '参数错误: $e');
      return AppLinkResult.failure('参数错误: ${e.message}');
    } catch (e, st) {
      logger.error('AppLink', '自动记账失败', e, st);
      return AppLinkResult.failure('记账失败: $e');
    }
  }

  /// 处理旧版文本自动记账
  Future<AppLinkResult> _handleAutoBilling(Map<String, String> params) async {
    String? text = params['text'];

    if (text != null && text.isNotEmpty) {
      // 将逗号还原为换行符
      text = text.replaceAll(',', '\n');
      logger.info('AppLink', '从URL参数读取文本，长度: ${text.length}');

      try {
        await _autoBillingService.processText(
          text,
          showNotification: true,
        );
        return AppLinkResult.success(message: '文本处理完成');
      } catch (e, st) {
        logger.error('AppLink', '文本记账失败', e, st);
        return AppLinkResult.failure('文本记账失败: $e');
      }
    } else {
      logger.warning('AppLink', 'auto-billing 未提供文本');
      return AppLinkResult.failure('未提供文本内容');
    }
  }

  /// 根据名称查找分类ID
  Future<int?> _findCategoryId(BaseRepository repo, String name, String kind) async {
    final categories = kind == 'income'
        ? await repo.getTopLevelCategories('income')
        : await repo.getTopLevelCategories('expense');

    for (final cat in categories) {
      if (cat.name == name) {
        return cat.id;
      }
      // 检查子分类
      final subCats = await repo.getSubCategories(cat.id);
      for (final sub in subCats) {
        if (sub.name == name) {
          return sub.id;
        }
      }
    }
    return null;
  }

  /// 根据名称查找账户ID，不存在则创建
  Future<int?> _findOrCreateAccountId(BaseRepository repo, String name, int ledgerId) async {
    final accounts = await repo.getAllAccounts();
    for (final acc in accounts) {
      if (acc.name == name) {
        return acc.id;
      }
    }
    // 账户不存在，自动创建
    logger.info('AppLink', '账户 "$name" 不存在，自动创建');
    final newAccountId = await repo.createAccount(
      ledgerId: ledgerId,
      name: name,
    );
    return newAccountId;
  }

  /// 触发 UI 刷新（账本列表、统计、标签等）
  void _triggerRefresh() {
    logger.info('AppLink', '触发 UI 刷新');
    _container.read(ledgerListRefreshProvider.notifier).state++;
    _container.read(statsRefreshProvider.notifier).state++;
    _container.read(tagListRefreshProvider.notifier).state++;
  }

  /// 释放资源
  void dispose() {
    _autoBillingService.dispose();
  }
}

/// 生成 AppLink URL
class AppLinkBuilder {
  static const String scheme = 'beecount';

  /// 语音记账链接
  static String voice() => '$scheme://voice';

  /// 图片记账链接
  static String image() => '$scheme://image';

  /// 拍照记账链接
  static String camera() => '$scheme://camera';

  /// AI 小助手链接
  static String aiChat() => '$scheme://ai-chat';

  /// 自动记账链接
  static String add({
    required double amount,
    String type = 'expense',
    String? category,
    String? note,
    String? account,
    String? toAccount,
    List<String>? tags,
    DateTime? date,
    bool silent = false,
  }) {
    final params = <String, String>{
      'amount': amount.toString(),
      'type': type,
    };

    if (category != null) params['category'] = category;
    if (note != null) params['note'] = note;
    if (account != null) params['account'] = account;
    if (toAccount != null) params['to_account'] = toAccount;
    if (tags != null && tags.isNotEmpty) params['tags'] = tags.join(',');
    if (date != null) params['date'] = date.toIso8601String();
    if (silent) params['silent'] = '1';

    final query = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    return '$scheme://add?$query';
  }
}
