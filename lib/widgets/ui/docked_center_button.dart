import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'speed_dial_fab.dart';

/// 闲鱼风格的底部导航栏（带中间凸起按钮）
class XianYuBottomBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomBarItem> items;
  final CenterButtonConfig centerButton;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;

  const XianYuBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.centerButton,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<XianYuBottomBar> createState() => _XianYuBottomBarState();
}

class _XianYuBottomBarState extends State<XianYuBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isOpen = false;
  int? _hoveredIndex;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onLongPressStart(LongPressStartDetails details) {
    if (widget.centerButton.actions.isEmpty) return;
    setState(() {
      _isOpen = true;
      _controller.forward();
    });
    _showOverlay();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _updateHoveredIndex(details.globalPosition);
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (_hoveredIndex != null &&
        _hoveredIndex! < widget.centerButton.actions.length) {
      final action = widget.centerButton.actions[_hoveredIndex!];
      if (action.enabled && action.onTap != null) {
        action.onTap!();
      }
    }

    setState(() {
      _isOpen = false;
      _hoveredIndex = null;
      _controller.reverse();
    });
    _removeOverlay();
  }

  GlobalKey centerButtonKey = GlobalKey();

  void _showOverlay() {
    final RenderBox? renderBox =
        centerButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _SpeedDialOverlay(
        buttonPosition: position,
        buttonSize: size,
        actions: widget.centerButton.actions,
        animation: _expandAnimation,
        hoveredIndex: _hoveredIndex,
        backgroundColor: widget.centerButton.backgroundColor,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateHoveredIndex(Offset globalPosition) {
    final RenderBox? renderBox =
        centerButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;
    final buttonCenter = Offset(
      buttonPosition.dx + buttonSize.width / 2,
      buttonPosition.dy + buttonSize.height / 2,
    );

    final angles = [210.0, 270.0, 330.0];
    const distance = 85.0;
    const buttonRadius = 26.0;

    int? newHoveredIndex;
    for (int i = 0;
        i < widget.centerButton.actions.length && i < angles.length;
        i++) {
      final angle = angles[i];
      final radians = angle * math.pi / 180;
      final offsetX = distance * math.cos(radians);
      final offsetY = distance * math.sin(radians);

      final actionCenter = Offset(
        buttonCenter.dx + offsetX,
        buttonCenter.dy + offsetY,
      );

      final dx = globalPosition.dx - actionCenter.dx;
      final dy = globalPosition.dy - actionCenter.dy;
      final distanceToButton = math.sqrt(dx * dx + dy * dy);

      if (distanceToButton <= buttonRadius) {
        newHoveredIndex = i;
        break;
      }
    }

    if (newHoveredIndex != _hoveredIndex) {
      setState(() {
        _hoveredIndex = newHoveredIndex;
      });
      _overlayEntry?.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ??
        (isDark ? const Color(0xFF1C1C1E) : Colors.white);
    final activeColor =
        widget.activeColor ?? Theme.of(context).colorScheme.primary;
    final inactiveColor =
        widget.inactiveColor ?? (isDark ? Colors.white70 : Colors.black54);

    // 凸起高度
    const riseHeight = 22.0;
    // 按钮大小
    const centerButtonSize = 52.0;

    return SizedBox(
      height: 60 + riseHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 背景（带凸起的形状）
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 60 + riseHeight),
              painter: _BottomBarPainter(
                color: bgColor,
                riseHeight: riseHeight,
                centerButtonRadius: centerButtonSize / 2 + 8,
                shadowColor: isDark ? Colors.black54 : Colors.black26,
              ),
            ),
          ),

          // 导航项
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60,
            child: Row(
              children: [
                // 左边两个
                for (int i = 0; i < 2; i++)
                  Expanded(
                    child: _buildNavItem(
                      widget.items[i],
                      i,
                      activeColor,
                      inactiveColor,
                    ),
                  ),
                // 中间占位
                const Expanded(child: SizedBox()),
                // 右边两个
                for (int i = 2; i < 4; i++)
                  Expanded(
                    child: _buildNavItem(
                      widget.items[i],
                      i,
                      activeColor,
                      inactiveColor,
                    ),
                  ),
              ],
            ),
          ),

          // 中间凸起按钮
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Center(
              child: GestureDetector(
                key: centerButtonKey,
                onTap: widget.centerButton.onTap,
                onLongPressStart: _onLongPressStart,
                onLongPressMoveUpdate: _onLongPressMoveUpdate,
                onLongPressEnd: _onLongPressEnd,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 按钮
                    AnimatedBuilder(
                      animation: _expandAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _expandAnimation.value * math.pi / 4,
                          child: Container(
                            width: centerButtonSize,
                            height: centerButtonSize,
                            decoration: BoxDecoration(
                              color: widget.centerButton.backgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isOpen
                                  ? Icons.close
                                  : widget.centerButton.icon,
                              color: widget.centerButton.foregroundColor,
                              size: 28,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    // 标签
                    Text(
                      widget.centerButton.label,
                      style: TextStyle(
                        fontSize: 10,
                        color: inactiveColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BottomBarItem item,
    int index,
    Color activeColor,
    Color inactiveColor,
  ) {
    // 将4个items映射到5个slot中，跳过中间的slot
    final visualIndex = index >= 2 ? index + 1 : index;
    final currentVisualIndex =
        widget.currentIndex >= 2 ? widget.currentIndex + 1 : widget.currentIndex;
    final isActive = currentVisualIndex == visualIndex;
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: color, size: 24),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// 底部栏背景绘制器（带凸起）- 闲鱼风格
class _BottomBarPainter extends CustomPainter {
  final Color color;
  final double riseHeight;
  final double centerButtonRadius;
  final Color shadowColor;

  _BottomBarPainter({
    required this.color,
    required this.riseHeight,
    required this.centerButtonRadius,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final topY = riseHeight;

    // 凸起的半径（比按钮大一点作为边距）
    final bulgeRadius = centerButtonRadius + 6;

    final path = Path();

    // 从左下角开始
    path.moveTo(0, size.height);
    // 左边直线到顶部
    path.lineTo(0, topY);
    // 左边到凸起开始点
    path.lineTo(centerX - bulgeRadius, topY);

    // 使用圆弧绘制凸起（更圆润）
    path.arcToPoint(
      Offset(centerX + bulgeRadius, topY),
      radius: Radius.circular(bulgeRadius),
      clockwise: false,
    );

    // 右边到顶部
    path.lineTo(size.width, topY);
    // 右边直线到底部
    path.lineTo(size.width, size.height);
    // 闭合
    path.close();

    // 绘制背景（不绘制阴影）
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BottomBarPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.riseHeight != riseHeight ||
        oldDelegate.centerButtonRadius != centerButtonRadius;
  }
}

/// 扇形菜单覆盖层
class _SpeedDialOverlay extends StatelessWidget {
  final Offset buttonPosition;
  final Size buttonSize;
  final List<SpeedDialAction> actions;
  final Animation<double> animation;
  final int? hoveredIndex;
  final Color backgroundColor;

  const _SpeedDialOverlay({
    required this.buttonPosition,
    required this.buttonSize,
    required this.actions,
    required this.animation,
    required this.hoveredIndex,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonCenter = Offset(
      buttonPosition.dx + buttonSize.width / 2,
      buttonPosition.dy + buttonSize.height / 2,
    );

    final angles = [210.0, 270.0, 330.0];
    const distance = 85.0;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        if (animation.value == 0) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            // 半透明背景
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3 * animation.value),
                ),
              ),
            ),
            // 扇形按钮
            for (int i = 0; i < actions.length && i < angles.length; i++)
              _buildActionButton(
                context,
                actions[i],
                angles[i],
                distance,
                buttonCenter,
                i == hoveredIndex,
              ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    SpeedDialAction action,
    double angle,
    double distance,
    Offset buttonCenter,
    bool isHovered,
  ) {
    final radians = angle * math.pi / 180;
    final progress = animation.value;
    final offsetX = progress * distance * math.cos(radians);
    final offsetY = progress * distance * math.sin(radians);

    const buttonSize = 48.0;
    final left = buttonCenter.dx + offsetX - buttonSize / 2;
    final top = buttonCenter.dy + offsetY - buttonSize / 2;

    final bool isEnabled = action.enabled;
    final Color bgColor = isEnabled ? backgroundColor : Colors.grey.shade400;

    return Positioned(
      left: left,
      top: top,
      child: Transform.scale(
        scale: progress,
        child: Opacity(
          opacity: progress,
          child: AnimatedScale(
            scale: isHovered ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: Material(
              color: bgColor,
              shape: const CircleBorder(),
              elevation: isHovered ? 8 : 4,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isHovered
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                ),
                child: Icon(
                  action.icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 底部导航栏项配置
class BottomBarItem {
  final IconData icon;
  final String label;

  const BottomBarItem({
    required this.icon,
    required this.label,
  });
}

/// 中间按钮配置
class CenterButtonConfig {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onTap;
  final List<SpeedDialAction> actions;

  const CenterButtonConfig({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.onTap,
    this.actions = const [],
  });
}
