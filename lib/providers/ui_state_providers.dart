import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_providers.dart';
import 'theme_providers.dart';
import 'statistics_providers.dart';
import 'font_scale_provider.dart';
import 'update_providers.dart';
import 'cloud_mode_providers.dart';
import 'supabase_providers.dart';
import '../data/db.dart';
import '../services/data/recurring_transaction_service.dart';
import '../services/system/logger_service.dart';
import '../services/ai/ai_constants.dart';
import '../services/platform/app_link_service.dart';

// 底部导航索引（0: 明细, 1: 图表, 2: 账本, 3: 我的）
final bottomTabIndexProvider = StateProvider<int>((ref) => 0);

// AppLink 待处理动作（用于通知 UI 层执行导航）
final pendingAppLinkActionProvider = StateProvider<AppLinkAction?>((ref) => null);

// 首页滚动到顶部触发器（每次改变值时触发滚动）
final homeScrollToTopProvider = StateProvider<int>((ref) => 0);

// Currently selected month (first day), default to now
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

// 视角：'month' 或 'year'
final selectedViewProvider = StateProvider<String>((ref) => 'month');

// 检查更新状态 - 防止重复点击
final checkUpdateLoadingProvider = StateProvider<bool>((ref) => false);

// 下载进度状态
final downloadProgressProvider = StateProvider<UpdateProgress?>((ref) => null);

// ---------- Analytics 提示持久化（本地 SharedPreferences） ----------
final analyticsHeaderHintDismissedProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final link = ref.keepAlive();
  ref.onDispose(() => link.close());
  return prefs.getBool('analytics_header_hint_dismissed') ?? false;
});

final analyticsChartHintDismissedProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final link = ref.keepAlive();
  ref.onDispose(() => link.close());
  return prefs.getBool('analytics_chart_hint_dismissed') ?? false;
});

class AnalyticsHintsSetter {
  Future<void> dismissHeader() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('analytics_header_hint_dismissed', true);
  }

  Future<void> dismissChart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('analytics_chart_hint_dismissed', true);
  }
}

// ---------- FAB 长按提示持久化 ----------
final fabSpeedDialTipDismissedProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final link = ref.keepAlive();
  ref.onDispose(() => link.close());
  return prefs.getBool('fab_speed_dial_tip_dismissed') ?? false;
});

class FabSpeedDialTipSetter {
  Future<void> dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fab_speed_dial_tip_dismissed', true);
  }
}

final fabSpeedDialTipSetterProvider = Provider<FabSpeedDialTipSetter>((ref) {
  return FabSpeedDialTipSetter();
});

final analyticsHintsSetterProvider = Provider<AnalyticsHintsSetter>((ref) {
  return AnalyticsHintsSetter();
});

// 应用初始化状态
enum AppInitState {
  splash, // 显示启屏页
  loading, // 正在初始化
  ready // 初始化完成，显示主应用
}

// 应用初始化状态Provider
final appInitStateProvider =
    StateProvider<AppInitState>((ref) => AppInitState.splash);

// 搜索页面金额范围筛选开关持久化
final searchAmountFilterEnabledProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final link = ref.keepAlive();
  ref.onDispose(() => link.close());
  return prefs.getBool('search_amount_filter_enabled') ?? false;
});

class SearchSettingsSetter {
  Future<void> setAmountFilterEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('search_amount_filter_enabled', enabled);
  }
}

final searchSettingsSetterProvider = Provider<SearchSettingsSetter>((ref) {
  return SearchSettingsSetter();
});

// 账户功能启用状态持久化
final accountFeatureEnabledProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final link = ref.keepAlive();
  ref.onDispose(() => link.close());
  return prefs.getBool('account_feature_enabled') ?? true;
});

class AccountFeatureSetter {
  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('account_feature_enabled', enabled);
  }
}

final accountFeatureSetterProvider = Provider<AccountFeatureSetter>((ref) {
  return AccountFeatureSetter();
});

// 缓存的交易数据Provider（用于首屏快速展示）
final cachedTransactionsWithCategoryProvider =
    StateProvider<List<({Transaction t, Category? category})>?>((ref) => null);

// 应用初始化Provider - 管理数据预加载
final appSplashInitProvider = FutureProvider<void>((ref) async {
  const tag = 'Splash';
  logger.info(tag, '开始启屏页预加载');
  final startTime = DateTime.now();
  var stepTime = startTime;

  try {
    // 确保基础providers已初始化
    logger.info(tag, '初始化基础配置...');
    await Future.wait([
      ref.watch(primaryColorInitProvider.future),
      ref.watch(themeModeInitProvider.future),
      ref.watch(darkModePatternStyleInitProvider.future),
      ref.watch(appInitProvider.future),
      ref.watch(fontScaleInitProvider.future),
      ref.watch(hideAmountsInitProvider.future),
      ref.watch(compactAmountInitProvider.future),
      ref.watch(showTransactionTimeInitProvider.future),
    ]);
    logger.info(tag, '基础配置初始化完成: ${DateTime.now().difference(stepTime).inMilliseconds}ms');
    stepTime = DateTime.now();

    // 获取 repository
    final repo = ref.read(repositoryProvider);

    // 预加载当前账本的关键数据
    final ledgerId = ref.read(currentLedgerIdProvider);
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);

    // 并行预加载：月度统计 + 交易列表（分别计时）
    final monthlyParams = (ledgerId: ledgerId, month: currentMonth);

    // 包装每个任务以记录各自耗时
    Future<T> timed<T>(String name, Future<T> future) async {
      final start = DateTime.now();
      final result = await future;
      logger.info(tag, '$name: ${DateTime.now().difference(start).inMilliseconds}ms');
      return result;
    }

    final results = await Future.wait([
      timed('月度统计', ref.read(monthlyTotalsProvider(monthlyParams).future)),
      timed('交易列表', repo.transactionsWithCategoryAll(ledgerId: ledgerId).first),
    ]);

    final monthlyResult = results[0] as (double, double);
    final recentTransactionsWithCategory = results[1] as List<({Transaction t, Category? category})>;

    ref.read(lastMonthlyTotalsProvider(monthlyParams).notifier).state = monthlyResult;
    ref.read(cachedTransactionsWithCategoryProvider.notifier).state = recentTransactionsWithCategory;
    logger.info(tag, '并行预加载总耗时: ${DateTime.now().difference(stepTime).inMilliseconds}ms, 交易${recentTransactionsWithCategory.length}条');
    stepTime = DateTime.now();

    // 账本统计异步加载（不阻塞启动）
    Future.microtask(() async {
      final start = DateTime.now();
      await ref.read(countsForLedgerProvider(ledgerId).future);
      logger.info(tag, '账本统计(异步): ${DateTime.now().difference(start).inMilliseconds}ms');
    });

    // 生成待处理的周期交易
    try {
      await RecurringTransactionService.generatePendingTransactionsStatic(
        repository: repo,
        verbose: false,
      );
      logger.info(tag, '周期交易生成完成: ${DateTime.now().difference(stepTime).inMilliseconds}ms');
    } catch (e, stackTrace) {
      logger.error(tag, '周期交易生成失败', e, stackTrace);
    }
  } catch (e, stackTrace) {
    logger.error(tag, '预加载数据失败', e, stackTrace);
  }

  // 计算数据预加载耗时
  final dataLoadTime = DateTime.now().difference(startTime);
  logger.info(tag, '预加载总耗时: ${dataLoadTime.inMilliseconds}ms，切换到主应用');
  ref.read(appInitStateProvider.notifier).state = AppInitState.ready;
});

// 是否应该显示欢迎页面的Provider
final shouldShowWelcomeProvider = StateProvider<bool>((ref) => false);

// 初始化检查是否需要显示欢迎页面
final welcomeCheckProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final welcomeShown = prefs.getBool('welcome_shown') ?? false;
  if (!welcomeShown) {
    print('👋 首次启动，需要展示欢迎页面');
    ref.read(shouldShowWelcomeProvider.notifier).state = true;
    return true;
  }
  return false;
});

// 默认收入账户ID持久化
final defaultIncomeAccountIdProvider =
    FutureProvider.autoDispose<int?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final link = ref.keepAlive();
  ref.onDispose(() => link.close());
  return prefs.getInt('default_income_account_id');
});

// 默认支出账户ID持久化
final defaultExpenseAccountIdProvider =
    FutureProvider.autoDispose<int?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final link = ref.keepAlive();
  ref.onDispose(() => link.close());
  return prefs.getInt('default_expense_account_id');
});

class DefaultAccountSetter {
  Future<void> setDefaultIncomeAccountId(int? accountId) async {
    final prefs = await SharedPreferences.getInstance();
    if (accountId == null) {
      await prefs.remove('default_income_account_id');
    } else {
      await prefs.setInt('default_income_account_id', accountId);
    }
  }

  Future<void> setDefaultExpenseAccountId(int? accountId) async {
    final prefs = await SharedPreferences.getInstance();
    if (accountId == null) {
      await prefs.remove('default_expense_account_id');
    } else {
      await prefs.setInt('default_expense_account_id', accountId);
    }
  }
}

final defaultAccountSetterProvider = Provider<DefaultAccountSetter>((ref) {
  return DefaultAccountSetter();
});

// AI小助手开关状态持久化
final aiAssistantEnabledProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final link = ref.keepAlive();
  ref.onDispose(() => link.close());
  return prefs.getBool(AIConstants.keyAiBillExtractionEnabled) ?? true; // 默认开启
});

class AIAssistantSetter {
  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AIConstants.keyAiBillExtractionEnabled, enabled);
  }
}

final aiAssistantSetterProvider = Provider<AIAssistantSetter>((ref) {
  return AIAssistantSetter();
});

