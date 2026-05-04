import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cloud_sync/flutter_cloud_sync.dart' hide SyncStatus;

import '../../providers.dart';
import '../../widgets/ui/ui.dart';
import '../../widgets/biz/biz.dart';
import '../../styles/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../cloud/sync/sync_engine.dart';
import '../../services/system/logger_service.dart';
import '../auth/login_page.dart';

/// BeeCount Cloud 专属同步页
///
/// 跟老的 `cloud_sync_page.dart` 分开:老页面服务于 iCloud / WebDAV / 本地
/// 备份,UI 语义是"整包快照上传/下载";BeeCount Cloud 是增量 sync_changes 日志,
/// 全自动,用户感知不到"上传/下载"这个动作,所以单独一个页面。
///
/// 页面结构:
///   1. Header + 账号信息(已登录 / 重新登录按钮 / 登录入口)
///   2. 同步状态面板(localTx / remoteTx / localAttachments / remoteAttachments
///      / localAccounts / remoteAccounts / localCategories / remoteCategories
///      / localTags / remoteTags / localBudgets / remoteBudgets / unpushedChanges)
///   3. 下拉刷新:调 checkSyncHealth → 有差异就自动 sync()
class BeeCountCloudSyncPage extends ConsumerStatefulWidget {
  const BeeCountCloudSyncPage({super.key});

  @override
  ConsumerState<BeeCountCloudSyncPage> createState() =>
      _BeeCountCloudSyncPageState();
}

class _BeeCountCloudSyncPageState extends ConsumerState<BeeCountCloudSyncPage> {
  SyncHealthReport? _latestReport;
  bool _checking = false;
  bool _autoSyncing = false;

  @override
  void initState() {
    super.initState();
    // 页面一进来就拉一次 sync health,让"同步状态"面板开屏即有内容。
    // server 版本号改用 [beecountCloudServerVersionProvider] 自动获取(它依赖
    // syncStatusRefreshProvider,每次同步完成自动重新拉一次),不再用本地
    // setState 缓存的死值——server 升级后用户在 app 内任何同步操作完都会刷新。
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      unawaited(_onRefresh());
    });
  }

  Future<void> _onRefresh() async {
    final engine = ref.read(syncServiceProvider);
    final ledgerId = ref.read(currentLedgerIdProvider);
    if (engine is! SyncEngine || ledgerId <= 0) return;

    setState(() => _checking = true);
    try {
      // Step 1: 对账 profile(主题 / 收支 / 外观 / AI 配置)。把"server 上
      // 缺但本地有"的字段补推上去。用户在"修改过设置"之外,也能通过下拉
      // 刷新触发同步,不再要非得先动一下配置才会 sync。
      await reconcileProfileToServer(
        cloudProviderFuture: ref.read(beecountCloudProviderInstance.future),
        currentThemeColor: ref.read(primaryColorProvider),
        currentIncomeIsRed: ref.read(incomeExpenseColorSchemeProvider),
        currentHeaderStyle: ref.read(headerDecorationStyleProvider),
        currentCompactAmount: ref.read(compactAmountProvider),
        currentShowTransactionTime: ref.read(showTransactionTimeProvider),
      );
      // 再从 server 拉一遍应用到本地,B 设备能读到 A 刚推的
      await engine.syncMyProfile();

      var report = await engine.checkSyncHealth(ledgerId: ledgerId);
      if (!mounted) return;
      setState(() => _latestReport = report);

      // 若本地 tag/account/category 比远端多但没 unpushed change,
      // 说明历史上有"绕过 changeTracker 插入"的实体(种子代码 bug),
      // 先 backfill 把它们登记到 sync_changes,再让下一步 sync 推上去。
      if (report.needsBackfill) {
        final backfilled =
            await engine.backfillUntrackedEntities(ledgerId: ledgerId);
        logger.info('CloudSyncPage',
            '_onRefresh: backfill 补写 $backfilled 条 sync_change');
        if (backfilled > 0) {
          report = await engine.checkSyncHealth(ledgerId: ledgerId);
          if (mounted) setState(() => _latestReport = report);
        }
      }

      if (report.hasDiff) {
        // 差异存在 → 自动 sync(用户偏好:检测到差异就自动 sync,不需手动确认)
        setState(() => _autoSyncing = true);
        try {
          await engine.sync(ledgerId: ledgerId.toString());
          // sync 后重拉一次 health 报告,让 UI 反映最新计数
          final after = await engine.checkSyncHealth(ledgerId: ledgerId);
          if (mounted) setState(() => _latestReport = after);
        } catch (e) {
          if (mounted) {
            showToast(context, '${AppLocalizations.of(context).commonFailed}: $e');
          }
        } finally {
          if (mounted) setState(() => _autoSyncing = false);
        }
      }

      // 不管是否 sync,都 bump 下 UI tick
      ref.read(syncStatusRefreshProvider.notifier).state++;
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authServiceProvider);
    final ledgerId = ref.watch(currentLedgerIdProvider);
    final l10n = AppLocalizations.of(context);

    if (ledgerId == 0) {
      return Scaffold(
        backgroundColor: BeeTokens.scaffoldBackground(context),
        body: Column(
          children: [
            PrimaryHeader(
              title: l10n.cloudSyncPageTitle,
              subtitle: l10n.cloudSyncPageSubtitle,
              showBack: true,
            ),
            Expanded(
              child: Center(
                child: Text(
                  l10n.aiOcrNoLedger,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: BeeTokens.textSecondary(context),
                      ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: BeeTokens.scaffoldBackground(context),
      body: Column(
        children: [
          PrimaryHeader(
            title: l10n.cloudSyncPageTitle,
            subtitle: l10n.cloudSyncPageSubtitle,
            showBack: true,
          ),
          Expanded(
            child: authAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (auth) => FutureBuilder<CloudUser?>(
                future: auth.currentUser,
                builder: (ctx, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final user = snap.data;
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView(
                      // 横向交给 SectionCard 自带的 horizontal:12 margin,
                      // 这里只给垂直 8 避免首尾贴屏幕。
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        // Section 1: 账号
                        SectionCard(
                          child: _buildAccountSection(context, user),
                        ),
                        const SizedBox(height: 8),
                        // Section 2: 同步状态(深度检测结果)
                        SectionCard(
                          child: _buildHealthSection(context),
                        ),
                        // BeeCount Cloud server 版本号,底部弱展示。
                        // 跟 web header 的 vX.Y.Z 对齐,方便确认 server 哪版。
                        // 通过 provider 监听,server 升级后跟着 sync ticker 自
                        // 动刷新,不依赖死缓存。
                        Consumer(builder: (ctx, r, _) {
                          final v = r
                              .watch(beecountCloudServerVersionProvider)
                              .valueOrNull;
                          if (v == null || v.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: Center(
                              child: Text(
                                'BeeCount Cloud v$v',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: BeeTokens.textTertiary(context),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, CloudUser? user) {
    final l10n = AppLocalizations.of(context);
    final cfg = ref.watch(activeCloudConfigProvider).valueOrNull;
    final cachedEmail = cfg?.beecountCloudEmail ?? '';
    final cachedPassword = cfg?.beecountCloudPassword ?? '';
    final hasCredentials = cachedEmail.isNotEmpty && cachedPassword.isNotEmpty;

    if (user != null) {
      return AppListTile(
        leading: Icons.verified_user_outlined,
        title: user.email ?? l10n.mineLoggedInEmail,
      );
    }

    // 未登录 + 有保存的邮密 → 显示"重新登录"按钮,点击直接调 signInWithEmail
    if (hasCredentials) {
      return AppListTile(
        leading: Icons.refresh,
        title: l10n.cloudReloginTitle,
        subtitle: cachedEmail,
        onTap: () async {
          final provider =
              ref.read(beecountCloudProviderInstance).valueOrNull;
          if (provider == null) {
            if (mounted) showToast(context, l10n.cloudReloginFailed);
            return;
          }
          try {
            await provider.auth.signInWithEmail(
              email: cachedEmail,
              password: cachedPassword,
            );
            if (!mounted) return;
            showToast(context, l10n.cloudReloginSuccess);
            ref.read(syncStatusRefreshProvider.notifier).state++;
            ref.read(statsRefreshProvider.notifier).state++;
          } catch (e) {
            if (!mounted) return;
            showToast(context, '${l10n.cloudReloginFailed}: $e');
          }
        },
      );
    }

    // 没凭证 → 跳传统登录页
    return AppListTile(
      leading: Icons.login,
      title: l10n.mineLoginTitle,
      subtitle: l10n.mineLoginSubtitle,
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        ref.read(syncStatusRefreshProvider.notifier).state++;
      },
    );
  }

  Widget _buildHealthSection(BuildContext context) {
    // SectionCard 已经给了 p12 内边距,这里内部只做垂直间距,不再加横向 padding。
    final l10n = AppLocalizations.of(context);
    final report = _latestReport;
    final title = Row(
      children: [
        Icon(Icons.cloud_sync_outlined,
            color: BeeTokens.iconSecondary(context), size: 20),
        const SizedBox(width: 8),
        Text(l10n.syncHealthTitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: BeeTokens.textPrimary(context),
                  fontWeight: FontWeight.w600,
                )),
        const Spacer(),
        if (_checking || _autoSyncing)
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );

    // 初次 init 时 report 还没填,仍然把面板骨架 + 占位值画出来(用户要求常驻)。
    final effective = report ??
        const SyncHealthReport(
          ledgerTx: SyncCountPair.missing(),
          ledgerAttachments: SyncCountPair.missing(),
          ledgerBudgets: SyncCountPair.missing(),
          totalTx: SyncCountPair.missing(),
          totalAttachments: SyncCountPair.missing(),
          totalBudgets: SyncCountPair.missing(),
          accounts: SyncCountPair.missing(),
          categories: SyncCountPair.missing(),
          tags: SyncCountPair.missing(),
          unpushedChanges: 0,
        );

    if (effective.error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          const SizedBox(height: 8),
          Text(
            l10n.syncHealthCheckFailed(effective.error ?? ''),
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      );
    }

    final summary = effective.hasDiff
        ? l10n.syncHealthHasDiff
        : l10n.syncHealthInSync;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        title,
        const SizedBox(height: 6),
        Text(
          summary,
          style: TextStyle(
            fontSize: 12,
            color: effective.hasDiff
                ? Colors.orange
                : BeeTokens.textSecondary(context),
          ),
        ),
        const SizedBox(height: 8),
        // 当前账本口径:tx / 附件 / 预算随 ledger 走
        _groupHeader(context, l10n.syncHealthGroupCurrentLedger),
        _pairRow(context, l10n.syncHealthRowTx, effective.ledgerTx),
        _pairRow(context, l10n.syncHealthRowAttachment, effective.ledgerAttachments),
        _pairRow(context, l10n.syncHealthRowBudget, effective.ledgerBudgets),
        const SizedBox(height: 8),
        // 全部账本口径:tx/附件/预算 合计 + 用户级的 account/category/tag
        _groupHeader(context, l10n.syncHealthGroupAll),
        _pairRow(context, l10n.syncHealthRowTx, effective.totalTx),
        _pairRow(context, l10n.syncHealthRowAttachment, effective.totalAttachments),
        _pairRow(context, l10n.syncHealthRowBudget, effective.totalBudgets),
        _pairRow(context, l10n.syncHealthRowAccount, effective.accounts),
        _pairRow(context, l10n.syncHealthRowCategory, effective.categories),
        _pairRow(context, l10n.syncHealthRowTag, effective.tags),
        const SizedBox(height: 8),
        _unpushedRow(context, effective.unpushedChanges),
      ],
    );
  }

  Widget _groupHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: BeeTokens.textTertiary(context),
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _pairRow(BuildContext context, String label, SyncCountPair pair) {
    final mismatch = pair.hasDiff;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: BeeTokens.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              pair.remote < 0
                  ? AppLocalizations.of(context).syncHealthValueRemoteMissing(pair.local)
                  : AppLocalizations.of(context).syncHealthValue(pair.local, pair.remote),
              style: TextStyle(
                fontSize: 13,
                color: mismatch
                    ? Colors.orange
                    : BeeTokens.textPrimary(context),
                fontWeight: mismatch ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _unpushedRow(BuildContext context, int count) {
    final highlight = count > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              AppLocalizations.of(context).syncHealthRowUnpushed,
              style: TextStyle(
                fontSize: 13,
                color: BeeTokens.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 13,
                color: highlight
                    ? Colors.orange
                    : BeeTokens.textPrimary(context),
                fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
