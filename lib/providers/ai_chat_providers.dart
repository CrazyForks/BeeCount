import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../services/ai_chat_service.dart';
import '../providers.dart';
import '../data/db.dart';

/// AI 对话服务 Provider
final aiChatServiceProvider = Provider<AIChatService>((ref) {
  final db = ref.watch(databaseProvider);
  return AIChatService(db: db);
});

/// 当前对话 ID Provider
final currentConversationIdProvider = StateProvider<int?>((ref) => null);

/// 消息列表 Provider
final messagesProvider = StreamProvider.family<List<Message>, int>(
  (ref, conversationId) {
    final db = ref.watch(databaseProvider);
    return (db.select(db.messages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .watch();
  },
);
