import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../l10n/app_localizations.dart';
import '../widgets/ui/ui.dart';
import '../providers/theme_providers.dart';

/// 保存海报结果
enum SavePosterResult {
  success,
  failed,
  accessDenied,
}

/// 分享海报生成服务
class SharePosterService {
  /// 生成分享海报图片数据
  static Future<Uint8List?> generatePoster(BuildContext context, Color primaryColor) async {
    try {
      final l10n = AppLocalizations.of(context);

      // 创建海报Widget的GlobalKey
      final GlobalKey posterKey = GlobalKey();

      // 构建海报Widget
      final posterWidget = RepaintBoundary(
        key: posterKey,
        child: _SharePosterWidget(
          l10n: l10n,
          primaryColor: primaryColor,
        ),
      );

      // 使用OverlayEntry来渲染Widget
      final overlay = Overlay.of(context);
      late OverlayEntry overlayEntry;
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: -10000, // 移出屏幕外
          top: -10000,
          child: Material(
            color: Colors.transparent,
            child: posterWidget,
          ),
        ),
      );

      overlay.insert(overlayEntry);

      // 等待Widget渲染完成
      await Future.delayed(const Duration(milliseconds: 500));

      // 获取RenderRepaintBoundary
      final RenderRepaintBoundary boundary =
          posterKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // 转换为图片
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 移除OverlayEntry
      overlayEntry.remove();

      return pngBytes;
    } catch (e) {
      return null;
    }
  }

  /// 保存海报到相册
  static Future<SavePosterResult> savePosterToGallery(Uint8List imageBytes) async {
    try {
      // 使用 Gal 保存图片，会自动处理权限
      await Gal.putImageBytes(imageBytes);
      return SavePosterResult.success;
    } on GalException catch (e) {
      // 处理 Gal 特定异常
      if (e.type == GalExceptionType.accessDenied) {
        return SavePosterResult.accessDenied;
      }
      return SavePosterResult.failed;
    } catch (e) {
      return SavePosterResult.failed;
    }
  }

  /// 分享海报
  static Future<void> sharePoster(Uint8List imageBytes) async {
    try {
      // 获取临时目录
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/beecount_share_${DateTime.now().millisecondsSinceEpoch}.png');

      // 写入文件
      await file.writeAsBytes(imageBytes);

      // 分享文件
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'BeeCount - 蜜蜂记账',
      );
    } catch (e) {
      // 忽略错误
    }
  }

  /// 显示海报预览对话框
  static Future<void> showPosterPreview(BuildContext context, Uint8List imageBytes) async {
    final l10n = AppLocalizations.of(context);

    await showDialog(
      context: context,
      builder: (context) => _PosterPreviewDialog(
        imageBytes: imageBytes,
        l10n: l10n,
      ),
    );
  }
}

/// 海报预览对话框
class _PosterPreviewDialog extends StatefulWidget {
  final Uint8List imageBytes;
  final AppLocalizations l10n;

  const _PosterPreviewDialog({
    required this.imageBytes,
    required this.l10n,
  });

  @override
  State<_PosterPreviewDialog> createState() => _PosterPreviewDialogState();
}

class _PosterPreviewDialogState extends State<_PosterPreviewDialog> {
  bool _isSaving = false;

  Future<void> _savePoster() async {
    setState(() => _isSaving = true);

    final result = await SharePosterService.savePosterToGallery(widget.imageBytes);

    if (!mounted) return;

    setState(() => _isSaving = false);

    switch (result) {
      case SavePosterResult.success:
        showToast(context, widget.l10n.sharePosterSaveSuccess);
        Navigator.pop(context);
        break;
      case SavePosterResult.accessDenied:
        // 权限被拒绝
        showToast(context, widget.l10n.sharePosterPermissionDenied);
        break;
      case SavePosterResult.failed:
        // 保存失败
        showToast(context, widget.l10n.sharePosterSaveFailed);
        break;
    }
  }

  Future<void> _sharePoster() async {
    await SharePosterService.sharePoster(widget.imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final primaryColor = ref.watch(primaryColorProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 海报预览 - 占据大部分空间
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 600),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.memory(
                  widget.imageBytes,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 操作按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _sharePoster,
                    icon: Icon(Icons.share_outlined, color: primaryColor),
                    label: Text(widget.l10n.sharePosterShare),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: primaryColor,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _savePoster,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Icon(Icons.download_outlined, color: Colors.white),
                    label: Text(widget.l10n.sharePosterSave),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}

/// 分享海报Widget
class _SharePosterWidget extends StatelessWidget {
  final AppLocalizations l10n;
  final Color primaryColor;

  const _SharePosterWidget({
    required this.l10n,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    // 创建主题色的渐变背景
    final lightColor = Color.lerp(primaryColor, Colors.white, 0.9)!;
    final mediumColor = Color.lerp(primaryColor, Colors.white, 0.8)!;

    return Container(
      width: 750,
      height: 1334,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [lightColor, mediumColor],
        ),
      ),
      child: Stack(
        children: [
          // 主要内容
          Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 60),
                    // Logo
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(25),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      l10n.sharePosterAppName,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5D4037),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      l10n.sharePosterSlogan,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xFF8D6E63),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 50),
                    // 特点列表
                    _buildFeatureItem(l10n.sharePosterFeature1),
                    const SizedBox(height: 20),
                    _buildFeatureItem(l10n.sharePosterFeature2),
                    const SizedBox(height: 20),
                    _buildFeatureItem(l10n.sharePosterFeature3),
                    const SizedBox(height: 20),
                    _buildFeatureItem(l10n.sharePosterFeature4),
                    const SizedBox(height: 20),
                    _buildFeatureItem(l10n.sharePosterFeature5),
                    const SizedBox(height: 20),
                    _buildFeatureItem(l10n.sharePosterFeature6),
                  ],
                ),
                const SizedBox(height: 50),
                // 二维码
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          QrImageView(
                            data: 'https://github.com/TNT-Likely/BeeCount?utm_source=share_poster&utm_medium=qr_code&utm_campaign=app_share',
                            version: QrVersions.auto,
                            size: 180,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            l10n.sharePosterScanText,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF8D6E63),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'github.com/TNT-Likely/BeeCount',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Color(0xFF5D4037),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
