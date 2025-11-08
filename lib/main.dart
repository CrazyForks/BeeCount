import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'theme.dart';
import 'providers.dart';
import 'styles/colors.dart';
import 'providers/font_scale_provider.dart';
import 'utils/route_logger.dart';
import 'utils/notification_factory.dart';
import 'pages/auth/splash_page.dart';
import 'pages/auth/welcome_page.dart';
import 'services/reminder_monitor_service.dart';
import 'services/recurring_transaction_service.dart';
import 'services/screenshot_monitor_service.dart';
import 'services/shortcuts_handler_service.dart';
import 'data/db.dart';
import 'l10n/app_localizations.dart';
import 'cloud/cloud_service_store.dart';
import 'cloud/supabase_initializer.dart';
import 'widget/widget_manager.dart';
import 'package:home_widget/home_widget.dart';
import 'package:app_links/app_links.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化时区（必须在通知服务之前，修复iOS通知问题）
  try {
    NotificationFactory.initializeTimeZone();
  } catch (e) {
    print('⚠️  时区初始化失败（可能在不支持的平台上运行）: $e');
  }

  // 配置iOS App Group（widget和主app共享数据必需）
  try {
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId('group.com.tntlikely.beecount');
    }
  } catch (e) {
    print('⚠️  HomeWidget 插件初始化失败（可能在不支持的平台上运行）: $e');
  }

  // 全局初始化Supabase（如果配置了自定义Supabase服务）
  await _initializeSupabase();

  // 初始化通知服务
  try {
    final notificationUtil = NotificationFactory.getInstance();
    await notificationUtil.initialize();
  } catch (e) {
    print('⚠️  通知服务初始化失败（可能在不支持的平台上运行）: $e');
  }

  // 恢复用户的记账提醒设置（关键修复：应用重启后自动恢复提醒）
  await _restoreUserReminder();

  // 启动提醒监控服务（监听应用生命周期，自动恢复丢失的提醒）
  try {
    ReminderMonitorService().startMonitoring();
  } catch (e) {
    print('⚠️  提醒监控服务启动失败（可能在不支持的平台上运行）: $e');
  }

  // 生成待处理的重复交易
  await _generatePendingRecurringTransactions();

  // 注册小组件交互回调
  try {
    await WidgetManager.registerCallback();
  } catch (e) {
    print('⚠️  小组件回调注册失败（可能在不支持的平台上运行）: $e');
  }

  // 创建全局ProviderContainer
  final container = ProviderContainer();

  // 恢复截图自动识别设置（Android专属），传入container
  await _restoreScreenshotMonitor(container);

  // 启动iOS URL监听（用于快捷指令自动记账）
  if (Platform.isIOS) {
    _setupUrlListener(container);
  }

  runApp(ProviderScope(
    parent: container,
    observers: const [_WidgetUpdateObserver()],
    child: const MainApp(),
  ));
}

/// Provider observer to update widget on app start
class _WidgetUpdateObserver extends ProviderObserver {
  const _WidgetUpdateObserver();
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // Update widget when current ledger is loaded
    if (provider == currentLedgerIdProvider && newValue != null) {
      _updateWidgetOnStart(container);
    }
  }

  void _updateWidgetOnStart(ProviderContainer container) async {
    try {
      final repository = container.read(repositoryProvider);
      final ledgerId = container.read(currentLedgerIdProvider);
      final primaryColor = container.read(primaryColorProvider);

      final widgetManager = WidgetManager();
      await widgetManager.updateWidget(repository, ledgerId, primaryColor);

      print('✅ 小组件数据已更新');
    } catch (e) {
      print('❌ 更新小组件失败（可能在不支持的平台上运行）: $e');
    }
  }
}

/// 全局初始化Supabase
///
/// 在应用启动时检查用户是否配置了自定义Supabase服务，如果配置了则全局初始化
/// 这样可以确保session在应用重启后能够正确恢复
Future<void> _initializeSupabase() async {
  try {
    final store = CloudServiceStore();
    final config = await store.loadActive();

    // 只在配置了Supabase服务时才初始化
    await SupabaseInitializer.initialize(config);
  } catch (e) {
    print('⚠️  Supabase 初始化失败（非致命错误）: $e');
    // 不抛出异常，避免影响应用启动
  }
}

/// 恢复用户之前设置的记账提醒
///
/// 问题场景：
/// - 应用被系统杀死后，通知任务会丢失
/// - 应用更新后，通知任务会被清除
/// - 手机重启后，通知任务需要重新设置
///
/// 解决方案：
/// - 在应用启动时检查用户是否开启了提醒
/// - 如果开启了，重新设置通知任务
Future<void> _restoreUserReminder() async {
  try {
    print('🔄 检查并恢复记账提醒...');
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('reminder_enabled') ?? false;

    if (isEnabled) {
      final hour = prefs.getInt('reminder_hour') ?? 21;
      final minute = prefs.getInt('reminder_minute') ?? 0;
      print('✅ 发现用户已启用记账提醒: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      print('🔔 正在重新设置提醒任务...');

      try {
        final notificationUtil = NotificationFactory.getInstance();
        await notificationUtil.scheduleDailyReminder(
          id: 1001,
          title: '记账提醒',
          body: '别忘了记录今天的收支哦 💰',
          hour: hour,
          minute: minute,
        );
        print('✅ 记账提醒已成功恢复');
      } catch (e) {
        print('❌ 记账提醒设置失败（可能在不支持的平台上运行）: $e');
      }
    } else {
      print('ℹ️  用户未启用记账提醒，跳过恢复');
    }
  } catch (e) {
    print('❌ 恢复记账提醒失败: $e');
    // 不抛出异常，避免影响应用启动
  }
}

/// 恢复截图自动识别设置（仅Android）
///
/// 问题场景：
/// - 应用重启后，截图监听服务会丢失
/// - 需要自动恢复用户之前的设置
///
/// 解决方案：
/// - 在应用启动时检查用户是否开启了截图监听
/// - 如果开启了，重新启动监听服务
Future<void> _restoreScreenshotMonitor(ProviderContainer container) async {
  if (!Platform.isAndroid) return;

  try {
    print('📸 检查并恢复截图自动识别...');
    final screenshotMonitor = ScreenshotMonitorService(container);
    final isEnabled = await screenshotMonitor.isEnabled();

    if (isEnabled) {
      print('✅ 发现用户已启用截图自动识别');
      print('🔄 正在重新启动监听服务...');
      await screenshotMonitor.enable();
      print('✅ 截图监听服务已成功恢复');
    } else {
      print('ℹ️  用户未启用截图自动识别，跳过恢复');
    }
  } catch (e) {
    print('❌ 恢复截图监听失败: $e');
    // 不抛出异常，避免影响应用启动
  }
}

/// 生成待处理的重复交易
///
/// 在应用启动时检查所有重复交易模板，生成到期的交易记录
Future<void> _generatePendingRecurringTransactions() async {
  try {
    print('🔄 检查待生成的重复交易...');
    final db = BeeDatabase();
    final service = RecurringTransactionService(db);

    final generatedTransactions = await service.generatePendingTransactions();

    if (generatedTransactions.isNotEmpty) {
      print('✅ 成功生成 ${generatedTransactions.length} 条重复交易记录');
    } else {
      print('ℹ️  没有待生成的重复交易');
    }

    await db.close();
  } catch (e) {
    print('❌ 生成重复交易失败: $e');
    // 不抛出异常，避免影响应用启动
  }
}

/// 设置iOS URL监听（用于快捷指令自动记账）
///
/// 监听从快捷指令发来的 beecount:// URL Scheme调用
/// 支持的URL格式:
/// - beecount://auto-billing (自动处理最新截图)
/// - beecount://quick-billing (打开相册选择)
void _setupUrlListener(ProviderContainer container) {
  try {
    print('🔗 [iOS] 初始化URL监听...');

    final appLinks = AppLinks();
    final shortcutsHandler = ShortcutsHandlerService(container);

    // 监听URL（应用在后台时）
    appLinks.uriLinkStream.listen((uri) {
      print('🔗 [iOS] 收到URL: $uri');
      shortcutsHandler.handleUrl(uri);
    }, onError: (err) {
      print('❌ [iOS] URL监听错误: $err');
    });

    // 检查应用启动时的URL（应用未运行时）
    appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        print('🔗 [iOS] 启动时收到URL: $uri');
        shortcutsHandler.handleUrl(uri);
      }
    }).catchError((err) {
      print('❌ [iOS] 获取初始URL失败: $err');
    });

    print('✅ [iOS] URL监听已启动');
  } catch (e) {
    print('❌ [iOS] URL监听初始化失败: $e');
    // 不抛出异常，避免影响应用启动
  }
}

class NoGlowScrollBehavior extends MaterialScrollBehavior {
  const NoGlowScrollBehavior();
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // 去除 Android 上的发光效果，避免顶部出现一抹红
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  // 根据初始化状态和欢迎页面状态决定显示哪个页面
  Widget _getHomePage(AppInitState initState, WidgetRef ref) {
    // 首先检查是否需要显示欢迎页面
    final shouldShowWelcome = ref.watch(shouldShowWelcomeProvider);
    if (shouldShowWelcome) {
      return const WelcomePage();
    }

    // 欢迎页面完成后，根据初始化状态显示对应页面
    if (initState != AppInitState.ready) {
      return const SplashPage();
    }

    return const BeeApp();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 首先检查是否需要显示欢迎页面
    ref.watch(welcomeCheckProvider);

    // 检查应用初始化状态
    final initState = ref.watch(appInitStateProvider);
    final selectedLanguage = ref.watch(languageProvider);

    // 如果是启屏状态，启动初始化
    if (initState == AppInitState.splash) {
      ref.watch(appSplashInitProvider);
    }
    
    final primary = ref.watch(primaryColorProvider);
    final platform = Theme.of(context).platform; // 当前平台
    final base = BeeTheme.lightTheme(platform: platform);
    final baseTextTheme = base.textTheme;

    final theme = base.copyWith(
      textTheme: baseTextTheme,
      colorScheme: base.colorScheme.copyWith(primary: primary),
      primaryColor: primary,
      scaffoldBackgroundColor: Colors.white,
      dividerColor: BeeColors.divider,
      listTileTheme: const ListTileThemeData(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        iconColor: BeeColors.primaryText,
      ),
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: baseTextTheme.titleMedium?.copyWith(
            color: BeeColors.primaryText, fontWeight: FontWeight.w600),
        contentTextStyle:
            baseTextTheme.bodyMedium?.copyWith(color: BeeColors.secondaryText),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: baseTextTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        selectedItemColor: primary,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: base.cardTheme.copyWith(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
    );
    // Clamp 系统字体缩放，避免部分设备设置 1.5+ 造成 UI 溢出
    final media = MediaQuery.of(context);
    // init font scale persistence
    ref.watch(fontScaleInitProvider);
    final customScale = ref.watch(effectiveFontScaleProvider);
    final clamped = media.textScaler.clamp(
      minScaleFactor: 0.85,
      maxScaleFactor: 1.15,
    );
    final combinedScale = clamped.scale(customScale); // returns double
    final newScaler = TextScaler.linear(combinedScale);
    return MediaQuery(
      data: media.copyWith(textScaler: newScaler),
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        scrollBehavior: const NoGlowScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: theme,
        themeMode: ThemeMode.light,
        navigatorObservers: [LoggingNavigatorObserver()],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('zh'),
          Locale('zh', 'TW'),
          Locale('ja'),
          Locale('ko'),
          Locale('es'),
          Locale('fr'),
          Locale('de'),
        ],
        locale: selectedLanguage,
        // 显式命名根路由，便于路由日志与 popUntil 精确识别
        home: _getHomePage(initState, ref),
        onGenerateRoute: (settings) {
          if (settings.name == Navigator.defaultRouteName ||
              settings.name == '/') {
            return MaterialPageRoute(
                builder: (_) => _getHomePage(initState, ref),
                settings: const RouteSettings(name: '/'));
          }
          return null;
        },
      ),
    );
  }
}
