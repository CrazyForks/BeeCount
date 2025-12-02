import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

/// 头像管理服务
class AvatarService {
  static const String _avatarPathKey = 'user_avatar_path';

  /// 获取用户头像路径
  static Future<String?> getAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarPathKey);
  }

  /// 选择并保存头像
  static Future<String?> pickAndSaveAvatar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image == null) return null;

    // 删除旧头像（如果存在）
    await _deleteOldAvatar();

    // 获取应用文档目录
    final appDir = await getApplicationDocumentsDirectory();
    final avatarDir = Directory(p.join(appDir.path, 'avatars'));
    if (!await avatarDir.exists()) {
      await avatarDir.create(recursive: true);
    }

    // 生成新文件名（使用时间戳避免缓存问题）
    final ext = p.extension(image.path);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newPath = p.join(avatarDir.path, 'avatar_$timestamp$ext');

    // 复制文件
    final file = File(image.path);
    await file.copy(newPath);

    // 保存路径到SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarPathKey, newPath);

    return newPath;
  }

  /// 拍照并保存头像
  static Future<String?> takePhotoAndSaveAvatar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image == null) return null;

    // 删除旧头像（如果存在）
    await _deleteOldAvatar();

    // 获取应用文档目录
    final appDir = await getApplicationDocumentsDirectory();
    final avatarDir = Directory(p.join(appDir.path, 'avatars'));
    if (!await avatarDir.exists()) {
      await avatarDir.create(recursive: true);
    }

    // 生成新文件名（使用时间戳避免缓存问题）
    final ext = p.extension(image.path);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newPath = p.join(avatarDir.path, 'avatar_$timestamp$ext');

    // 复制文件
    final file = File(image.path);
    await file.copy(newPath);

    // 保存路径到SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarPathKey, newPath);

    return newPath;
  }

  /// 删除头像
  static Future<void> deleteAvatar() async {
    await _deleteOldAvatar();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_avatarPathKey);
  }

  /// 删除旧头像文件（内部方法）
  static Future<void> _deleteOldAvatar() async {
    final avatarPath = await getAvatarPath();
    if (avatarPath != null) {
      final file = File(avatarPath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
