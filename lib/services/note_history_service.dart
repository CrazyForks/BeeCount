import 'package:shared_preferences/shared_preferences.dart';

/// 备注历史记录服务
/// 存储并提供最近使用的备注列表，用于快速输入
class NoteHistoryService {
  static const String _keyRecentNotes = 'recent_notes';
  static const int _maxHistoryCount = 20; // 最多保存20条

  /// 保存备注到历史记录
  static Future<void> saveNote(String note) async {
    // 去除前后空格
    final trimmedNote = note.trim();
    if (trimmedNote.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_keyRecentNotes) ?? [];

    // 如果已存在，先移除（移到最前面）
    history.remove(trimmedNote);

    // 添加到最前面
    history.insert(0, trimmedNote);

    // 限制数量
    if (history.length > _maxHistoryCount) {
      history.removeRange(_maxHistoryCount, history.length);
    }

    await prefs.setStringList(_keyRecentNotes, history);
  }

  /// 获取最近使用的备注列表
  /// [limit] 限制返回数量，默认10条
  static Future<List<String>> getRecentNotes({int limit = 10}) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_keyRecentNotes) ?? [];

    return history.take(limit).toList();
  }

  /// 清空历史记录
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRecentNotes);
  }
}
