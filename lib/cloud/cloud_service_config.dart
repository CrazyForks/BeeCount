import 'dart:convert';

/// 云服务后端类型
enum CloudBackendType {
  supabase,  // Supabase (官方或自建)
  webdav,    // WebDAV (坚果云、Nextcloud、群晖等)
}

class CloudServiceConfig {
  final String id; // 'builtin' | 'custom'
  final CloudBackendType type;
  final String name; // UI 展示名称
  final bool builtin; // 是否内置（不可编辑 / 隐藏真实值）

  // Supabase 配置
  final String? supabaseUrl;
  final String? supabaseAnonKey;

  // WebDAV 配置
  final String? webdavUrl;
  final String? webdavUsername;
  final String? webdavPassword;
  final String? webdavRemotePath;

  const CloudServiceConfig({
    required this.id,
    required this.type,
    required this.name,
    this.builtin = false,
    // Supabase
    this.supabaseUrl,
    this.supabaseAnonKey,
    // WebDAV
    this.webdavUrl,
    this.webdavUsername,
    this.webdavPassword,
    this.webdavRemotePath,
  });

  bool get valid {
    switch (type) {
      case CloudBackendType.supabase:
        return (supabaseUrl?.isNotEmpty ?? false) &&
               (supabaseAnonKey?.isNotEmpty ?? false);
      case CloudBackendType.webdav:
        return (webdavUrl?.isNotEmpty ?? false) &&
               (webdavUsername?.isNotEmpty ?? false) &&
               (webdavPassword?.isNotEmpty ?? false);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'name': name,
        'builtin': builtin,
        // Supabase
        'supabaseUrl': supabaseUrl,
        'supabaseAnonKey': supabaseAnonKey,
        // WebDAV
        'webdavUrl': webdavUrl,
        'webdavUsername': webdavUsername,
        'webdavPassword': webdavPassword,
        'webdavRemotePath': webdavRemotePath,
      };

  static CloudServiceConfig fromJson(Map<String, dynamic> j) =>
      CloudServiceConfig(
        id: j['id'] as String,
        type: CloudBackendType.values
            .firstWhere((e) => e.name == j['type'] as String),
        name: j['name'] as String,
        builtin: j['builtin'] == true,
        // Supabase
        supabaseUrl: j['supabaseUrl'] as String?,
        supabaseAnonKey: j['supabaseAnonKey'] as String?,
        // WebDAV
        webdavUrl: j['webdavUrl'] as String?,
        webdavUsername: j['webdavUsername'] as String?,
        webdavPassword: j['webdavPassword'] as String?,
        webdavRemotePath: j['webdavRemotePath'] as String?,
      );

  static CloudServiceConfig builtinDefault({String? url, String? key}) =>
      CloudServiceConfig(
        id: 'builtin',
        type: CloudBackendType.supabase,
        name: '__DEFAULT_CLOUD_SERVICE__', // 特殊标记，在UI层处理本地化
        supabaseUrl: url?.isNotEmpty == true ? url : null,
        supabaseAnonKey: key?.isNotEmpty == true ? key : null,
        builtin: true,
      );

  String obfuscatedUrl() {
    switch (type) {
      case CloudBackendType.supabase:
        if (supabaseUrl == null || supabaseUrl!.isEmpty) {
          return '__NOT_CONFIGURED__'; // 特殊标记，在UI层处理本地化
        }
        // 仅显示域名部分（隐藏具体 path / 项目 id）
        try {
          final uri = Uri.parse(supabaseUrl!);
          return uri.host; // 不展示 scheme 与后缀
        } catch (_) {
          return '***';
        }

      case CloudBackendType.webdav:
        if (webdavUrl == null || webdavUrl!.isEmpty) {
          return '__NOT_CONFIGURED__';
        }
        // 显示WebDAV服务器地址的域名部分
        try {
          final uri = Uri.parse(webdavUrl!);
          return uri.host;
        } catch (_) {
          return '***';
        }
    }
  }
}

String encodeCloudConfig(CloudServiceConfig c) => jsonEncode(c.toJson());
CloudServiceConfig decodeCloudConfig(String raw) =>
    CloudServiceConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
