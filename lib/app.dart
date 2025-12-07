import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/main/home_page.dart';
import 'pages/main/analytics_page.dart';
import 'pages/main/discover_page.dart';
import 'pages/main/mine_page.dart';
import 'pages/transaction/transaction_editor_page.dart';
import 'providers.dart';
import 'utils/ui_scale_extensions.dart';
import 'l10n/app_localizations.dart';
import 'widget/widget_manager.dart';
import 'widgets/ui/ui.dart';
import 'widgets/ui/speed_dial_fab.dart';
import 'cloud/transactions_sync_manager.dart';
import 'utils/voice_billing_helper.dart';
import 'utils/image_billing_helper.dart';

class BeeApp extends ConsumerStatefulWidget {
  const BeeApp({super.key});

  @override
  ConsumerState<BeeApp> createState() => _BeeAppState();
}

class _BeeAppState extends ConsumerState<BeeApp> with WidgetsBindingObserver {
  final _pages = const [
    HomePage(),
    AnalyticsPage(),
    DiscoverPage(),
    MinePage(),
  ];

  // 双击检测：记录最后一次点击的时间和索引
  DateTime? _lastTapTime;
  int? _lastTappedIndex;

  // 双击返回退出：记录最后一次返回键按下时间
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 后台刷新账本同步状态
    _refreshLedgersStatusInBackground();
  }

  /// 后台刷新账本同步状态
  void _refreshLedgersStatusInBackground() {
    Future.microtask(() async {
      try {
        final syncService = ref.read(syncServiceProvider);
        if (syncService is TransactionsSyncManager) {
          await syncService.refreshAllLedgersStatus();
          // 刷新完成后触发账本列表更新
          ref.read(ledgerListRefreshProvider.notifier).state++;
        }
      } catch (e) {
        // 静默失败，不影响App启动
      }
    });
  }

  /// 检查语音识别是否可用（需要开启AI智能识别并配置GLM API Key）
  Future<bool> _checkGlmApiKeyConfigured() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final aiEnabled = prefs.getBool('ai_bill_extraction_enabled') ?? false;
      final apiKey = prefs.getString('ai_glm_api_key') ?? '';
      return aiEnabled && apiKey.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当app从后台恢复到前台时，更新小组件数据
    if (state == AppLifecycleState.resumed) {
      _updateWidget();
    }
  }

  Future<void> _updateWidget() async {
    try {
      final repository = ref.read(repositoryProvider);
      final ledgerId = ref.read(currentLedgerIdProvider);
      final primaryColor = ref.read(primaryColorProvider);

      final widgetManager = WidgetManager();
      await widgetManager.updateWidget(repository, ledgerId, primaryColor);
      print('✅ App恢复前台，小组件数据已更新');
    } catch (e) {
      print('❌ 更新小组件失败: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    // 将 4 个页面映射到 5 槽位（中间为“+”）：页面索引 0,1,2,3 对应视觉槽位 0,1,3,4（槽位 2 为 +）。
    final idx = ref.watch(bottomTabIndexProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        // 拦截根路由的返回键，避免意外将根路由 pop 到空导致黑屏。
        // 实现双击返回退出应用逻辑
        if (didPop) return;

        final now = DateTime.now();
        final l10n = AppLocalizations.of(context);

        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          // 第一次按返回键，显示提示并记录时间
          _lastBackPressTime = now;
          showToast(context, l10n.commonPressAgainToExit);
        } else {
          // 2秒内第二次按返回键，退出应用
          SystemNavigator.pop();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: IndexedStack(
              index: idx,
              children: _pages,
            ),
            bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1C1C1E)  // ⭐ 暗黑模式：深灰（与卡片同色）
              : Colors.white,             // 亮色模式：白色
          shape: null,  // ⭐ 去掉凹口设计
          notchMargin: 0,
          elevation: 8,  // ⭐ 保持阴影，让Tab栏突起
          child: SizedBox(
            height: 60.0.scaled(context, ref),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (i) {
                if (i == 2) {
                  // 中间预留给 FAB 的槽位，确保 5 等分
                  return const Expanded(child: SizedBox());
                }
                // 槽位转页面索引
                final pageIndex = i > 2 ? i - 1 : i;
                final activeVisualIndex = idx >= 2 ? idx + 1 : idx;
                final active = activeVisualIndex == i;
                final isDark = Theme.of(context).brightness == Brightness.dark;
                Color color = active
                    ? Theme.of(context).colorScheme.primary
                    : (isDark ? Colors.white70 : Colors.black54); // ⭐ 自适应未选中颜色
                IconData icon;
                String label;
                final l10n = AppLocalizations.of(context);
                switch (pageIndex) {
                  case 0:
                    icon = Icons.list_alt_rounded;
                    label = l10n.tabHome;
                    break;
                  case 1:
                    icon = Icons.pie_chart_rounded;
                    label = l10n.tabAnalytics;
                    break;
                  case 2:
                    icon = Icons.explore_rounded;
                    label = l10n.tabDiscover;
                    break;
                  default:
                    icon = Icons.person_rounded;
                    label = l10n.tabMine;
                }
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      final now = DateTime.now();
                      // 检测双击：同一个标签在300ms内连续点击两次
                      if (_lastTappedIndex == pageIndex &&
                          _lastTapTime != null &&
                          now.difference(_lastTapTime!) < const Duration(milliseconds: 300)) {
                        // 双击首页标签，触发滚动到顶部
                        if (pageIndex == 0) {
                          ref.read(homeScrollToTopProvider.notifier).state++;
                        }
                        // 重置双击状态
                        _lastTapTime = null;
                        _lastTappedIndex = null;
                      } else {
                        // 记录本次点击
                        _lastTapTime = now;
                        _lastTappedIndex = pageIndex;
                        // 切换标签
                        ref.read(bottomTabIndexProvider.notifier).state = pageIndex;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0.scaled(context, ref),
                        horizontal: 4.0.scaled(context, ref),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, color: color, size: 24),
                          SizedBox(height: 4.0.scaled(context, ref)),
                          Text(label,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: color,
                                  fontWeight: active
                                      ? FontWeight.w600
                                      : FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        floatingActionButton: Consumer(builder: (context, ref, _) {
          final color = Theme.of(context).colorScheme.primary;
          final l10n = AppLocalizations.of(context);

          return FutureBuilder<bool>(
            future: _checkGlmApiKeyConfigured(),
            builder: (context, snapshot) {
              final isVoiceEnabled = snapshot.data ?? false;

              return SpeedDialFAB(
                      icon: Icons.add,
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      // 短按：直接打开手动记账
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TransactionEditorPage(
                              initialKind: 'expense',
                              quickAdd: true,
                            ),
                          ),
                        );
                      },
                      // 长按：展开扇形菜单
                      actions: [
                        SpeedDialAction(
                          icon: Icons.camera_alt,
                          label: l10n.fabActionCamera,
                          onTap: () => ImageBillingHelper.openCameraForBilling(context, ref),
                        ),
                        SpeedDialAction(
                          icon: Icons.photo_library,
                          label: l10n.fabActionGallery,
                          onTap: () => ImageBillingHelper.pickImageForBilling(context, ref),
                        ),
                        SpeedDialAction(
                          icon: Icons.mic,
                          label: l10n.fabActionVoice,
                          enabled: isVoiceEnabled,
                          disabledTooltip: l10n.fabActionVoiceDisabled,
                          onTap: () => VoiceBillingHelper.startVoiceBilling(context, ref),
                        ),
                      ],
                    );
            },
          );
        }),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
          // 开发模式下的主题切换按钮
          if (kDebugMode)
            Positioned(
              right: 16,
              bottom: 100,
              child: FloatingActionButton.small(
                heroTag: 'themeSwitcher',
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                onPressed: () {
                  final current = ref.read(themeModeProvider);
                  final next = current == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                  ref.read(themeModeProvider.notifier).state = next;
                },
                child: Icon(
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// FAB 长按提示气泡组件（带箭头和呼吸动画）
class _FabTipBubble extends StatefulWidget {
  final String text;
  final Color primaryColor;
  final VoidCallback onDismiss;

  const _FabTipBubble({
    required this.text,
    required this.primaryColor,
    required this.onDismiss,
  });

  @override
  State<_FabTipBubble> createState() => _FabTipBubbleState();
}

class _FabTipBubbleState extends State<_FabTipBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onDismiss,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 气泡主体
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.touch_app,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
            // 箭头指向 FAB
            CustomPaint(
              size: const Size(16, 10),
              painter: _ArrowPainter(color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// 箭头绘制器
class _ArrowPainter extends CustomPainter {
  final Color color;

  _ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


