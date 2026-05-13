part of 'sync_engine.dart';

/// 附件云端同步相关方法。
///
/// 包含上传 / 下载 / 本地磁盘清理 / 分类自定义图标上传等附件层 I/O 操作。
/// 这些方法不参与 sync 的高层编排,跟 push / pull / apply 解耦,所以独立成 part。
/// 主入口 [SyncEngine] 通过 extension 的方式承载,可以自由访问类的私有字段。
extension _SyncEngineAttachments on SyncEngine {
  /// 清掉某账本下所有附件的 cloudFileId / cloudSha256。
  /// 用于"远端账本被重建/清空"的场景：本地以为文件在云上，实际已失效，
  /// 重置后下次 uploadAttachments 会把它们当新的重新上传。
  Future<void> _resetAttachmentCloudRefs(int ledgerId) async {
    final txs = await (db.select(db.transactions)
          ..where((t) => t.ledgerId.equals(ledgerId)))
        .get();
    if (txs.isEmpty) return;
    final txIds = txs.map((t) => t.id).toList();
    final count = await (db.update(db.transactionAttachments)
          ..where((a) => a.transactionId.isIn(txIds)))
        .write(const TransactionAttachmentsCompanion(
      cloudFileId: d.Value(null),
      cloudSha256: d.Value(null),
    ));
    if (count > 0) {
      logger.info('SyncEngine', '已重置 $count 条附件的云端引用');
    }
  }

  /// 上传所有分类的自定义图标到云端，返回 categoryId → 云端引用 的映射。
  /// 分类的 customIconPath 是本地文件路径，单独上传后 serializeCategory 会把
  /// cloud 引用写进 payload 让 web 端能拉到。
  ///
  /// 走 user-global 的 `/attachments/category-icons/upload` endpoint,跟账本
  /// 解耦:相同 sha256 的图标全用户只上传 1 份(server 端按 user_id + sha256
  /// 去重),避免历史"每个账本各上传一份"的倍数膨胀。
  Future<Map<int, ({String fileId, String sha256})>>
      _uploadCategoryIcons() async {
    final categories = await db.select(db.categories).get();
    final out = <int, ({String fileId, String sha256})>{};
    final iconSvc = CustomIconService();
    for (final cat in categories) {
      if (cat.iconType != 'custom') continue;
      final rel = cat.customIconPath;
      if (rel == null || rel.isEmpty) continue;
      try {
        final abs = await iconSvc.resolveIconPath(rel);
        final file = File(abs);
        if (!file.existsSync()) {
          logger.debug('SyncEngine',
              '分类 ${cat.name} 的自定义图标文件不存在: $abs');
          continue;
        }
        final bytes = await file.readAsBytes();
        final result = await provider.uploadCategoryIcon(
          bytes: bytes,
          fileName: rel.split('/').last,
        );
        out[cat.id] = (fileId: result.fileId, sha256: result.sha256);
      } catch (e, st) {
        logger.error(
            'SyncEngine', '分类 ${cat.name} 自定义图标上传失败', e, st);
      }
    }
    if (out.isNotEmpty) {
      logger.info('SyncEngine', '分类自定义图标上传完成: ${out.length} 个');
    }
    return out;
  }

  /// 上传账本中未同步的附件到云端
  Future<int> uploadAttachments({required int ledgerId}) async {
    // 附件 upload 的 ledger_id 必须跟 push / snapshot 对齐用 `ledger.syncId`：
    // B 本地 int id（比如 2）在 server 的 ledgers 表里根本不存在（server 那边
    // external_id 是 A 当初推的 UUID/"5"），直接用会触发 "Ledger not found"。
    final ledgerRow = await (db.select(db.ledgers)
          ..where((l) => l.id.equals(ledgerId)))
        .getSingleOrNull();
    final serverLedgerId = ledgerRow?.syncId ?? ledgerId.toString();

    final txs = await (db.select(db.transactions)
          ..where((t) => t.ledgerId.equals(ledgerId)))
        .get();
    if (txs.isEmpty) return 0;

    final txIds = txs.map((t) => t.id).toList();
    final attachments = await (db.select(db.transactionAttachments)
          ..where((a) => a.transactionId.isIn(txIds)))
        .get();

    int uploaded = 0;
    for (final att in attachments) {
      if (att.cloudFileId != null) continue; // 已上传

      final localFile = await _getAttachmentFile(att.fileName);
      if (localFile == null || !localFile.existsSync()) {
        logger.debug('SyncEngine', '附件本地文件不存在，跳过: ${att.fileName}');
        continue;
      }

      try {
        final bytes = await localFile.readAsBytes();
        final result = await provider.uploadAttachment(
          ledgerId: serverLedgerId,
          bytes: bytes,
          fileName: att.originalName ?? att.fileName,
        );
        // 回填云端引用
        await (db.update(db.transactionAttachments)
              ..where((a) => a.id.equals(att.id)))
            .write(TransactionAttachmentsCompanion(
          cloudFileId: d.Value(result.fileId),
          cloudSha256: d.Value(result.sha256),
        ));
        uploaded++;
        logger.debug('SyncEngine', '附件上传成功: ${att.fileName} -> ${result.fileId}');
      } catch (e, st) {
        logger.error('SyncEngine', '附件上传失败: ${att.fileName}', e, st);
      }
    }

    if (uploaded > 0) {
      logger.info('SyncEngine', '附件上传完成: $uploaded 个');
    }
    return uploaded;
  }

  /// 下载云端附件到本地
  Future<int> downloadAttachments({required int ledgerId}) async {
    final txs = await (db.select(db.transactions)
          ..where((t) => t.ledgerId.equals(ledgerId)))
        .get();
    if (txs.isEmpty) return 0;

    final txIds = txs.map((t) => t.id).toList();
    final attachments = await (db.select(db.transactionAttachments)
          ..where((a) => a.transactionId.isIn(txIds)))
        .get();

    int downloaded = 0;
    for (final att in attachments) {
      if (att.cloudFileId == null) continue; // 没有云端引用

      final localFile = await _getAttachmentFile(att.fileName);
      if (localFile == null) continue;
      if (localFile.existsSync()) continue; // 本地已存在

      try {
        final bytes = await provider.downloadAttachment(
          fileId: att.cloudFileId!,
        );
        // 确保目录存在
        final dir = localFile.parent;
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
        await localFile.writeAsBytes(bytes);
        downloaded++;
        logger.debug('SyncEngine', '附件下载成功: ${att.cloudFileId} -> ${att.fileName}');
      } catch (e, st) {
        logger.error('SyncEngine', '附件下载失败: ${att.cloudFileId}', e, st);
      }
    }

    if (downloaded > 0) {
      logger.info('SyncEngine', '附件下载完成: $downloaded 个');
    }
    return downloaded;
  }

  /// 获取附件本地文件路径
  Future<File?> _getAttachmentFile(String fileName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final attachmentDir = Directory('${appDir.path}/attachments');
      return File('${attachmentDir.path}/$fileName');
    } catch (e) {
      logger.error('SyncEngine', '获取附件路径失败: $fileName', e);
      return null;
    }
  }

  /// 清理给定交易的本地磁盘附件(原图 + 缩略图)。在 transaction_attachments
  /// 行被 db.delete **之前** 调 —— 之后 fileName 就查不到了。
  ///
  /// 跟 `LocalTransactionRepository._deleteAttachmentsForTransaction` 几乎一样,
  /// 但那个是 private;这里是 sync pull 路径独立使用(不想走完整 repo 接口,
  /// 因为 repo 的 deleteTransaction 会 record changeTracker,会造成 pull →
  /// record → push 的回环)。失败只 warn 不抛,不 block 事件 apply。
  Future<void> _cleanupTxAttachmentFilesOnDisk(int transactionId) async {
    try {
      final attachments = await (db.select(db.transactionAttachments)
            ..where((a) => a.transactionId.equals(transactionId)))
          .get();
      if (attachments.isEmpty) return;

      final appDir = await getApplicationDocumentsDirectory();
      final attachmentDir = Directory('${appDir.path}/attachments');
      final cacheDir = await getTemporaryDirectory();
      final thumbDir = Directory('${cacheDir.path}/attachment_thumbs');

      for (final att in attachments) {
        final file = File('${attachmentDir.path}/${att.fileName}');
        if (await file.exists()) {
          try {
            await file.delete();
          } catch (e) {
            logger.warning('SyncEngine',
                'pull delete: unlink attachment failed ${att.fileName}: $e');
          }
        }
        final thumbName =
            '${p.basenameWithoutExtension(att.fileName)}_thumb.jpg';
        final thumbFile = File('${thumbDir.path}/$thumbName');
        if (await thumbFile.exists()) {
          try {
            await thumbFile.delete();
          } catch (_) {/* best effort */}
        }
      }
    } catch (e, st) {
      logger.warning(
          'SyncEngine', 'pull delete: 清理附件磁盘文件异常 tx=$transactionId: $e\n$st');
    }
  }

  /// 清理给定分类(含直接子分类)的本地自定义图标文件。
  /// 跟 LocalCategoryRepository 的 _deleteLocalIconFiles 对齐。删 categories
  /// 行之前调。best-effort。
  Future<void> _cleanupCategoryIconFilesOnDisk(List<int> categoryIds) async {
    if (categoryIds.isEmpty) return;
    try {
      final paths = <String>[];
      final selfRows = await (db.select(db.categories)
            ..where((c) => c.id.isIn(categoryIds)))
          .get();
      for (final r in selfRows) {
        final cp = r.customIconPath;
        if (cp != null && cp.trim().isNotEmpty) paths.add(cp);
      }
      final childRows = await (db.select(db.categories)
            ..where((c) => c.parentId.isIn(categoryIds)))
          .get();
      for (final r in childRows) {
        final cp = r.customIconPath;
        if (cp != null && cp.trim().isNotEmpty) paths.add(cp);
      }
      if (paths.isEmpty) return;

      final appDir = await getApplicationDocumentsDirectory();
      final iconDir = Directory('${appDir.path}/custom_icons');
      for (final rel in paths) {
        final fileName = p.basename(rel);
        final file = File('${iconDir.path}/$fileName');
        if (await file.exists()) {
          try {
            await file.delete();
          } catch (e) {
            logger.warning(
                'SyncEngine', 'pull delete: unlink custom icon failed $fileName: $e');
          }
        }
      }
    } catch (e, st) {
      logger.warning('SyncEngine', 'pull delete: 清理分类图标磁盘文件异常: $e\n$st');
    }
  }
}
