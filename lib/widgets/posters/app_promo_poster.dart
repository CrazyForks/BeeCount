/// 应用推广海报Widget
library;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../l10n/app_localizations.dart';

/// 应用推广海报
class AppPromoPoster extends StatelessWidget {
  final AppLocalizations l10n;
  final Color primaryColor;

  const AppPromoPoster({
    super.key,
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
