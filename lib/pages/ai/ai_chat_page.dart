import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;

import '../../widgets/ui/ui.dart';
import '../../widgets/biz/bee_icon.dart';
import '../../widgets/ai/typewriter_text.dart';
import '../../widgets/ai/bill_card_widget.dart';
import '../../styles/tokens.dart';
import '../../utils/ui_scale_extensions.dart';
import '../../providers.dart';
import '../../providers/ai_chat_providers.dart';
import '../../ai/tasks/bill_extraction_task.dart';
import '../../pages/transaction/transaction_editor_page.dart';
import '../../data/db.dart';
import '../../l10n/app_localizations.dart';
import '../../services/avatar_service.dart';

/// AI 对话页面
class AIChatPage extends ConsumerStatefulWidget {
  const AIChatPage({super.key});

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends ConsumerState<AIChatPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int? _conversationId;
  bool _isLoading = false;
  int? _animatingMessageId; // 正在播放动画的消息ID
  String? _userAvatarPath; // 用户头像路径

  @override
  void initState() {
    super.initState();
    _initConversation();
    _loadUserAvatar();
  }

  Future<void> _loadUserAvatar() async {
    final path = await AvatarService.getAvatarPath();
    if (mounted) {
      setState(() {
        _userAvatarPath = path;
      });
    }
  }

  Future<void> _initConversation() async {
    final db = ref.read(databaseProvider);
    final ledgerId = ref.read(currentLedgerIdProvider);

    // 查找当前账本的活跃对话
    final conv = await (db.select(db.conversations)
          ..where((c) => c.ledgerId.equals(ledgerId))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)])
          ..limit(1))
        .getSingleOrNull();

    if (conv != null) {
      setState(() => _conversationId = conv.id);
    } else {
      // 创建新对话
      final id = await db.into(db.conversations).insert(
            ConversationsCompanion.insert(
              ledgerId: ledgerId,
              title: const Value('AI对话'),
              createdAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
            ),
          );
      setState(() => _conversationId = id);
    }

    ref.read(currentConversationIdProvider.notifier).state = _conversationId;
  }

  @override
  Widget build(BuildContext context) {
    if (_conversationId == null) {
      return Scaffold(
        backgroundColor: BeeTokens.scaffoldBackground(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final messagesAsync = ref.watch(messagesProvider(_conversationId!));

    return Scaffold(
      backgroundColor: BeeTokens.scaffoldBackground(context),
      body: Column(
        children: [
          // Header
          PrimaryHeader(
            title: AppLocalizations.of(context).aiChatTitle,
            showBack: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: AppLocalizations.of(context).aiChatClearHistory,
                onPressed: _showClearHistoryDialog,
              ),
            ],
          ),

          // 消息列表
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text('暂无消息'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0.scaled(context, ref),
                    vertical: 8.0.scaled(context, ref),
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(messages[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('加载失败: $e')),
            ),
          ),

          // 加载指示器
          if (_isLoading)
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 8.0.scaled(context, ref),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16.0.scaled(context, ref),
                    height: 16.0.scaled(context, ref),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ref.watch(primaryColorProvider),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0.scaled(context, ref)),
                  Text(
                    AppLocalizations.of(context).aiChatThinking,
                    style: TextStyle(
                      color: BeeTokens.textSecondary(context),
                      fontSize: 13.0.scaled(context, ref),
                    ),
                  ),
                ],
              ),
            ),

          // 输入区域
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isUser = message.role == 'user';

    // 只对正在播放动画的消息ID启用动画
    final shouldAnimate = !isUser && message.id == _animatingMessageId;

    // 记账卡片
    if (message.messageType == 'bill_card' && message.metadata != null) {
      final metadata = jsonDecode(message.metadata!) as Map<String, dynamic>;
      final isUndone = metadata['isUndone'] == true;
      final billInfo = BillInfo.fromJson(metadata['billInfo'] ?? metadata);

      return BillCardWidget(
        billInfo: billInfo,
        transactionId: message.transactionId,
        isUndone: isUndone,
        onUndo: message.transactionId != null && !isUndone
            ? () => _handleUndo(message.id, message.transactionId!)
            : null,
        onEdit: message.transactionId != null && !isUndone
            ? () => _handleEdit(message.transactionId!)
            : null,
      );
    }

    // 普通文字消息 - 带头像
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.scaled(context, ref)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // AI头像（左侧）
          if (!isUser) ...[
            _buildAIAvatar(),
            SizedBox(width: 8.0.scaled(context, ref)),
          ],
          // 消息气泡
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: isUser ? 60.0.scaled(context, ref) : 0,
                right: isUser ? 0 : 60.0.scaled(context, ref),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12.0.scaled(context, ref),
                vertical: 10.0.scaled(context, ref),
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? ref.watch(primaryColorProvider).withOpacity(0.1)
                    : BeeTokens.surface(context),
                borderRadius: BorderRadius.circular(12.0.scaled(context, ref)),
                border: Border.all(
                  color: isUser
                      ? ref.watch(primaryColorProvider).withOpacity(0.3)
                      : BeeTokens.border(context),
                ),
              ),
              child: TypewriterText(
                text: message.content,
                animate: shouldAnimate, // 只对标记的消息启用动画
                onComplete: shouldAnimate
                    ? () {
                        // 动画完成后清除标记
                        if (mounted) {
                          setState(() {
                            _animatingMessageId = null;
                          });
                        }
                      }
                    : null,
                style: TextStyle(
                  color: BeeTokens.textPrimary(context),
                  fontSize: 14.0.scaled(context, ref),
                  height: 1.5,
                ),
              ),
            ),
          ),
          // 用户头像（右侧，仅在有头像时显示）
          if (isUser && _userAvatarPath != null) ...[
            SizedBox(width: 8.0.scaled(context, ref)),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  // 构建AI头像
  Widget _buildAIAvatar() {
    return Container(
      width: 32.0.scaled(context, ref),
      height: 32.0.scaled(context, ref),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ref.watch(primaryColorProvider).withOpacity(0.3),
          width: 1.5,
        ),
        color: ref.watch(primaryColorProvider).withOpacity(0.1),
      ),
      child: Center(
        child: BeeIcon(
          color: ref.watch(primaryColorProvider),
          size: 18.0.scaled(context, ref),
        ),
      ),
    );
  }

  // 构建用户头像
  Widget _buildUserAvatar() {
    return Container(
      width: 32.0.scaled(context, ref),
      height: 32.0.scaled(context, ref),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: BeeTokens.border(context),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: Image.file(
          File(_userAvatarPath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // 加载失败时不显示
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16.0.scaled(context, ref)),
      decoration: BoxDecoration(
        color: BeeTokens.surface(context),
        border: Border(
          top: BorderSide(
            color: BeeTokens.divider(context),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).aiChatInputHint,
                  hintStyle: TextStyle(
                    color: BeeTokens.textTertiary(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0.scaled(context, ref)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: BeeTokens.scaffoldBackground(context),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0.scaled(context, ref),
                    vertical: 10.0.scaled(context, ref),
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                enabled: !_isLoading,
              ),
            ),
            SizedBox(width: 8.0.scaled(context, ref)),
            IconButton(
              icon: Icon(
                Icons.send,
                color: _isLoading
                    ? BeeTokens.textTertiary(context)
                    : ref.watch(primaryColorProvider),
              ),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;

    _inputController.clear();
    setState(() => _isLoading = true);

    try {
      final db = ref.read(databaseProvider);

      // 保存用户消息
      await db.into(db.messages).insert(
            MessagesCompanion.insert(
              conversationId: _conversationId!,
              role: 'user',
              content: text,
              messageType: 'text',
              createdAt: Value(DateTime.now()),
            ),
          );

      _scrollToBottom();

      // 获取分类列表
      final allCategories = await (db.select(db.categories)).get();
      final expenseCategories = allCategories.where((c) => c.kind == 'expense');
      final incomeCategories = allCategories.where((c) => c.kind == 'income');

      // 调用 AI 服务
      final chatService = ref.read(aiChatServiceProvider);
      final currentLocale = Localizations.localeOf(context);
      final response = await chatService.processMessage(
        text,
        expenseCategories: expenseCategories.map((c) => c.name).toList(),
        incomeCategories: incomeCategories.map((c) => c.name).toList(),
        languageCode: currentLocale.languageCode,
      );

      // 保存 AI 回复
      final messageId = await db.into(db.messages).insert(
            MessagesCompanion.insert(
              conversationId: _conversationId!,
              role: 'assistant',
              content: response.text,
              messageType: response.type,
              metadata: response.billInfo != null
                  ? Value(jsonEncode({
                      'billInfo': response.billInfo!.toJson(),
                      'isUndone': false,
                    }))
                  : const Value.absent(),
              transactionId: response.transactionId != null
                  ? Value(response.transactionId)
                  : const Value.absent(),
              createdAt: Value(DateTime.now()),
            ),
          );

      // 设置动画消息ID
      setState(() {
        _animatingMessageId = messageId;
      });

      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        showToast(context, '${AppLocalizations.of(context).aiChatSendFailed}: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients && mounted) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showClearHistoryDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.aiChatClearHistoryDialogTitle),
        content: Text(l10n.aiChatClearHistoryDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              _clearHistory();
              Navigator.pop(context);
            },
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  Future<void> _clearHistory() async {
    final db = ref.read(databaseProvider);
    await (db.delete(db.messages)
          ..where((m) => m.conversationId.equals(_conversationId!)))
        .go();

    if (mounted) {
      showToast(context, AppLocalizations.of(context).aiChatHistoryCleared);
    }
  }

  Future<void> _handleUndo(int messageId, int transactionId) async {
    final chatService = ref.read(aiChatServiceProvider);
    final success = await chatService.undoTransaction(transactionId);

    if (success) {
      // 更新消息的 metadata,标记为已撤销
      final db = ref.read(databaseProvider);
      final message = await (db.select(db.messages)
            ..where((m) => m.id.equals(messageId)))
          .getSingleOrNull();

      if (message != null && message.metadata != null) {
        final metadata = jsonDecode(message.metadata!) as Map<String, dynamic>;
        metadata['isUndone'] = true;
        // 保留 billInfo,添加 isUndone 标记
        final updatedMetadata = {
          'billInfo': metadata['billInfo'] ?? metadata,
          'isUndone': true,
        };

        await (db.update(db.messages)..where((m) => m.id.equals(messageId)))
            .write(MessagesCompanion(
          metadata: Value(jsonEncode(updatedMetadata)),
        ));
      }

      if (mounted) {
        showToast(context, AppLocalizations.of(context).aiChatUndone);
      }
    } else {
      if (mounted) {
        showToast(context, AppLocalizations.of(context).aiChatUndoFailed);
      }
    }
  }

  Future<void> _handleEdit(int transactionId) async {
    try {
      final db = ref.read(databaseProvider);
      final transaction = await (db.select(db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .getSingleOrNull();

      if (transaction == null) {
        if (mounted) {
          showToast(context, AppLocalizations.of(context).aiChatTransactionNotFound);
        }
        return;
      }

      if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TransactionEditorPage(
              initialKind: transaction.type,
              quickAdd: true,
              initialCategoryId: transaction.categoryId,
              initialAmount: transaction.amount,
              initialDate: transaction.happenedAt,
              initialNote: transaction.note,
              editingTransactionId: transaction.id,
              initialAccountId: transaction.accountId,
              initialToAccountId: transaction.toAccountId,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showToast(context, AppLocalizations.of(context).aiChatOpenEditorFailed);
      }
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
