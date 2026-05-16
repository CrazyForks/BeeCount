import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as d;
import 'package:flutter_cloud_sync/flutter_cloud_sync.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/db.dart';
import '../../data/repositories/base_repository.dart';
import '../../services/custom_icon_service.dart';
import '../../services/system/logger_service.dart';
import '../../services/ui/avatar_service.dart';
import '../sync_service.dart' as app;
import '../transactions_json.dart';
import 'change_tracker.dart';
import 'entity_serializer.dart';

// SyncEngine 按职责拆分到多个 part 文件,共享同一 library:
// - sync_engine_attachments.dart: 附件上传 / 下载 / 本地清理 / 分类图标上传
// - sync_engine_resolvers.dart:   跨设备 ID 解析(syncId ↔ 本地 int id)
// - sync_engine_status.dart:      健康检查 + 历史种子数据补登
// - sync_engine_realtime.dart:    WS 事件监听 + auto sync / pull 防抖调度
// - sync_engine_profile.dart:     profile + avatar 同步(theme/income/appearance/ai)
// - sync_engine_apply.dart:       pull 路径远端变更 → 本地 Drift apply(6 种 entityType)
// - sync_engine_serialization.dart: push 路径本地实体 → server payload 序列化 + fullPush
part 'sync_engine_attachments.dart';
part 'sync_engine_resolvers.dart';
part 'sync_engine_status.dart';
part 'sync_engine_realtime.dart';
part 'sync_engine_profile.dart';
part 'sync_engine_apply.dart';
part 'sync_engine_serialization.dart';

const _uuid = Uuid();

/// 同步结果
class SyncResult {
  final int pushed;
  final int pulled;
  final int conflicts;
  final String? error;

  const SyncResult({
    this.pushed = 0,
    this.pulled = 0,
    this.conflicts = 0,
    this.error,
  });

  bool get hasError => error != null;

  @override
  String toString() =>
      'SyncResult(pushed=$pushed, pulled=$pulled, conflicts=$conflicts${error != null ? ', error=$error' : ''})';
}

/// 同步状态
enum SyncEngineStatus { idle, pushing, pulling, syncing, error }

/// 核心同步编排器 — 实现 SyncService 接口
/// 负责 push 本地变更到服务端、pull 远程变更到本地
class SyncEngine implements app.SyncService {
  final BeeDatabase db;
  final BeeCountCloudProvider provider;
  final ChangeTracker changeTracker;
  final BaseRepository repo;

  /// 状态缓存
  final Map<int, app.SyncStatus> _statusCache = {};
  bool _localChanged = false;

  /// WebSocket 实时监听
  StreamSubscription<BeeCountCloudRealtimeEvent>? _realtimeSubscription;
  Timer? _pullDebounce;

  /// 当前正在自动拉取的 ledgerId（防止重复触发）
  bool _autoPulling = false;

  /// 当前是否在执行 WS 重连触发的自动 sync（push+pull），防止 ws reconnect
  /// 和 connectivity 恢复几乎同时命中时重复 sync。
  bool _autoSyncing = false;
  Timer? _autoSyncDebounce;

  /// 外部回调：自动 pull 完成后通知（用于刷新 UI）
  void Function(String ledgerId)? onAutoPullCompleted;

  /// 外部注入：当前活跃 ledgerId 的解析器。WS 重连 / 网络恢复 时需要知道
  /// 往哪个 ledger 触发 sync，但 SyncEngine 内部不挂 Riverpod ref，所以让
  /// sync_providers 构造完之后塞一个函数进来。返回 0 / null 会跳过本次 sync。
  String Function()? ledgerIdResolver;

  /// 外部注入:从 /profile/me 拉到的值回写本地 SharedPreferences + Riverpod
  /// 的 setter。SyncEngine 不挂 Riverpod ref,sync_providers 构造后 hook
  /// 进来。三个字段的 null 分别对应"不同步该字段"的 fallback。
  void Function(String hex)? onThemeColorApplied;
  void Function(bool incomeIsRed)? onIncomeColorApplied;
  void Function(Map<String, dynamic> appearance)? onAppearanceApplied;
  void Function(Map<String, dynamic> aiConfig)? onAiConfigApplied;

  SyncEngine({
    required this.db,
    required this.provider,
    required this.changeTracker,
    required this.repo,
  });

  // ==================== SyncService 接口实现 ====================

  @override
  Future<void> uploadCurrentLedger({required int ledgerId}) async {
    logger.info('SyncEngine', '上传账本 ledger=$ledgerId');

    // 用户主动点"上传"永远只做增量：用 server 的 entity diff log 把本地未推
    // 送的 changes 推上去，绝不触发 fullPush。
    //
    // 原因：fullPush 会把本地当前 ledger 的 JSON 快照整体覆盖到 server 的
    // snapshot（path = ledger.syncId），一旦本地不是"完整权威版本"（比如
    // B 刚登录、bootstrap pull 还没跑完 / 跑了但漏了几条、多设备期间某条
    // 交易延迟到达），web 立刻就看到"剩几条"的残缺快照 —— 这是典型的
    // "覆盖丢数据"场景。
    //
    // 即使一次 fullPush 之后后续 pull 再回灌也不行：snapshot 是权威源，
    // sync_changes 只是 diff，web 端读的是 snapshot。
    //
    // 增量 push 只推 changeTracker 登记过的本地操作，不会把没 own 的数据
    // 误推回去，所以是安全的。本地没变更时直接返回，不需要 fallback。
    final pushed = await _push(ledgerId.toString());
    logger.info('SyncEngine', '上传账本完成：增量推送 $pushed 条变更');

    _statusCache.remove(ledgerId);
    _localChanged = false;
  }

  @override
  Future<({int inserted, int deletedDup})>
      downloadAndRestoreToCurrentLedger({required int ledgerId}) async {
    logger.info('SyncEngine', '下载并恢复账本 ledger=$ledgerId');

    // 先尝试增量拉取
    final pulled = await _pull(ledgerId.toString());
    if (pulled > 0) {
      _statusCache.remove(ledgerId);
      return (inserted: pulled, deletedDup: 0);
    }

    // 增量拉取无数据，尝试全量拉取
    final result = await _fullPull(ledgerId: ledgerId);
    _statusCache.remove(ledgerId);
    return result;
  }

  @override
  Future<app.SyncStatus> getStatus({required int ledgerId}) async {
    // 返回缓存（如果有且未标记变更）
    if (!_localChanged && _statusCache.containsKey(ledgerId)) {
      return _statusCache[ledgerId]!;
    }

    try {
      final user = await provider.auth.currentUser;
      if (user == null) {
        return const app.SyncStatus(
          diff: app.SyncDiff.notLoggedIn,
          localCount: 0,
          localFingerprint: '',
        );
      }

      // 本地交易数
      final localTxs = await (db.select(db.transactions)
            ..where((t) => t.ledgerId.equals(ledgerId)))
          .get();
      final localCount = localTxs.length;

      // 检查是否有未推送的本地变更
      final unpushedCount =
          (await changeTracker.getUnpushedChangesForLedger(ledgerId)).length;

      // 检查云端是否有数据。path 用 ledger.syncId 跟 push 侧保持一致。
      final ledgerRowStatus = await (db.select(db.ledgers)
            ..where((l) => l.id.equals(ledgerId)))
          .getSingleOrNull();
      final hasRemote = await provider.storage.exists(
        path: ledgerRowStatus?.syncId ?? ledgerId.toString(),
      );

      app.SyncDiff diff;
      if (!hasRemote && localCount == 0) {
        diff = app.SyncDiff.noRemote;
      } else if (!hasRemote) {
        diff = app.SyncDiff.localNewer; // 本地有数据，云端没有
      } else if (unpushedCount > 0) {
        diff = app.SyncDiff.localNewer;
      } else {
        diff = app.SyncDiff.inSync;
      }

      final status = app.SyncStatus(
        diff: diff,
        localCount: localCount,
        localFingerprint: unpushedCount > 0 ? 'has_changes' : 'synced',
      );
      _statusCache[ledgerId] = status;
      _localChanged = false;
      return status;
    } catch (e, st) {
      logger.error('SyncEngine', '获取同步状态失败', e, st);
      return app.SyncStatus(
        diff: app.SyncDiff.error,
        localCount: 0,
        localFingerprint: '',
        message: e.toString(),
      );
    }
  }

  @override
  void markLocalChanged({required int ledgerId}) {
    _localChanged = true;
    _statusCache.remove(ledgerId);
  }

  @override
  Future<void> deleteRemoteBackup({required int ledgerId}) async {
    // path 用 ledger.syncId，跟 push/upload 对齐。
    final ledgerRow = await (db.select(db.ledgers)
          ..where((l) => l.id.equals(ledgerId)))
        .getSingleOrNull();
    final path = ledgerRow?.syncId ?? ledgerId.toString();
    try {
      await provider.storage.delete(path: path);
    } catch (e) {
      // 忽略 404
      if (!e.toString().contains('404')) rethrow;
    }
    _statusCache.remove(ledgerId);
  }

  @override
  void clearStatusCache({int? ledgerId}) {
    if (ledgerId != null) {
      _statusCache.remove(ledgerId);
    } else {
      _statusCache.clear();
    }
  }

  @override
  Future<({String? fingerprint, int? count, DateTime? exportedAt})>
      refreshCloudFingerprint({required int ledgerId}) async {
    // 对于增量同步，fingerprint 概念不太适用
    // 返回基本信息即可
    final ledgerRow = await (db.select(db.ledgers)
          ..where((l) => l.id.equals(ledgerId)))
        .getSingleOrNull();
    final hasRemote = await provider.storage.exists(
      path: ledgerRow?.syncId ?? ledgerId.toString(),
    );
    if (!hasRemote) {
      return (fingerprint: null, count: null, exportedAt: null);
    }
    return (
      fingerprint: 'incremental',
      count: null,
      exportedAt: DateTime.now(),
    );
  }


  /// 释放资源
  void dispose() {
    stopListeningRealtime();
  }

  // ==================== 核心同步逻辑 ====================

  /// 执行完整同步（先 push 后 pull）
  Future<SyncResult> sync({required String ledgerId}) async {
    logger.info('SyncEngine', '开始同步 ledger=$ledgerId');
    try {
      final ledgerIdInt = int.tryParse(ledgerId) ?? -1;
      int pushed = 0;

      // 先上传附件文件，确保 cloudFileId 写入本地 DB，后续 push 的 payload 才包含 cloudFileId
      try {
        await uploadAttachments(ledgerId: ledgerIdInt);
      } catch (e, st) {
        logger.error('SyncEngine', '附件上传失败（不阻塞主同步）', e, st);
      }

      // 决策：fullPush 还是增量 push
      //
      // 原来用 SharedPreferences['sync_entity_pushed_v3_<id>'] 缓存"曾经推过"，
      // 但这个缓存会跟服务端真实状态失联（服务端重建/切换部署都会），所以我们
      // 现在直接问服务端："这个账本有没有快照？"
      //   - 有：走增量 push（只推 local_changes 里未推送的）
      //   - 没有 + 本地有交易：走 fullPush（把本地数据整体推上去）
      //   - 没有 + 本地空：跳过 push
      // 多一个 exists() 网络调用，但 O(1)、请求极小，足以省掉缓存跟真实状态
      // 失联带来的"假装同步成功"问题。
      // exists() 的 path 必须跟 fullPush / _pushAllEntities 用的 ledger_id 对齐，
      // 都走 ledger.syncId。否则：server 上数据挂在 syncId=UUID 下，本地 exists
      // 查 int id 永远 false → 误判"远端无快照" → 触发 fullPush → server 被
      // 本地残缺快照覆盖。这是之前 "web 只剩几条" 事故的主路径之一。
      final ledgerRow = await (db.select(db.ledgers)
            ..where((l) => l.id.equals(ledgerIdInt)))
          .getSingleOrNull();

      // 短路:本地账本已删除(deleteLedger 路径)。这种情况下:
      //   - hasRemote 检查没意义(syncId 已经丢,fallback 到 int id 对 UUID 账本
      //     会误判)
      //   - fullPush 会 getSingle 抛错(ledger 行不存在)
      //   - pull 也没意义(账本都没了拉啥)
      // 唯一要做的是把 deleteLedger 已登记到 local_changes 的 ledger_snapshot:
      // delete + transaction:delete + budget:delete 推到 server,清掉 canonical
      // state,否则 remote ledgers 列表里还会显示这个被删的账本。
      if (ledgerRow == null) {
        final pushed = await _push(ledgerId);
        logger.info('SyncEngine',
            '账本 $ledgerId 已本地删除,push delete changes: $pushed 条');
        return SyncResult(pushed: pushed, pulled: 0);
      }

      final checkPath = ledgerRow.syncId ?? ledgerId.toString();
      bool hasRemote = true;
      try {
        hasRemote = await provider.storage.exists(path: checkPath);
      } catch (e, st) {
        // 检查失败时保守假设远端存在，走增量 push；fullPush 的风险更大。
        logger.warning('SyncEngine', '远端存在性检查失败（按已存在处理）: $e', st);
      }

      if (!hasRemote) {
        final localTxCount = (await (db.select(db.transactions)
              ..where((t) => t.ledgerId.equals(ledgerIdInt)))
            .get()).length;
        logger.info('SyncEngine',
            '远端无快照，本地 $localTxCount 条交易，触发 fullPush');
        // 无条件 fullPush:即使本地是 0 笔交易的空账本也要 push,否则用户在
        // app 创建的新账本要等到第一笔交易才被动同步,违反"创建后立即可见"
        // 预期。fullPush 内部会 storage.upload 一份(几乎空的)snapshot 创建
        // server 端 ledger 行,后续同步走增量。
        // 多余开销:fullPush 还会 _pushAllEntities re-upload user-global
        // accounts/categories/tags。LWW 保证幂等,可接受;只有"远端无快照"
        // 时跑这一次。
        if (localTxCount > 0) {
          // 远端重建/切换后，本地 attachments.cloudFileId 指向的文件已失效。
          // 清掉云端引用，让 uploadAttachments 重新上传并回填新 ID；否则
          // 交易 payload 里带的是旧 ID，web 那边会 404。
          await _resetAttachmentCloudRefs(ledgerIdInt);
        }
        await fullPush(ledgerId: ledgerIdInt);
        // fullPush 不处理 delete change(_pushAllEntities 只 upsert 当前实体,
        // delete change 对应的本地行已经没了不会被 upsert)。fullPush 已经把
        // 非 delete change 都 markPushed,这里 _push 一遍把剩下的 delete change
        // 实际推到 server,清掉 canonical state。
        // 否则:用户先 clear 后导入,server 会保留旧数据 + 新数据。
        final extraPushed = await _push(ledgerId);
        pushed = localTxCount + extraPushed;
      } else {
        pushed = await _push(ledgerId);
        logger.info('SyncEngine', '增量推送: $pushed 条');
      }

      final pulled = await _pull(ledgerId);

      // 下载远端附件文件（上传已在 push 前完成）
      try {
        await downloadAttachments(ledgerId: ledgerIdInt);
      } catch (e, st) {
        logger.error('SyncEngine', '附件下载失败（不阻塞主同步）', e, st);
      }

      // 顺手再拉一次 profile（多数场景 bootstrap 已经拉过，这里幂等兜底）。
      await syncMyProfile();

      final result = SyncResult(pushed: pushed, pulled: pulled);
      logger.info('SyncEngine', '同步完成: $result');
      return result;
    } catch (e, st) {
      logger.error('SyncEngine', '同步失败', e, st);
      return SyncResult(error: e.toString());
    }
  }


  /// 首次登录 / app 启动时从 server 拉全部账本写本地 Drift。
  ///
  /// Server 的 ledger 不走 sync_change log（只有 tx/account/cat/tag 走），
  /// 所以设备 B 首次登录时 `_pull` 拿不到 A 已有的账本。这个方法专门补这一
  /// 刀：走 `GET /sync/ledgers` 拿列表，按 `external_id` 对齐本地 `syncId`
  /// upsert 到 Drift。
  ///
  /// 新插入的 ledger 对应的 tx/account/category/tag sync_changes 历史会被
  /// `replayAllChanges`（由调用方在必要时触发）从 cursor=0 重放应用，因为
  /// 此时设备全局 cursor 可能已经前移、普通 `_pull` 再也拉不回历史。
  ///
  /// 返回新增（非已存在）的账本数，调用方可据此决定要不要 bump 刷新信号。
  Future<int> syncLedgersFromServer() async {
    logger.info('SyncEngine', 'syncLedgersFromServer start');
    try {
      final remote = await provider.readLedgers();
      int upserted = 0;
      int inserted = 0;
      for (final r in remote) {
        final syncId = r.ledgerId;
        if (syncId.isEmpty) continue;
        final existing = await (db.select(db.ledgers)
              ..where((l) => l.syncId.equals(syncId)))
            .getSingleOrNull();
        if (existing != null) {
          // update meta（name / currency 可能在 server 被改过）
          await (db.update(db.ledgers)..where((l) => l.id.equals(existing.id)))
              .write(LedgersCompanion(
            name: d.Value(r.ledgerName),
            currency: d.Value(r.currency),
          ));
          upserted++;
          continue;
        }
        // fallback：同名 + syncId 为 NULL 的 seed 行 → 收编
        final byName = await (db.select(db.ledgers)
              ..where((l) => l.name.equals(r.ledgerName))
              ..where((l) => l.syncId.isNull()))
            .getSingleOrNull();
        if (byName != null) {
          await (db.update(db.ledgers)..where((l) => l.id.equals(byName.id)))
              .write(LedgersCompanion(
            syncId: d.Value(syncId),
            currency: d.Value(r.currency),
          ));
          upserted++;
          continue;
        }
        // 全新账本：insert。id 是本地 autoIncrement，跟 server 无关。
        await db.into(db.ledgers).insert(LedgersCompanion.insert(
              name: r.ledgerName,
              currency: d.Value(r.currency),
              syncId: d.Value(syncId),
            ));
        inserted++;
      }
      logger.info(
          'SyncEngine',
          'syncLedgersFromServer done: total=${remote.length} upserted=$upserted inserted=$inserted');
      return inserted;
    } catch (e, st) {
      logger.warning('SyncEngine', 'syncLedgersFromServer failed: $e', st);
      return 0;
    }
  }

  /// 推送本地未同步的变更到服务端
  Future<int> _push(String ledgerId) async {
    final ledgerIdInt = int.tryParse(ledgerId) ?? -1;
    final ledger = await (db.select(db.ledgers)
          ..where((l) => l.id.equals(ledgerIdInt)))
        .getSingleOrNull();

    // 关键:ledger 已被本地删除时不能直接 return 0。因为 deleteLedger 会先
    // 登记 ledger_snapshot:delete change 再 hard-delete ledger 行,这条 delete
    // change 的 ledger_id 字段就是这个本地 id。如果这里因 ledger==null 短路,
    // 这条 delete change 永远卡在本地不推,云端账本和它的快照永远删不掉,
    // remote ledgers list 还会继续显示。
    //
    // 所以策略改为:先按这个 ledgerIdInt 查未推送变更,有变更就继续推,没
    // 变更才安全 return。
    final ledgerChanges =
        await changeTracker.getUnpushedChangesForLedger(ledgerIdInt);
    // 当前账本的变更 + user-scoped（ledgerId=0：tag / category）的未推变更。
    // 后者是"账户/分类/标签属于用户而非单个账本"的对齐：LocalRepository 在
    // create/update/deleteTag/Category 时用 ledgerId=0 记录变更，getUnpushed-
    // ChangesForLedger(ledger.id) 永远查不到它们 → 移动端重命名标签/分类在
    // web 永远看不到。把 ledgerId=0 的也一起捎带。
    final globalChanges = ledgerIdInt == 0
        ? const <LocalChange>[]
        : await changeTracker.getUnpushedChangesForLedger(0);
    final changes = [...ledgerChanges, ...globalChanges];
    if (changes.isEmpty) {
      if (ledger == null) {
        logger.warning('SyncEngine',
            'push: 本地账本 $ledgerId 已删除且无待推送变更,跳过');
      } else {
        logger.debug('SyncEngine', 'push: 无待推送变更');
      }
      return 0;
    }
    // 当本地 ledger 行已删,从同批 changes 里捞 ledger_snapshot:delete 的
    // entity_sync_id(= 被删账本的 syncId / UUID),用它给所有相关 change 的
    // push payload 设置 ledger_id 字段。否则 fallback 到 ledgerId 字符串
    // (本地 int id),server 端会把它当成一个不存在的账本 → 整批 delete 静
    // 默失败,canonical state 不变,远端数据看着像没删。
    String? deletedLedgerSyncId;
    if (ledger == null) {
      for (final c in changes) {
        if (c.entityType == 'ledger_snapshot' && c.action == 'delete') {
          deletedLedgerSyncId = c.entitySyncId;
          break;
        }
      }
      logger.info('SyncEngine',
          'push: 本地账本 $ledgerId 已删除,但还有 ${changes.length} 条未推送变更(应包含 ledger_snapshot:delete),'
          '从 snapshot change 拿到 ledgerSyncId=$deletedLedgerSyncId,继续 push');
    }

    // 构建服务端 push 格式：从 DB 读取最新数据序列化
    final syncChanges = <Map<String, dynamic>>[];

    for (final change in changes) {
      final isUserGlobal =
          ChangeTracker.userGlobalEntityTypes.contains(change.entityType);

      Map<String, dynamic> payload;

      if (change.action == 'delete') {
        payload = <String, dynamic>{};
      } else {
        // 从数据库读取最新实体并序列化。注意:正常流程到这里 ledger 一定非
        // null —— ledger==null 的唯一来源是 deleteLedger,而它只产生 delete
        // changes(已被 if 分支拦走)。这里用 ledgerIdInt 兜底防御,避免 NPE。
        payload = await _serializeEntityForPush(
          entityType: change.entityType,
          entityId: change.entityId,
          ledgerId: ledger?.id ?? ledgerIdInt,
        );
      }

      // user-global 重构后协议(参考 .docs/user-global-refactor/plan.md):
      //   - scope='user' (category/account/tag):ledger_id 发 null,server 按
      //     entity_type 强制按 user-scope 路由,不再依附任何 ledger。
      //   - scope='ledger' (transaction/budget/ledger/ledger_snapshot):
      //     ledger_id 用 ledger.syncId(跨设备唯一 external_id)。删账本路径
      //     从 ledger_snapshot:delete change 拉回 syncId,保证 server 认得。
      final String? pushLedgerId;
      final String pushScope;
      if (isUserGlobal) {
        pushLedgerId = null;
        pushScope = 'user';
      } else {
        pushLedgerId = ledger?.syncId ?? deletedLedgerSyncId ?? ledgerId;
        pushScope = 'ledger';
      }
      syncChanges.add({
        'ledger_id': pushLedgerId,
        'scope': pushScope,
        'entity_type': change.entityType,
        'entity_sync_id': change.entitySyncId,
        'action': change.action == 'delete' ? 'delete' : 'upsert',
        'payload': payload,
        'updated_at': change.createdAt.toUtc().toIso8601String(),
      });
    }

    // 使用 pushChanges 直接推送个体变更
    await provider.pushChanges(changes: syncChanges);

    // 标记已推送
    await changeTracker.markPushed(changes.map((c) => c.id).toList());
    logger.info('SyncEngine',
        'push: 推送 ${changes.length} 条变更 (当前账本 ${ledgerChanges.length} + 全局 ${globalChanges.length})');
    return changes.length;
  }

  /// 拉取远程变更并应用到本地。每一页变更用 `db.transaction` 包起来，把
  /// "逐条 select + insert" 合成一个事务，初次同步几百条实体时的"感觉一条
  /// 一条蹦出来"变成一次性写入，iOS SQLite 的 fsync 代价减一大截。
  ///
  /// 默认用 provider 存在 SharedPreferences 里的全局 cursor；传 [sinceOverride]
  /// 可以强制从指定 change_id 重拉（用 0 表示从头）。BeeCount Cloud apply 是
  /// 按 entity_sync_id 做 upsert 的，所以重拉历史是幂等的，用于"cursor 推到顶
  /// 但本地状态跟实际脱节"的恢复场景。
  Future<int> _pull(String ledgerId, {int? sinceOverride}) async {
    int totalPulled = 0;

    bool hasMore = true;
    int? nextSince = sinceOverride;
    while (hasMore) {
      final result = await provider.pullChanges(since: nextSince, limit: 500);
      if (result.changes.isEmpty) break;

      // 用 transaction 把整页变更合成一次提交。Drift 内部是 SQLite 单 WAL，
      // 每条独立 commit 会触发 fsync；合成一次可以把 N 次 fsync 降到 1 次。
      // 即使某条 apply 内部抛错，transaction 会 rollback 整页 —— 比半同步
      // 的状态好，下一次 sync 会再拉一次（server cursor 只在全部成功时 advance）。
      final pageApplied = await db.transaction<int>(() async {
        int pageCount = 0;
        for (final change in result.changes) {
          final applied = await _applyRemoteChange(change);
          if (applied) pageCount++;
        }
        return pageCount;
      });
      totalPulled += pageApplied;

      hasMore = result.hasMore;
      // 下一页接着上一页的 cursor 往后翻；pullChanges 内部也会 save，这里
      // 只是显式把下一个页面的 since 对齐到 server 返回的最新 cursor。
      if (hasMore) nextSince = result.serverCursor;
    }

    if (totalPulled > 0) {
      logger.info('SyncEngine', 'pull: 应用 $totalPulled 条远程变更');
    }
    return totalPulled;
  }

  /// 从 change_id=0 起把整段 sync_changes 重拉一遍并幂等应用。
  /// 用在"账本刚从 server 拉到本地、本地 tx 为空但 cursor 已经被推到顶"
  /// 的恢复场景。跟 S3/WebDAV 的 `_fullPull` 不同，这里走的还是 BeeCount
  /// Cloud 的增量日志，只是把起点拨回 0，符合 BeeCount Cloud 的同步模型。
  Future<int> replayAllChanges() async {
    logger.info('SyncEngine', 'replayAllChanges: 从 0 开始重拉 sync_changes');
    return _pull('', sinceOverride: 0);
  }


  // 附件相关方法搬到 sync_engine_attachments.dart 这个 part 文件:
  //   _resetAttachmentCloudRefs / _uploadCategoryIcons / uploadAttachments
  //   downloadAttachments / _getAttachmentFile / _cleanupTxAttachmentFilesOnDisk
  //   _cleanupCategoryIconFilesOnDisk


  /// 新设备全量拉取
  Future<({int inserted, int deletedDup})> _fullPull(
      {required int ledgerId}) async {
    logger.info('SyncEngine', '开始全量拉取 ledger=$ledgerId');

    // path 对齐 fullPush 上传时用的 ledger.syncId。
    final ledgerRow = await (db.select(db.ledgers)
          ..where((l) => l.id.equals(ledgerId)))
        .getSingleOrNull();
    final path = ledgerRow?.syncId ?? ledgerId.toString();
    final data = await provider.storage.download(path: path);
    if (data == null) {
      logger.warning('SyncEngine', '全量拉取: 服务端无数据');
      return (inserted: 0, deletedDup: 0);
    }

    // 复用 importTransactionsJson
    final result = await importTransactionsJson(repo, ledgerId, data);
    logger.info('SyncEngine', '全量拉取完成: inserted=${result.inserted}');

    // 下载附件
    try {
      await downloadAttachments(ledgerId: ledgerId);
    } catch (e, st) {
      logger.error('SyncEngine', '附件下载失败（不阻塞拉取）', e, st);
    }

    return (inserted: result.inserted, deletedDup: 0);
  }


  // ==================== 附件云端同步 ====================
  //
  // uploadAttachments / downloadAttachments / _getAttachmentFile
  // _cleanupTxAttachmentFilesOnDisk / _cleanupCategoryIconFilesOnDisk
  // 这些方法都搬到 sync_engine_attachments.dart 这个 part 文件里了。
}

/// 一组 local/remote 计数。-1 表示拉不到(网络错 / 老 server 没这个字段)。
class SyncCountPair {
  const SyncCountPair({required this.local, required this.remote});
  const SyncCountPair.missing()
      : local = 0,
        remote = -1;
  final int local;
  final int remote;
  bool get hasDiff => remote >= 0 && local != remote;
}

/// 深度同步检测报告。UI 分两组展示:
/// - `当前账本`:tx / attachment / budget,随 current ledger 走
/// - `全部账本`:上面三项的全量合计,以及 account / category / tag 这些用户级
///   实体(per-ledger 跟 total 同值)
class SyncHealthReport {
  const SyncHealthReport({
    required this.ledgerTx,
    required this.ledgerAttachments,
    required this.ledgerBudgets,
    required this.totalTx,
    required this.totalAttachments,
    required this.totalBudgets,
    required this.categoryAttachments,
    required this.accounts,
    required this.categories,
    required this.tags,
    required this.unpushedChanges,
    this.error,
  });

  factory SyncHealthReport.error(String message) => const SyncHealthReport(
        ledgerTx: SyncCountPair.missing(),
        ledgerAttachments: SyncCountPair.missing(),
        ledgerBudgets: SyncCountPair.missing(),
        totalTx: SyncCountPair.missing(),
        totalAttachments: SyncCountPair.missing(),
        totalBudgets: SyncCountPair.missing(),
        categoryAttachments: SyncCountPair.missing(),
        accounts: SyncCountPair.missing(),
        categories: SyncCountPair.missing(),
        tags: SyncCountPair.missing(),
        unpushedChanges: 0,
      ).copyWithError(message);

  SyncHealthReport copyWithError(String message) => SyncHealthReport(
        ledgerTx: ledgerTx,
        ledgerAttachments: ledgerAttachments,
        ledgerBudgets: ledgerBudgets,
        totalTx: totalTx,
        totalAttachments: totalAttachments,
        totalBudgets: totalBudgets,
        categoryAttachments: categoryAttachments,
        accounts: accounts,
        categories: categories,
        tags: tags,
        unpushedChanges: unpushedChanges,
        error: message,
      );

  /// 当前账本口径。`ledgerAttachments` 只算交易附件(server 端
  /// `attachment_kind='transaction'`),分类自定义图标见 [categoryAttachments]。
  final SyncCountPair ledgerTx;
  final SyncCountPair ledgerAttachments;
  final SyncCountPair ledgerBudgets;

  /// 全量口径(跨当前用户所有账本)。`totalAttachments` 同样只算交易附件。
  final SyncCountPair totalTx;
  final SyncCountPair totalAttachments;
  final SyncCountPair totalBudgets;

  /// 分类自定义图标 — user-global,不分账本。server 端 `attachment_kind=
  /// 'category_icon'`,跨账本只占一份存储。
  final SyncCountPair categoryAttachments;

  /// 用户级实体(per-ledger 跟 total 同值,只留一组)
  final SyncCountPair accounts;
  final SyncCountPair categories;
  final SyncCountPair tags;

  final int unpushedChanges;
  final String? error;

  bool get hasDiff {
    if (error != null) return false;
    if (unpushedChanges > 0) return true;
    return ledgerTx.hasDiff ||
        ledgerAttachments.hasDiff ||
        ledgerBudgets.hasDiff ||
        totalTx.hasDiff ||
        totalAttachments.hasDiff ||
        totalBudgets.hasDiff ||
        categoryAttachments.hasDiff ||
        accounts.hasDiff ||
        categories.hasDiff ||
        tags.hasDiff;
  }

  /// 本地比远端多,但没 unpushed change → 绕过 changeTracker 的历史种子数据。
  bool get needsBackfill {
    if (error != null || unpushedChanges > 0) return false;
    if (accounts.remote >= 0 && accounts.local > accounts.remote) return true;
    if (categories.remote >= 0 && categories.local > categories.remote) return true;
    if (tags.remote >= 0 && tags.local > tags.remote) return true;
    return false;
  }
}
