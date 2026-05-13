part of 'sync_engine.dart';

/// WebSocket 实时事件监听 + auto sync / pull 调度。
///
/// `startListeningRealtime` / `stopListeningRealtime` / `triggerAutoSync` 是
/// public,被 `sync_providers.dart` / `sync_coordinator.dart` 调用——所以
/// extension 必须 public(`_` 私有的 extension 在 library 外不可见)。
extension SyncEngineRealtime on SyncEngine {
  /// 开始监听 WebSocket 实时事件，收到变更通知时自动触发 pull
  void startListeningRealtime() {
    _realtimeSubscription?.cancel();
    // 启动 WebSocket 连接，否则 realtimeEvents 流永远为空
    provider.startRealtime().catchError((e) {
      logger.warning('SyncEngine', 'WebSocket 启动失败: $e');
    });
    _realtimeSubscription = provider.realtimeEvents.listen((event) {
      if (event.type == 'sync_change' || event.type == 'backup_restore') {
        logger.info('SyncEngine',
            '收到实时事件: type=${event.type}, ledgerId=${event.ledgerId}');
        _schedulePull(event.ledgerId);
      } else if (event.type == 'profile_change') {
        // A 设备改主题色 / 收支配色 / 外观 / 头像 → server 广播。这里拉一下
        // /profile/me,把 theme_primary_color / income_is_red / appearance
        // 写回本地 SharedPreferences,让 B 无感同步。
        logger.info('SyncEngine', '收到实时事件: profile_change');
        unawaited(syncMyProfile().then((changed) {
          if (changed) {
            onAutoPullCompleted?.call(event.ledgerId ?? '');
          }
        }));
      } else if (event.type == 'connected') {
        // WS 连接建立（首次或断线重连）。离线期间累积的 local_changes 这里
        // 顺带 flush 一次，否则用户要等下一次交易写入 PostProcessor.sync()
        // 才能把东西推出去。
        logger.info('SyncEngine', 'WS connected, scheduling auto sync');
        _scheduleAutoSync(reason: 'ws_connected');
      }
    }, onError: (Object e) {
      logger.warning('SyncEngine', '实时事件流错误: $e');
    });
    logger.info('SyncEngine', '已开始监听实时事件');
  }

  /// 停止监听 WebSocket 实时事件
  void stopListeningRealtime() {
    _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
    _pullDebounce?.cancel();
    _pullDebounce = null;
    _autoSyncDebounce?.cancel();
    _autoSyncDebounce = null;
    logger.info('SyncEngine', '已停止监听实时事件');
  }

  /// 防抖调度一次完整 sync（push + pull）。WS 重连 / 网络恢复 都会打到这里。
  /// 2 秒防抖：WiFi ↔ 移动网络切换、或 WS reconnect 接着 connectivity 事件
  /// 这种"连续上线信号"只触发 1 次 sync。
  void _scheduleAutoSync({required String reason}) {
    _autoSyncDebounce?.cancel();
    _autoSyncDebounce = Timer(const Duration(seconds: 2), () async {
      if (_autoSyncing) {
        logger.debug('SyncEngine',
            'auto sync 跳过 (reason=$reason, 已在执行中)');
        return;
      }
      final resolver = ledgerIdResolver;
      if (resolver == null) {
        logger.debug('SyncEngine', 'auto sync 跳过 (reason=$reason, 无 resolver)');
        return;
      }
      final ledgerId = resolver();
      if (ledgerId.isEmpty || ledgerId == '0') {
        logger.debug('SyncEngine',
            'auto sync 跳过 (reason=$reason, ledgerId 为空)');
        return;
      }
      _autoSyncing = true;
      try {
        logger.info('SyncEngine',
            'auto sync 触发 (reason=$reason, ledger=$ledgerId)');
        final result = await sync(ledgerId: ledgerId);
        if (result.hasError) {
          logger.warning('SyncEngine',
              'auto sync 失败 (reason=$reason): ${result.error}');
        } else {
          logger.info('SyncEngine',
              'auto sync 完成 (reason=$reason): pushed=${result.pushed} pulled=${result.pulled}');
        }
      } catch (e, st) {
        logger.error('SyncEngine', 'auto sync 异常 (reason=$reason)', e, st);
      } finally {
        _autoSyncing = false;
      }
    });
  }

  /// 外部触发（例如 connectivity_plus 监听到网络恢复）。内部防抖、单飞。
  void triggerAutoSync({required String reason}) {
    _scheduleAutoSync(reason: reason);
  }

  /// 防抖调度 pull（1 秒内多次触发只执行一次）
  void _schedulePull(String? ledgerId) {
    _pullDebounce?.cancel();
    _pullDebounce = Timer(const Duration(seconds: 1), () async {
      if (_autoPulling) return;
      _autoPulling = true;
      try {
        final targetLedgerId = ledgerId ?? '';
        if (targetLedgerId.isEmpty) {
          logger.debug('SyncEngine', '自动 pull: 无 ledgerId，跳过');
          return;
        }
        logger.info('SyncEngine', '自动 pull 开始: ledger=$targetLedgerId');
        final pulled = await _pull(targetLedgerId);
        logger.info('SyncEngine', '自动 pull 完成: $pulled 条变更');
        // 附件二进制：metadata 已经在 _pull 里写到 Drift 了，文件本身需要额
        // 外调 downloadAttachments 才会下。之前只有 full `sync()` 调用它，
        // WS 触发的 pull 不调 → A 设备上传附件后 B 设备要重启才能看到图。
        // 这里 fire-and-forget 触发一下；失败只打日志，不阻塞 UI 刷新。
        final localLedgerIdInt =
            await _resolveLedgerIdBySyncId(targetLedgerId) ??
                int.tryParse(targetLedgerId);
        if (localLedgerIdInt != null && localLedgerIdInt > 0) {
          unawaited(() async {
            try {
              final downloaded = await downloadAttachments(
                  ledgerId: localLedgerIdInt);
              if (downloaded > 0) {
                logger.info('SyncEngine',
                    '自动 pull 后下载了 $downloaded 个附件');
                // 重新通知 UI 刷新（附件 UI 的 state 可能已经 stale）。
                onAutoPullCompleted?.call(targetLedgerId);
              }
            } catch (e, st) {
              logger.warning('SyncEngine', 'auto pull 后下载附件失败: $e', st);
            }
          }());
        }
        // 不管实际拉了几条，都通知 UI 刷新。pulled==0 可能是自我回声被过滤，
        // 但等于此刻 WS 事件产生的时候 snapshot 已经由 materialize 更新过,
        // UI 刷一下总没错；派生 Provider 重算也很便宜。
        _statusCache.remove(int.tryParse(targetLedgerId));
        onAutoPullCompleted?.call(targetLedgerId);
      } catch (e, st) {
        logger.error('SyncEngine', '自动 pull 失败', e, st);
      } finally {
        _autoPulling = false;
      }
    });
  }
}
