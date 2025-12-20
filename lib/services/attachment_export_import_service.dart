import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/db.dart';
import '../providers.dart';
import 'attachment_service.dart';
import 'system/logger_service.dart';
import 'ui/avatar_service.dart';

/// 附件导出导入服务
/// 负责附件的打包导出和解压导入
class AttachmentExportImportService {
  final Ref ref;

  AttachmentExportImportService(this.ref);

  // ============================================
  // 导出功能
  // ============================================

  /// 导出所有附件为 tar.gz 文件
  /// 返回导出文件的路径
  Future<String?> exportAttachments({
    void Function(int current, int total)? onProgress,
  }) async {
    try {
      final repo = ref.read(repositoryProvider);
      final attachmentService = ref.read(attachmentServiceProvider);
      final attachmentDir = await attachmentService.getAttachmentDirectory();

      // 获取所有附件记录
      final allAttachments = await repo.getAllAttachments();

      // 检查头像
      final avatarPath = await AvatarService.getAvatarPath();
      String? avatarFileName;
      File? avatarFile;
      if (avatarPath != null) {
        avatarFile = File(avatarPath);
        if (await avatarFile.exists()) {
          avatarFileName = path.basename(avatarPath);
        } else {
          avatarFile = null;
        }
      }

      // 如果没有附件也没有头像，则无需导出
      if (allAttachments.isEmpty && avatarFile == null) {
        logger.info('AttachmentExportImport', '没有附件和头像需要导出');
        return null;
      }

      // 创建归档
      final archive = Archive();

      // 添加头像文件（如果存在）
      if (avatarFile != null && avatarFileName != null) {
        final bytes = await avatarFile.readAsBytes();
        archive.addFile(ArchiveFile(
          'avatar/$avatarFileName',
          bytes.length,
          bytes,
        ));
        logger.debug('AttachmentExportImport', '添加头像文件: $avatarFileName');
      }

      // 添加元数据文件（包含头像信息）
      final metadata = _buildMetadata(allAttachments, avatarFileName: avatarFileName);
      final metadataBytes = utf8.encode(jsonEncode(metadata));
      archive.addFile(ArchiveFile(
        'metadata.json',
        metadataBytes.length,
        metadataBytes,
      ));

      // 添加图片文件
      int processed = 0;
      final total = allAttachments.length;

      for (final attachment in allAttachments) {
        final filePath = '${attachmentDir.path}/${attachment.fileName}';
        final file = File(filePath);

        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          archive.addFile(ArchiveFile(
            'images/${attachment.fileName}',
            bytes.length,
            bytes,
          ));
        }

        processed++;
        onProgress?.call(processed, total);
      }

      // 压缩为 tar.gz
      final tarData = TarEncoder().encode(archive);
      final gzData = GZipEncoder().encode(tarData);

      if (gzData == null) {
        logger.error('AttachmentExportImport', 'GZip 压缩失败');
        return null;
      }

      // 保存到临时目录
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final exportDir = await _getExportDirectory();
      final exportPath = '${exportDir.path}/beecount_attachments_$timestamp.tar.gz';

      final exportFile = File(exportPath);
      await exportFile.writeAsBytes(gzData);

      logger.info('AttachmentExportImport', '附件导出完成: $exportPath');
      return exportPath;
    } catch (e, stackTrace) {
      logger.error('AttachmentExportImport', '导出附件失败', e, stackTrace);
      return null;
    }
  }

  /// 构建元数据
  Map<String, dynamic> _buildMetadata(List<TransactionAttachment> attachments, {String? avatarFileName}) {
    final metadata = <String, dynamic>{
      'version': 2, // 升级版本号以支持头像
      'exportedAt': DateTime.now().toIso8601String(),
      'count': attachments.length,
      'attachments': attachments.map((a) => {
        'id': a.id,
        'transactionId': a.transactionId,
        'fileName': a.fileName,
        'originalName': a.originalName,
        'fileSize': a.fileSize,
        'width': a.width,
        'height': a.height,
        'sortOrder': a.sortOrder,
        'createdAt': a.createdAt.toIso8601String(),
      }).toList(),
    };

    // 添加头像信息（如果存在）
    if (avatarFileName != null) {
      metadata['avatar'] = avatarFileName;
    }

    return metadata;
  }

  // ============================================
  // 导入功能
  // ============================================

  /// 冲突处理策略
  static const String conflictSkip = 'skip';
  static const String conflictOverwrite = 'overwrite';

  /// 导入附件
  /// [archivePath] tar.gz 文件路径
  /// [conflictStrategy] 冲突策略: 'skip' 或 'overwrite'
  /// 返回导入结果
  Future<AttachmentImportResult> importAttachments({
    required String archivePath,
    required String conflictStrategy,
    void Function(int current, int total)? onProgress,
  }) async {
    int imported = 0;
    int skipped = 0;
    int failed = 0;
    int overwritten = 0;

    try {
      final repo = ref.read(repositoryProvider);
      final attachmentService = ref.read(attachmentServiceProvider);
      final attachmentDir = await attachmentService.getAttachmentDirectory();

      // 读取归档文件
      final archiveFile = File(archivePath);
      if (!await archiveFile.exists()) {
        logger.error('AttachmentExportImport', '归档文件不存在: $archivePath');
        return AttachmentImportResult(
          success: false,
          imported: 0,
          skipped: 0,
          failed: 0,
          overwritten: 0,
          message: '归档文件不存在',
        );
      }

      final bytes = await archiveFile.readAsBytes();

      // 解压 gzip
      final tarData = GZipDecoder().decodeBytes(bytes);

      // 解析 tar
      final archive = TarDecoder().decodeBytes(tarData);

      // 查找元数据文件
      ArchiveFile? metadataFile;
      for (final file in archive) {
        if (file.name == 'metadata.json') {
          metadataFile = file;
          break;
        }
      }

      if (metadataFile == null) {
        logger.error('AttachmentExportImport', '归档中没有找到 metadata.json');
        return AttachmentImportResult(
          success: false,
          imported: 0,
          skipped: 0,
          failed: 0,
          overwritten: 0,
          message: '归档格式错误：缺少 metadata.json',
        );
      }

      // 解析元数据
      final metadataJson = utf8.decode(metadataFile.content as List<int>);
      final metadata = jsonDecode(metadataJson) as Map<String, dynamic>;
      final attachmentList = metadata['attachments'] as List<dynamic>;

      final total = attachmentList.length;
      int processed = 0;

      // 构建文件名到归档文件的映射
      final imageFiles = <String, ArchiveFile>{};
      for (final file in archive) {
        if (file.name.startsWith('images/')) {
          final fileName = path.basename(file.name);
          imageFiles[fileName] = file;
        }
      }

      // 处理每个附件
      for (final attachmentData in attachmentList) {
        final fileName = attachmentData['fileName'] as String;
        final transactionId = attachmentData['transactionId'] as int;

        try {
          // 注意：不检查交易是否存在，因为：
          // 1. 可能先导入附件，后导入交易数据
          // 2. 可能从远端恢复数据后再导入附件
          // 附件的 transactionId 仅作为元数据保存，后续可通过文件名匹配

          // 检查文件是否存在于归档中
          final imageFile = imageFiles[fileName];
          if (imageFile == null) {
            logger.warning('AttachmentExportImport', '归档中没有找到图片: $fileName');
            failed++;
            processed++;
            onProgress?.call(processed, total);
            continue;
          }

          // 检查本地是否已存在同名文件
          final localFilePath = '${attachmentDir.path}/$fileName';
          final localFile = File(localFilePath);
          final existsLocally = await localFile.exists();

          // 检查数据库中是否存在记录
          final existsInDb = await repo.attachmentExistsByFileName(fileName);

          if (existsLocally || existsInDb) {
            if (conflictStrategy == conflictSkip) {
              logger.debug('AttachmentExportImport', '跳过已存在的附件: $fileName');
              skipped++;
              processed++;
              onProgress?.call(processed, total);
              continue;
            } else {
              // 覆盖模式：删除旧文件和记录
              if (existsLocally) {
                await localFile.delete();
              }
              if (existsInDb) {
                await repo.deleteAttachmentByFileName(fileName);
              }
              overwritten++;
            }
          }

          // 保存图片文件
          await localFile.writeAsBytes(imageFile.content as List<int>);

          // 创建数据库记录
          await repo.createAttachment(
            transactionId: transactionId,
            fileName: fileName,
            originalName: attachmentData['originalName'] as String? ?? fileName,
            fileSize: attachmentData['fileSize'] as int? ?? imageFile.size,
            width: attachmentData['width'] as int?,
            height: attachmentData['height'] as int?,
            sortOrder: attachmentData['sortOrder'] as int? ?? 0,
          );

          imported++;
        } catch (e) {
          logger.error('AttachmentExportImport', '导入附件失败: $fileName', e);
          failed++;
        }

        processed++;
        onProgress?.call(processed, total);
      }

      // 处理头像导入（如果存在）
      bool avatarImported = false;
      final avatarFileName = metadata['avatar'] as String?;
      if (avatarFileName != null) {
        // 查找头像文件
        ArchiveFile? avatarFile;
        for (final file in archive) {
          if (file.name == 'avatar/$avatarFileName') {
            avatarFile = file;
            break;
          }
        }

        if (avatarFile != null) {
          try {
            // 获取应用文档目录
            final appDir = await getApplicationDocumentsDirectory();
            final avatarDir = Directory(path.join(appDir.path, 'avatars'));
            if (!await avatarDir.exists()) {
              await avatarDir.create(recursive: true);
            }

            // 检查是否需要覆盖
            final localAvatarPath = path.join(avatarDir.path, avatarFileName);
            final localAvatarFile = File(localAvatarPath);

            if (await localAvatarFile.exists()) {
              if (conflictStrategy == conflictOverwrite) {
                await localAvatarFile.delete();
              } else {
                logger.debug('AttachmentExportImport', '跳过已存在的头像: $avatarFileName');
              }
            }

            // 保存头像文件
            if (!await localAvatarFile.exists()) {
              await localAvatarFile.writeAsBytes(avatarFile.content as List<int>);

              // 更新 SharedPreferences 中的头像路径
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('user_avatar_path', 'avatars/$avatarFileName');

              avatarImported = true;
              logger.info('AttachmentExportImport', '头像已导入: $avatarFileName');
            }
          } catch (e) {
            logger.error('AttachmentExportImport', '导入头像失败: $avatarFileName', e);
          }
        }
      }

      logger.info('AttachmentExportImport',
          '附件导入完成: 导入 $imported, 跳过 $skipped, 覆盖 $overwritten, 失败 $failed${avatarImported ? ', 头像已导入' : ''}');

      return AttachmentImportResult(
        success: true,
        imported: imported,
        skipped: skipped,
        failed: failed,
        overwritten: overwritten,
        avatarImported: avatarImported,
        message: null,
      );
    } catch (e, stackTrace) {
      logger.error('AttachmentExportImport', '导入附件失败', e, stackTrace);
      return AttachmentImportResult(
        success: false,
        imported: imported,
        skipped: skipped,
        failed: failed,
        overwritten: overwritten,
        message: e.toString(),
      );
    }
  }

  /// 预览归档内容
  /// 返回归档中的元数据信息
  Future<AttachmentArchiveInfo?> previewArchive(String archivePath) async {
    try {
      final archiveFile = File(archivePath);
      if (!await archiveFile.exists()) {
        return null;
      }

      final bytes = await archiveFile.readAsBytes();
      final tarData = GZipDecoder().decodeBytes(bytes);
      final archive = TarDecoder().decodeBytes(tarData);

      // 查找元数据文件
      for (final file in archive) {
        if (file.name == 'metadata.json') {
          final metadataJson = utf8.decode(file.content as List<int>);
          final metadata = jsonDecode(metadataJson) as Map<String, dynamic>;

          return AttachmentArchiveInfo(
            version: metadata['version'] as int? ?? 1,
            exportedAt: DateTime.tryParse(metadata['exportedAt'] as String? ?? ''),
            count: metadata['count'] as int? ?? 0,
            fileSize: await archiveFile.length(),
            hasAvatar: metadata['avatar'] != null,
          );
        }
      }

      return null;
    } catch (e) {
      logger.error('AttachmentExportImport', '预览归档失败', e);
      return null;
    }
  }

  /// 获取导出目录
  Future<Directory> _getExportDirectory() async {
    if (Platform.isAndroid) {
      // Android: 使用公共下载目录
      final dir = Directory('/storage/emulated/0/Download/BeeCount');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return dir;
    } else {
      // iOS: 使用文档目录
      final docDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${docDir.path}/exports');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return dir;
    }
  }
}

/// 附件导入结果
class AttachmentImportResult {
  final bool success;
  final int imported;
  final int skipped;
  final int failed;
  final int overwritten;
  final bool avatarImported;
  final String? message;

  AttachmentImportResult({
    required this.success,
    required this.imported,
    required this.skipped,
    required this.failed,
    required this.overwritten,
    this.avatarImported = false,
    this.message,
  });
}

/// 归档信息
class AttachmentArchiveInfo {
  final int version;
  final DateTime? exportedAt;
  final int count;
  final int fileSize;
  final bool hasAvatar;

  AttachmentArchiveInfo({
    required this.version,
    this.exportedAt,
    required this.count,
    required this.fileSize,
    this.hasAvatar = false,
  });
}

/// Provider
final attachmentExportImportServiceProvider = Provider<AttachmentExportImportService>((ref) {
  return AttachmentExportImportService(ref);
});
