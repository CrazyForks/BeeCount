import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_cloud_sync/flutter_cloud_sync.dart' as fcs;

import '../data/db.dart';
import '../data/repository.dart';
import '../utils/logger.dart';
import 'sync_service.dart';
import 'transactions_json.dart';

/// 账本交易的云同步管理器
///
/// 使用 flutter_cloud_sync 包实现云同步，保留 BeeCount 特定的业务逻辑
class TransactionsSyncManager implements SyncService {
  final fcs.CloudServiceConfig config;
  final BeeDatabase db;
  final BeeRepository repo;

  fcs.CloudSyncManager<int>? _syncManager;
  fcs.CloudProvider? _provider;
  bool _isInitializing = false;
  bool _isInitialized = false;

  final Map<int, SyncStatus> _statusCache = {};
  final Map<int, DateTime> _recentLocalChangeAt = {};
  final Map<int, _RecentUpload> _recentUpload = {};

  TransactionsSyncManager({
    required this.config,
    required this.db,
    required this.repo,
  });

  /// 确保服务已初始化（延迟初始化）
  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;
    if (_isInitializing) {
      // 等待初始化完成
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return;
    }

    _isInitializing = true;
    try {
      await _initialize();
      _isInitialized = true;
    } finally {
      _isInitializing = false;
    }
  }

  /// 初始化 CloudProvider 和 SyncManager
  Future<void> _initialize() async {
    final services = await fcs.createCloudServices(config);
    _provider = services.provider;

    if (_provider == null) {
      throw StateError('Failed to create cloud provider for ${config.type}');
    }

    _syncManager = fcs.CloudSyncManager<int>(
      provider: _provider!,
      serializer: _TransactionSerializer(db),
      logger: fcs.CloudSyncLogger(onLog: (level, message) {
        switch (level) {
          case fcs.LogLevel.debug:
            logI('CloudSync', message);
            break;
          case fcs.LogLevel.info:
            logI('CloudSync', message);
            break;
          case fcs.LogLevel.warning:
            logW('CloudSync', message);
            break;
          case fcs.LogLevel.error:
            logE('CloudSync', message);
            break;
        }
      }),
    );
  }

  String _pathForLedger(int ledgerId) {
    return 'ledger_$ledgerId.json';
  }

  /// 获取本地最大发生时间（用于方向判断）
  DateTime? _getLocalUpdatedAt(int ledgerId) {
    // 优先使用最近修改时间
    final recentChange = _recentLocalChangeAt[ledgerId];
    if (recentChange != null) {
      return recentChange;
    }

    // TODO: 可以从数据库查询最大 happenedAt
    // 暂时返回 null，让包使用 count 判断
    return null;
  }

  @override
  Future<void> uploadCurrentLedger({required int ledgerId}) async {
    await _ensureInitialized();

    try {
      logI('CloudSync', '开始上传账本 $ledgerId');

      // 上传前先计算本地指纹（用于记录上传快照）
      String? localFp;
      int? localCount;
      try {
        final jsonStr = await exportTransactionsJson(db, ledgerId);
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        localFp = _contentFingerprintFromMap(map);
        localCount = (map['count'] as num?)?.toInt();
      } catch (e) {
        logW('CloudSync', '计算本地指纹失败: $e');
      }

      await _syncManager!.upload(
        data: ledgerId,
        path: _pathForLedger(ledgerId),
        metadata: {
          'version': '2',
          'uploadedAt': DateTime.now().toUtc().toIso8601String(),
          'ledgerId': ledgerId.toString(),
        },
      );

      // 记录近期上传，用于处理 CDN 缓存延迟
      if (localFp != null && localCount != null) {
        _recentUpload[ledgerId] = _RecentUpload(
          at: DateTime.now(),
          fp: localFp,
          count: localCount,
        );
        // 立即更新缓存为"已同步"状态
        _statusCache[ledgerId] = SyncStatus(
          diff: SyncDiff.inSync,
          localCount: localCount,
          localFingerprint: localFp,
          cloudCount: localCount,
          cloudFingerprint: localFp,
          cloudExportedAt: DateTime.now(),
        );
      } else {
        // 指纹计算失败，清除缓存等待下次查询
        _statusCache.remove(ledgerId);
      }

      // 清除本地变更标记
      _recentLocalChangeAt.remove(ledgerId);

      logI('CloudSync', '上传完成: $ledgerId');
    } catch (e, stack) {
      logE('CloudSync', '上传失败: $ledgerId', e);
      logE('CloudSync', '堆栈', stack);
      rethrow;
    }
  }

  @override
  Future<({int inserted, int skipped, int deletedDup})>
      downloadAndRestoreToCurrentLedger({required int ledgerId}) async {
    await _ensureInitialized();

    try {
      logI('CloudSync', '开始下载账本 $ledgerId');

      // 直接使用 storage 下载原始 JSON 字符串
      final jsonStr =
          await _provider!.storage.download(path: _pathForLedger(ledgerId));

      if (jsonStr == null) {
        logW('CloudSync', '云端备份不存在');
        return (inserted: 0, skipped: 0, deletedDup: 0);
      }

      // 导入数据
      final result = await importTransactionsJson(repo, ledgerId, jsonStr);

      // 二次去重
      final deletedDup = await repo.deduplicateLedgerTransactions(ledgerId);

      logI('CloudSync',
          '下载完成: inserted=${result.inserted}, skipped=${result.skipped}, deletedDup=$deletedDup');

      // 清除缓存
      _statusCache.remove(ledgerId);
      _recentLocalChangeAt.remove(ledgerId);
      _recentUpload.remove(ledgerId);

      return (
        inserted: result.inserted,
        skipped: result.skipped,
        deletedDup: deletedDup,
      );
    } catch (e, stack) {
      logE('CloudSync', '下载失败: $ledgerId', e);
      logE('CloudSync', '堆栈', stack);

      // 如果是 404,返回空结果
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        return (inserted: 0, skipped: 0, deletedDup: 0);
      }

      rethrow;
    }
  }

  @override
  Future<SyncStatus> getStatus({required int ledgerId}) async {
    await _ensureInitialized();

    // 检查缓存
    final cached = _statusCache[ledgerId];
    if (cached != null) {
      return cached;
    }

    try {
      // 计算本地指纹
      final jsonStr = await exportTransactionsJson(db, ledgerId);
      final localMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      final localFp = _contentFingerprintFromMap(localMap);
      final localCount = (localMap['count'] as num).toInt();

      // 若刚刚上传成功且在短时间窗口内（15秒），且本地指纹与上传时一致，直接认定已同步
      final ru = _recentUpload[ledgerId];
      if (ru != null) {
        final age = DateTime.now().difference(ru.at);
        if (age < const Duration(seconds: 15) && ru.fp == localFp) {
          final st = SyncStatus(
            diff: SyncDiff.inSync,
            localCount: localCount,
            localFingerprint: localFp,
            cloudCount: ru.count,
            cloudFingerprint: ru.fp,
            cloudExportedAt: ru.at,
          );
          _statusCache[ledgerId] = st;
          logI('CloudSync', '使用近期上传缓存: $ledgerId -> 已同步');
          return st;
        }
      }

      logI('CloudSync', '获取同步状态: $ledgerId');

      // 调用包的 getStatus，传入时间戳用于方向判断
      final fcsStatus = await _syncManager!.getStatus(
        data: ledgerId,
        path: _pathForLedger(ledgerId),
        localUpdatedAt: _getLocalUpdatedAt(ledgerId),
      );

      // 转换包的 SyncStatus 为 BeeCount 的 SyncStatus
      final status = _convertSyncStatus(fcsStatus);

      _statusCache[ledgerId] = status;
      logI('CloudSync', '同步状态: $ledgerId -> ${status.diff}');

      return status;
    } catch (e, stack) {
      logE('CloudSync', '获取状态失败: $ledgerId', e);
      logE('CloudSync', '堆栈: $stack', null);

      // 返回错误状态
      final status = SyncStatus(
        diff: SyncDiff.error,
        localCount: 0,
        localFingerprint: '',
        message: e.toString(),
      );

      _statusCache[ledgerId] = status;

      return status;
    }
  }

  /// 转换包的 SyncStatus 为 BeeCount 的 SyncStatus
  SyncStatus _convertSyncStatus(fcs.SyncStatus fcsStatus) {
    SyncDiff diff;

    switch (fcsStatus.state) {
      case fcs.SyncState.notConfigured:
        diff = SyncDiff.notConfigured;
        break;
      case fcs.SyncState.notAuthenticated:
        diff = SyncDiff.notLoggedIn;
        break;
      case fcs.SyncState.localOnly:
        diff = SyncDiff.noRemote;
        break;
      case fcs.SyncState.synced:
        diff = SyncDiff.inSync;
        break;
      case fcs.SyncState.outOfSync:
        // 根据方向确定
        if (fcsStatus.direction == fcs.SyncDirection.localNewer) {
          diff = SyncDiff.localNewer;
        } else if (fcsStatus.direction == fcs.SyncDirection.cloudNewer) {
          diff = SyncDiff.cloudNewer;
        } else {
          diff = SyncDiff.different;
        }
        break;
      case fcs.SyncState.error:
        diff = SyncDiff.error;
        break;
      default:
        diff = SyncDiff.different;
    }

    return SyncStatus(
      diff: diff,
      localCount: fcsStatus.localCount ?? 0,
      cloudCount: fcsStatus.cloudCount,
      localFingerprint: fcsStatus.localFingerprint ?? '',
      cloudFingerprint: fcsStatus.cloudFingerprint,
      cloudExportedAt: fcsStatus.cloudUpdatedAt,
      message: fcsStatus.message,
    );
  }

  @override
  Future<({String? fingerprint, int? count, DateTime? exportedAt})>
      refreshCloudFingerprint({required int ledgerId}) async {
    await _ensureInitialized();

    try {
      logI('CloudSync', '刷新云端指纹: $ledgerId');

      // 强制刷新状态
      final status = await _syncManager!.getStatus(
        data: ledgerId,
        path: _pathForLedger(ledgerId),
        localUpdatedAt: _getLocalUpdatedAt(ledgerId),
        forceRefresh: true,
      );

      // 清除缓存以便下次 getStatus 重新获取
      _statusCache.remove(ledgerId);

      logI('CloudSync',
          '云端指纹: 指纹=${status.cloudFingerprint} 条数=${status.cloudCount} 时间=${status.cloudUpdatedAt}');

      return (
        fingerprint: status.cloudFingerprint,
        count: status.cloudCount,
        exportedAt: status.cloudUpdatedAt,
      );
    } catch (e) {
      logW('CloudSync', '刷新云端指纹失败: $ledgerId - $e');
      return (fingerprint: null, count: null, exportedAt: null);
    }
  }

  @override
  void markLocalChanged({required int ledgerId}) {
    _statusCache.remove(ledgerId);
    _recentLocalChangeAt[ledgerId] = DateTime.now();
    logI('CloudSync', '标记本地变更: $ledgerId');
  }

  /// 从 JSON payload 计算内容指纹（与旧实现保持一致）
  String _contentFingerprintFromMap(Map<String, dynamic> payload) {
    final items = (payload['items'] as List).cast<Map<String, dynamic>>();
    final canon = items
        .map((it) => {
              // 固定键顺序，填默认值，避免 null/缺键差异
              'happenedAt': it['happenedAt'] as String? ?? '',
              'type': it['type'] as String? ?? '',
              'amount': (it['amount'] as num?)?.toString() ?? '0',
              'categoryName': it['categoryName'] as String? ?? '',
              'categoryKind': it['categoryKind'] as String? ?? '',
              'note': it['note'] as String? ?? '',
            })
        .toList();
    canon.sort((a, b) {
      final c1 =
          (a['happenedAt'] as String).compareTo(b['happenedAt'] as String);
      if (c1 != 0) return c1;
      final c2 = (a['type'] as String).compareTo(b['type'] as String);
      if (c2 != 0) return c2;
      final c3 = (a['amount'] as String).compareTo(b['amount'] as String);
      if (c3 != 0) return c3;
      final c4 =
          (a['categoryName'] as String).compareTo(b['categoryName'] as String);
      if (c4 != 0) return c4;
      final c5 =
          (a['categoryKind'] as String).compareTo(b['categoryKind'] as String);
      if (c5 != 0) return c5;
      return (a['note'] as String).compareTo(b['note'] as String);
    });
    final bytes = utf8.encode(jsonEncode(canon));
    return sha256.convert(bytes).toString();
  }

  @override
  Future<void> deleteRemoteBackup({required int ledgerId}) async {
    await _ensureInitialized();

    try {
      logI('CloudSync', '删除云端备份: $ledgerId');

      await _syncManager!.deleteRemote(path: _pathForLedger(ledgerId));

      // 清除缓存
      _statusCache.remove(ledgerId);
      _recentLocalChangeAt.remove(ledgerId);
      _recentUpload.remove(ledgerId);

      logI('CloudSync', '删除完成: $ledgerId');
    } catch (e) {
      // 忽略 404 错误
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        logW('CloudSync', '云端备份不存在（忽略）: $ledgerId');
        return;
      }

      logE('CloudSync', '删除失败: $ledgerId', e);
      rethrow;
    }
  }
}

/// 账本交易数据序列化器
class _TransactionSerializer implements fcs.DataSerializer<int> {
  final BeeDatabase db;

  _TransactionSerializer(this.db);

  @override
  Future<String> serialize(int ledgerId) async {
    return await exportTransactionsJson(db, ledgerId);
  }

  @override
  Future<int> deserialize(String data) async {
    final json = jsonDecode(data) as Map<String, dynamic>;
    return json['ledgerId'] as int;
  }

  @override
  String fingerprint(String data) {
    final json = jsonDecode(data) as Map<String, dynamic>;
    return _contentFingerprintFromMap(json);
  }

  /// 从 payload 计算内容指纹（与原实现保持一致）
  String _contentFingerprintFromMap(Map<String, dynamic> payload) {
    final items = (payload['items'] as List).cast<Map<String, dynamic>>();
    final canon = items
        .map((it) => {
              // 固定键顺序，填默认值，避免 null/缺键差异
              'happenedAt': it['happenedAt'] as String? ?? '',
              'type': it['type'] as String? ?? '',
              'amount': (it['amount'] as num?)?.toString() ?? '0',
              'categoryName': it['categoryName'] as String? ?? '',
              'categoryKind': it['categoryKind'] as String? ?? '',
              'note': it['note'] as String? ?? '',
            })
        .toList();
    canon.sort((a, b) {
      final c1 =
          (a['happenedAt'] as String).compareTo(b['happenedAt'] as String);
      if (c1 != 0) return c1;
      final c2 = (a['type'] as String).compareTo(b['type'] as String);
      if (c2 != 0) return c2;
      final c3 = (a['amount'] as String).compareTo(b['amount'] as String);
      if (c3 != 0) return c3;
      final c4 =
          (a['categoryName'] as String).compareTo(b['categoryName'] as String);
      if (c4 != 0) return c4;
      final c5 =
          (a['categoryKind'] as String).compareTo(b['categoryKind'] as String);
      if (c5 != 0) return c5;
      return (a['note'] as String).compareTo(b['note'] as String);
    });
    final bytes = utf8.encode(jsonEncode(canon));
    return sha256.convert(bytes).toString();
  }
}

/// 近期上传记录（用于处理 CDN 缓存延迟）
class _RecentUpload {
  final DateTime at;
  final String fp;
  final int count;

  _RecentUpload({
    required this.at,
    required this.fp,
    required this.count,
  });
}
