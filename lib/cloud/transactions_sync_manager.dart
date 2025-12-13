import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_cloud_sync/flutter_cloud_sync.dart' as fcs;

import '../data/db.dart';
import '../data/repositories/base_repository.dart';
import '../models/ledger_display_item.dart';
import '../services/system/logger_service.dart';
import 'sync_service.dart';
import 'transactions_json.dart';

/// 账本交易的云同步管理器
///
/// 使用 flutter_cloud_sync 包实现云同步，保留 BeeCount 特定的业务逻辑
class TransactionsSyncManager implements SyncService {
  final fcs.CloudServiceConfig config;
  final BeeDatabase db;
  final BaseRepository repo;

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
      // Provider 创建失败（如 iCloud 未登录），标记为已初始化但无法使用
      logger.warning('CloudSync', 'Provider not available for ${config.type}');
      return;
    }

    _syncManager = fcs.CloudSyncManager<int>(
      provider: _provider!,
      serializer: _TransactionSerializer(db),
      logger: fcs.CloudSyncLogger(onLog: (level, message) {
        switch (level) {
          case fcs.LogLevel.debug:
            logger.info('CloudSync', message);
            break;
          case fcs.LogLevel.info:
            logger.info('CloudSync', message);
            break;
          case fcs.LogLevel.warning:
            logger.warning('CloudSync', message);
            break;
          case fcs.LogLevel.error:
            logger.error('CloudSync', message);
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

    if (_syncManager == null) {
      throw fcs.CloudSyncException('云服务不可用，请检查配置或登录状态');
    }

    try {
      logger.info('CloudSync', '开始上传账本 $ledgerId');

      // 上传前先计算本地指纹（用于记录上传快照）
      String? localFp;
      int? localCount;
      try {
        final jsonStr = await exportTransactionsJson(db, ledgerId);
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        localFp = _contentFingerprintFromMap(map);
        localCount = (map['count'] as num?)?.toInt();
      } catch (e) {
        logger.warning('CloudSync', '计算本地指纹失败: $e');
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

      logger.info('CloudSync', '上传完成: $ledgerId');
    } catch (e, stack) {
      logger.error('CloudSync', '上传失败: $ledgerId', e);
      logger.error('CloudSync', '堆栈', stack);
      rethrow;
    }
  }

  @override
  Future<({int inserted, int deletedDup})>
      downloadAndRestoreToCurrentLedger({required int ledgerId}) async {
    await _ensureInitialized();

    if (_provider == null) {
      throw fcs.CloudSyncException('云服务不可用，请检查配置或登录状态');
    }

    try {
      logger.info('CloudSync', '开始下载账本 $ledgerId');

      // 直接使用 storage 下载原始 JSON 字符串
      final jsonStr =
          await _provider!.storage.download(path: _pathForLedger(ledgerId));

      if (jsonStr == null) {
        logger.warning('CloudSync', '云端备份不存在');
        return (inserted: 0, deletedDup: 0);
      }

      // 导入数据
      final result = await importTransactionsJson(repo, ledgerId, jsonStr);

      logger.info('CloudSync',
          '下载完成: inserted=${result.inserted}');

      // 清除缓存
      _statusCache.remove(ledgerId);
      _recentLocalChangeAt.remove(ledgerId);
      _recentUpload.remove(ledgerId);

      return (
        inserted: result.inserted,
        deletedDup: 0,
      );
    } catch (e, stack) {
      logger.error('CloudSync', '下载失败: $ledgerId', e);
      logger.error('CloudSync', '堆栈', stack);

      // 如果是 404,返回空结果
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        return (inserted: 0, deletedDup: 0);
      }

      rethrow;
    }
  }

  @override
  Future<SyncStatus> getStatus({required int ledgerId}) async {
    await _ensureInitialized();

    // 如果 provider 不可用，返回未登录状态
    if (_syncManager == null || _provider == null) {
      return SyncStatus(
        diff: SyncDiff.notLoggedIn,
        localCount: 0,
        localFingerprint: '',
        message: '云服务不可用，请检查配置或登录状态',
      );
    }

    // 检查缓存
    final cached = _statusCache[ledgerId];
    if (cached != null) {
      print('🟡 [getStatus] 缓存命中: ledgerId=$ledgerId, diff=${cached.diff}');
      return cached;
    }

    print('🟡 [getStatus] 缓存未命中，开始计算: ledgerId=$ledgerId');

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
          logger.info('CloudSync', '使用近期上传缓存: $ledgerId -> 已同步');
          return st;
        }
      }

      logger.info('CloudSync', '获取同步状态: $ledgerId');

      // 调用包的 getStatus，传入时间戳用于方向判断
      final fcsStatus = await _syncManager!.getStatus(
          data: ledgerId,
          path: _pathForLedger(ledgerId),
          localUpdatedAt: _getLocalUpdatedAt(ledgerId),
          forceRefresh: true);

      // 转换包的 SyncStatus 为 BeeCount 的 SyncStatus
      final status = _convertSyncStatus(fcsStatus);

      _statusCache[ledgerId] = status;
      logger.info('CloudSync', '同步状态: $ledgerId -> ${status.diff}');

      return status;
    } catch (e, stack) {
      logger.error('CloudSync', '获取状态失败: $ledgerId', e);
      logger.error('CloudSync', '堆栈: $stack', null);

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
      logger.info('CloudSync', '刷新云端指纹: $ledgerId');

      // 强制刷新状态
      final status = await _syncManager!.getStatus(
        data: ledgerId,
        path: _pathForLedger(ledgerId),
        localUpdatedAt: _getLocalUpdatedAt(ledgerId),
        forceRefresh: true,
      );

      // 清除缓存以便下次 getStatus 重新获取
      _statusCache.remove(ledgerId);

      logger.info('CloudSync',
          '云端指纹: 指纹=${status.cloudFingerprint} 条数=${status.cloudCount} 时间=${status.cloudUpdatedAt}');

      return (
        fingerprint: status.cloudFingerprint,
        count: status.cloudCount,
        exportedAt: status.cloudUpdatedAt,
      );
    } catch (e) {
      logger.warning('CloudSync', '刷新云端指纹失败: $ledgerId - $e');
      return (fingerprint: null, count: null, exportedAt: null);
    }
  }

  @override
  void markLocalChanged({required int ledgerId}) {
    _statusCache.remove(ledgerId);
    _recentLocalChangeAt[ledgerId] = DateTime.now();
    logger.info('CloudSync', '标记本地变更: $ledgerId');
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

    if (_syncManager == null) {
      throw fcs.CloudSyncException('云服务不可用，请检查配置或登录状态');
    }

    try {
      logger.info('CloudSync', '删除云端备份: $ledgerId');

      await _syncManager!.deleteRemote(path: _pathForLedger(ledgerId));

      // 清除缓存
      _statusCache.remove(ledgerId);
      _recentLocalChangeAt.remove(ledgerId);
      _recentUpload.remove(ledgerId);

      logger.info('CloudSync', '删除完成: $ledgerId');
    } catch (e) {
      // 忽略 404 错误
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        logger.warning('CloudSync', '云端备份不存在（忽略）: $ledgerId');
        return;
      }

      logger.error('CloudSync', '删除失败: $ledgerId', e);
      rethrow;
    }
  }

  /// 获取本地账本列表
  Future<List<LedgerDisplayItem>> getLocalLedgers({bool accountFeatureEnabled = true}) async {
    await _ensureInitialized();

    final localLedgers = await db.select(db.ledgers).get();
    final result = <LedgerDisplayItem>[];

    for (final ledger in localLedgers) {
      // 使用 getLedgerStats 一次性获取余额和交易数，内部会自动查询 transactions
      final stats = await repo.getLedgerStats(
        ledgerId: ledger.id,
        accountFeatureEnabled: accountFeatureEnabled,
      );

      result.add(LedgerDisplayItem.fromLocal(
        id: ledger.id,
        name: ledger.name,
        currency: ledger.currency,
        createdAt: ledger.createdAt,
        transactionCount: stats.transactionCount,
        balance: stats.balance,
      ));
    }

    logger.info('CloudSync', '已加载本地账本: ${result.length} 个');
    return result;
  }

  /// 获取远程账本列表（仅云端，不在本地）
  Future<List<LedgerDisplayItem>> getRemoteLedgers() async {
    await _ensureInitialized();

    // 获取本地账本ID列表（用于过滤）
    final localLedgers = await db.select(db.ledgers).get();
    final localLedgerIds = localLedgers.map((l) => l.id).toSet();

    final result = <LedgerDisplayItem>[];

    // 直接从云端文件列表获取远程账本
    try {
      final files = await _provider!.storage.list(path: '');
      logger.info('CloudSync', '云端文件列表: ${files.map((f) => f.name).toList()}');
      int remoteCount = 0;

      for (final file in files) {
        try {
          // 只处理 ledger_*.json 文件
          final fileName = file.name;
          if (!fileName.startsWith('ledger_') || !fileName.endsWith('.json')) {
            continue;
          }

          // 从文件名提取账本ID
          final idStr =
              fileName.replaceAll('ledger_', '').replaceAll('.json', '');
          final remoteId = int.tryParse(idStr);
          if (remoteId == null) continue;

          // 如果本地已存在，跳过
          if (localLedgerIds.contains(remoteId)) continue;

          // 下载文件获取账本元数据（使用 file.name 而非 file.path，避免路径重复）
          logger.info('CloudSync',
              '尝试下载远程账本: file.name=${file.name}, file.path=${file.path}');
          final jsonStr = await _provider!.storage.download(path: file.name);
          if (jsonStr == null) {
            logger.warning('CloudSync', '下载结果为空: ${file.name}');
            continue;
          }

          final json = jsonDecode(jsonStr) as Map<String, dynamic>;
          final name = json['ledgerName'] as String? ??
              json['name'] as String? ??
              'Unknown';
          final currency = json['currency'] as String? ?? 'CNY';
          final updatedAtStr = json['exportedAt'] as String?;
          final transactionCount = json['count'] as int? ?? 0;

          // 优先使用 balance 字段，没有则从 items 计算
          double balance;
          if (json.containsKey('balance')) {
            balance = (json['balance'] as num?)?.toDouble() ?? 0.0;
          } else {
            balance = 0.0;
            final items =
                (json['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
            for (final item in items) {
              final type = item['type'] as String?;
              final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
              if (type == 'income') {
                balance += amount;
              } else if (type == 'expense') {
                balance -= amount;
              }
            }
          }

          DateTime updatedAt;
          try {
            updatedAt = DateTime.parse(updatedAtStr ?? '');
          } catch (_) {
            updatedAt = DateTime.now();
          }

          result.add(LedgerDisplayItem.fromRemote(
            remoteId: remoteId,
            name: name,
            currency: currency,
            updatedAt: updatedAt,
            transactionCount: transactionCount,
            balance: balance,
          ));

          remoteCount++;
        } catch (e) {
          logger.warning('CloudSync', '解析远程账本文件失败: ${file.name} - $e');
          continue;
        }
      }

      logger.info('CloudSync', '已加载远程账本: $remoteCount 个');
    } catch (e) {
      logger.warning('CloudSync', '获取远程账本失败: $e');
      // 失败不影响，返回空列表
    }

    return result;
  }

  /// 获取所有账本（本地 + 云端）
  Future<List<LedgerDisplayItem>> getAllLedgers() async {
    await _ensureInitialized();

    // 并行获取本地和远程账本
    final results = await Future.wait([
      getLocalLedgers(),
      getRemoteLedgers(),
    ]);

    final localLedgers = results[0];
    final remoteLedgers = results[1];

    // 组合结果
    final allLedgers = [...localLedgers, ...remoteLedgers];

    logger.info('CloudSync', '已加载所有账本: 本地=${localLedgers.length}, 远程=${remoteLedgers.length}, 总计=${allLedgers.length}');

    return allLedgers;
  }

  /// 刷新所有账本的同步状态（后台预热缓存）
  Future<void> refreshAllLedgersStatus() async {
    await _ensureInitialized();

    try {
      final ledgers = await db.select(db.ledgers).get();

      for (final ledger in ledgers) {
        try {
          await getStatus(ledgerId: ledger.id);
        } catch (e) {
          logger.warning('CloudSync', '刷新账本 ${ledger.id} 状态失败: $e');
        }
      }

      logger.info('CloudSync', '已刷新 ${ledgers.length} 个账本的同步状态');
    } catch (e) {
      logger.error('CloudSync', '刷新所有账本状态失败', e);
    }
  }

  /// 下载远程账本（创建新的本地账本）
  ///
  /// 如果本地不存在远程账本的 ID，则复用远程 ID
  /// 如果本地已存在该 ID，则创建新 ID
  Future<int?> downloadRemoteLedger({
    required String name,
    required String currency,
    required String remotePath,
  }) async {
    await _ensureInitialized();

    try {
      logger.info('CloudSync', '下载远程账本: $remotePath');

      // 从远程路径提取账本ID
      final remoteIdStr =
          remotePath.replaceAll('ledger_', '').replaceAll('.json', '');
      final remoteId = int.tryParse(remoteIdStr);

      // 检查本地是否已存在该 ID
      final existingLedger = remoteId != null
          ? await (db.select(db.ledgers)..where((t) => t.id.equals(remoteId)))
              .getSingleOrNull()
          : null;

      final int ledgerId;
      final bool reuseRemoteId = remoteId != null && existingLedger == null;

      if (reuseRemoteId) {
        // 复用远程 ID
        logger.info('CloudSync', '复用远程ID: $remoteId');
        await db.into(db.ledgers).insert(
              LedgersCompanion.insert(
                id: drift.Value(remoteId),
                name: name,
                currency: drift.Value(currency),
              ),
            );
        ledgerId = remoteId;
      } else {
        // 创建新 ID（自动递增）
        logger.info('CloudSync', '本地ID冲突或无效，创建新ID');
        ledgerId = await db.into(db.ledgers).insert(
              LedgersCompanion.insert(
                name: name,
                currency: drift.Value(currency),
              ),
            );
      }

      // 下载数据
      final jsonStr = await _provider!.storage.download(path: remotePath);

      if (jsonStr == null) {
        logger.warning('CloudSync', '云端账本不存在: $remotePath');
        // 删除刚创建的空账本
        await (db.delete(db.ledgers)..where((t) => t.id.equals(ledgerId))).go();
        return null;
      }

      // 导入数据
      final result = await importTransactionsJson(repo, ledgerId, jsonStr);

      logger.info('CloudSync',
          '下载完成: ledgerId=$ledgerId, inserted=${result.inserted}');

      // 删除旧的远程文件（只有在 ID 改变时才需要删除旧文件并上传新文件）
      if (reuseRemoteId) {
        // 复用了远程ID，无需删除和重新上传
        logger.info('CloudSync', '复用远程ID，无需更新云端文件');
      } else {
        // ID 改变了，需要删除旧文件并上传新文件
        try {
          await _provider!.storage.delete(path: remotePath);
          logger.info('CloudSync', '旧远程文件已删除: $remotePath');
        } catch (e) {
          logger.warning('CloudSync', '删除旧远程文件失败（忽略）: $e');
        }
      }

      // 上传新创建的本地账本到云端
      try {
        await uploadCurrentLedger(ledgerId: ledgerId);
        logger.info('CloudSync', '新账本已上传到云端: ledger_$ledgerId.json');
      } catch (e) {
        logger.warning('CloudSync', '上传新账本失败（忽略）: $e');
      }

      return ledgerId;
    } catch (e, stack) {
      logger.error('CloudSync', '下载远程账本失败: $remotePath', e);
      logger.error('CloudSync', '堆栈', stack);
      rethrow;
    }
  }

  /// 删除远程账本（仅云端）
  Future<void> deleteRemoteLedger({required String remotePath}) async {
    await _ensureInitialized();

    try {
      logger.info('CloudSync', '删除远程账本: $remotePath');

      await _provider!.storage.delete(path: remotePath);

      logger.info('CloudSync', '删除完成: $remotePath');
    } catch (e) {
      // 忽略 404 错误
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        logger.warning('CloudSync', '远程账本不存在（忽略）: $remotePath');
        return;
      }

      logger.error('CloudSync', '删除远程账本失败: $remotePath', e);
      rethrow;
    }
  }

  /// 恢复所有远程账本到本地（并行执行）
  Future<({int success, int failed})> restoreAllRemoteLedgers() async {
    await _ensureInitialized();

    try {
      logger.info('CloudSync', '开始恢复所有远程账本');

      // 获取本地已存在的账本ID
      final localLedgers = await db.select(db.ledgers).get();
      final localLedgerIds = localLedgers.map((l) => l.id).toSet();
      logger.info('CloudSync', '本地已存在账本: $localLedgerIds');

      // 列出所有远程账本文件
      final files = await _provider!.storage.list(path: '');

      // 过滤出账本文件，并排除本地已存在的
      final ledgerFiles = files.where((file) {
        final fileName = file.name;
        if (!fileName.startsWith('ledger_') || !fileName.endsWith('.json')) {
          return false;
        }

        // 从文件名提取账本ID
        final idStr =
            fileName.replaceAll('ledger_', '').replaceAll('.json', '');
        final remoteId = int.tryParse(idStr);

        // 跳过本地已存在的账本
        if (remoteId != null && localLedgerIds.contains(remoteId)) {
          logger.info('CloudSync', '跳过已存在的账本: $fileName (ID=$remoteId)');
          return false;
        }

        return true;
      }).toList();

      logger.info('CloudSync', '找到 ${ledgerFiles.length} 个需要恢复的远程账本文件');

      // 并行恢复所有账本
      final results = await Future.wait(
        ledgerFiles.map((file) async {
          try {
            // 下载文件内容以获取账本信息（使用 file.name 而非 file.path）
            final jsonStr = await _provider!.storage.download(path: file.name);
            if (jsonStr == null) {
              logger.warning('CloudSync', '下载失败: ${file.name}');
              return false;
            }

            final json = jsonDecode(jsonStr) as Map<String, dynamic>;
            final name = json['ledgerName'] as String? ??
                json['name'] as String? ??
                'Unknown';
            final currency = json['currency'] as String? ?? 'CNY';

            // 下载远程账本
            final ledgerId = await downloadRemoteLedger(
              name: name,
              currency: currency,
              remotePath: file.name,
            );

            if (ledgerId != null) {
              logger.info('CloudSync', '恢复成功: ${file.name} -> ledgerId=$ledgerId');
              return true;
            } else {
              logger.warning('CloudSync', '恢复失败: ${file.name}');
              return false;
            }
          } catch (e) {
            logger.warning('CloudSync', '恢复账本失败: ${file.name} - $e');
            return false;
          }
        }),
      );

      // 统计结果
      final success = results.where((r) => r).length;
      final failed = results.where((r) => !r).length;

      logger.info('CloudSync', '恢复完成: 成功=$success, 失败=$failed');
      return (success: success, failed: failed);
    } catch (e, stack) {
      logger.error('CloudSync', '恢复所有远程账本失败', e);
      logger.error('CloudSync', '堆栈', stack);
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
