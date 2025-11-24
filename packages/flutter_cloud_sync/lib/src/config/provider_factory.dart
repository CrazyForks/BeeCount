import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_cloud_sync_supabase/flutter_cloud_sync_supabase.dart';
import 'package:flutter_cloud_sync_webdav/flutter_cloud_sync_webdav.dart';
import 'package:flutter_cloud_sync_icloud/flutter_cloud_sync_icloud.dart';

import '../core/auth_service.dart';
import '../core/cloud_provider.dart';
import 'cloud_service_config.dart';

/// 根据 CloudServiceConfig 创建对应的 CloudProvider 和 CloudAuthService
///
/// 返回 (CloudProvider, CloudAuthService) 元组
///
/// 支持:
/// - Supabase: 使用独立包内的初始化逻辑
/// - WebDAV: 创建新的 WebDAV provider
Future<({CloudProvider? provider, CloudAuthService? auth})> createCloudServices(
  CloudServiceConfig config,
) async {
  if (!config.valid) {
    return (provider: null, auth: null);
  }

  switch (config.type) {
    case CloudBackendType.local:
      return (provider: null, auth: null);

    case CloudBackendType.supabase:
      // 创建并初始化 Supabase provider
      // 包内会处理重复初始化的问题
      final provider = SupabaseProvider();
      await provider.initialize({
        'url': config.supabaseUrl!,
        'anonKey': config.supabaseAnonKey!,
        'bucket': 'beecount-backups',
      });

      // Auth service 直接从 provider 获取
      final auth = provider.auth;

      return (provider: provider, auth: auth);

    case CloudBackendType.webdav:
      final provider = WebDAVProvider();
      await provider.initialize({
        'url': config.webdavUrl!,
        'username': config.webdavUsername!,
        'password': config.webdavPassword!,
        'remotePath': config.webdavRemotePath ?? '/',
      });

      final auth = provider.auth;

      return (provider: provider, auth: auth);

    case CloudBackendType.icloud:
      // iCloud 仅支持 iOS/iPadOS
      if (kIsWeb || !Platform.isIOS) {
        return (provider: null, auth: null);
      }

      try {
        final provider = ICloudProvider();
        await provider.initialize({});

        final auth = provider.auth;

        return (provider: provider, auth: auth);
      } catch (e) {
        // iCloud 不可用（未登录等），返回 null
        return (provider: null, auth: null);
      }
  }
}

/// 兼容旧代码的方法
@Deprecated('Use createCloudServices instead')
Future<CloudProvider?> createCloudProvider(CloudServiceConfig config) async {
  final services = await createCloudServices(config);
  return services.provider;
}
