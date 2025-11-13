import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers.dart';

/// 统一处理本地变更后的同步逻辑：
/// - 始终先标记本地变更（使缓存失效）
/// - 若开启自动同步：先上传，上传完成后刷新同步状态；支持后台静默（不阻塞UI）
/// - 若未开启自动同步：立即刷新同步状态（应显示“本地较新”）
Future<void> handleLocalChange(WidgetRef ref,
    {required int ledgerId, bool background = true}) async {
  print('🔵 [handleLocalChange] 开始处理账本变更: ledgerId=$ledgerId, background=$background');

  // 失效缓存
  final sync = ref.read(syncServiceProvider);
  try {
    sync.markLocalChanged(ledgerId: ledgerId);
    print('🔵 [handleLocalChange] markLocalChanged 已调用');
  } catch (_) {}

  // 检查是否自动同步
  bool auto = false;
  try {
    final prefs = await SharedPreferences.getInstance();
    auto = prefs.getBool('auto_sync') ?? false;
    print('🔵 [handleLocalChange] 自动同步开关状态: $auto');
  } catch (_) {}

  // 始终立即刷新一次状态，确保UI及时反映本地变更
  final oldValue = ref.read(syncStatusRefreshProvider);
  ref.read(syncStatusRefreshProvider.notifier).state++;
  print('🔵 [handleLocalChange] syncStatusRefreshProvider 触发: $oldValue -> ${ref.read(syncStatusRefreshProvider)}');

  // 刷新账本列表数据（笔数、余额、时间）
  ref.read(ledgerListRefreshProvider.notifier).state++;
  print('🔵 [handleLocalChange] ledgerListRefreshProvider 触发，刷新账本列表数据');

  if (auto) {
    print('🔵 [handleLocalChange] 自动同步已开启，准备上传');
  } else {
    print('🔵 [handleLocalChange] 自动同步已关闭，跳过上传');
  }

  if (auto) {
    if (background) {
      final refresh = ref.read(syncStatusRefreshProvider.notifier);
      // 背景静默上传：完成后再刷新一次状态
      Future(() async {
        try {
          await sync.uploadCurrentLedger(ledgerId: ledgerId);
          refresh.state++;
        } catch (_) {}
      });
    } else {
      try {
        await sync.uploadCurrentLedger(ledgerId: ledgerId);
        ref.read(syncStatusRefreshProvider.notifier).state++;
      } catch (_) {}
    }
  }
}
