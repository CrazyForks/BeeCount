import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 调试日志器 - 用于真机调试时写入文件
class DebugLogger {
  static Future<void> log(String message) async {
    // 打印到控制台
    print(message);

    // 同时写入文件
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/debug.log');
      final timestamp = DateTime.now().toString();
      await file.writeAsString('[$timestamp] $message\n', mode: FileMode.append);
    } catch (e) {
      print('❌ 写入日志文件失败: $e');
    }
  }

  /// 清空日志文件
  static Future<void> clear() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/debug.log');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('❌ 清空日志文件失败: $e');
    }
  }

  /// 读取日志文件内容
  static Future<String> read() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/debug.log');
      if (await file.exists()) {
        return await file.readAsString();
      }
      return '日志文件不存在';
    } catch (e) {
      return '读取日志失败: $e';
    }
  }
}
