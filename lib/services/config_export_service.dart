import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter_cloud_sync/flutter_cloud_sync.dart';
import '../utils/logger.dart';

/// 应用配置模型
class AppConfig {
  final SupabaseConfig? supabase;
  final WebdavConfig? webdav;
  final AIConfig? ai;

  const AppConfig({
    this.supabase,
    this.webdav,
    this.ai,
  });

  Map<String, dynamic> toYaml() {
    final map = <String, dynamic>{};

    if (supabase != null) {
      map['supabase'] = supabase!.toMap();
    }

    if (webdav != null) {
      map['webdav'] = webdav!.toMap();
    }

    if (ai != null) {
      map['ai'] = ai!.toMap();
    }

    return map;
  }

  static AppConfig fromYaml(Map<dynamic, dynamic> yaml) {
    return AppConfig(
      supabase: yaml.containsKey('supabase')
          ? SupabaseConfig.fromMap(
              Map<String, dynamic>.from(yaml['supabase'] as Map))
          : null,
      webdav: yaml.containsKey('webdav')
          ? WebdavConfig.fromMap(
              Map<String, dynamic>.from(yaml['webdav'] as Map))
          : null,
      ai: yaml.containsKey('ai')
          ? AIConfig.fromMap(Map<String, dynamic>.from(yaml['ai'] as Map))
          : null,
    );
  }
}

/// Supabase配置
class SupabaseConfig {
  final String url;
  final String anonKey;

  const SupabaseConfig({
    required this.url,
    required this.anonKey,
  });

  Map<String, dynamic> toMap() => {
        'url': url,
        'anon_key': anonKey,
      };

  static SupabaseConfig fromMap(Map<String, dynamic> map) => SupabaseConfig(
        url: map['url'] as String,
        anonKey: map['anon_key'] as String,
      );
}

/// WebDAV配置
class WebdavConfig {
  final String url;
  final String username;
  final String password;
  final String? remotePath;

  const WebdavConfig({
    required this.url,
    required this.username,
    required this.password,
    this.remotePath,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'url': url,
      'username': username,
      'password': password,
    };
    if (remotePath != null && remotePath!.isNotEmpty) {
      map['remote_path'] = remotePath;
    }
    return map;
  }

  static WebdavConfig fromMap(Map<String, dynamic> map) => WebdavConfig(
        url: map['url'] as String,
        username: map['username'] as String,
        password: map['password'] as String,
        remotePath: map['remote_path'] as String?,
      );
}

/// AI配置
class AIConfig {
  final String? glmApiKey;
  final String? strategy;
  final bool? enabled;

  const AIConfig({
    this.glmApiKey,
    this.strategy,
    this.enabled,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (glmApiKey != null && glmApiKey!.isNotEmpty) {
      map['glm_api_key'] = glmApiKey;
    }
    if (strategy != null && strategy!.isNotEmpty) {
      map['strategy'] = strategy;
    }
    if (enabled != null) {
      map['enabled'] = enabled;
    }
    return map;
  }

  static AIConfig fromMap(Map<String, dynamic> map) => AIConfig(
        glmApiKey: map['glm_api_key'] as String?,
        strategy: map['strategy'] as String?,
        enabled: map['enabled'] as bool?,
      );
}

/// 配置导入导出服务
class ConfigExportService {
  /// 导出配置到YAML字符串
  static Future<String> exportToYaml() async {
    final prefs = await SharedPreferences.getInstance();

    // 读取Supabase配置
    SupabaseConfig? supabaseConfig;
    final supabaseCfgRaw = prefs.getString('cloud_supabase_cfg');
    if (supabaseCfgRaw != null) {
      try {
        final cfg = decodeCloudConfig(supabaseCfgRaw);
        if (cfg.supabaseUrl != null && cfg.supabaseAnonKey != null) {
          supabaseConfig = SupabaseConfig(
            url: cfg.supabaseUrl!,
            anonKey: cfg.supabaseAnonKey!,
          );
        }
      } catch (e) {
        logW('ConfigExport', '读取Supabase配置失败: $e');
      }
    }

    // 读取WebDAV配置
    WebdavConfig? webdavConfig;
    final webdavCfgRaw = prefs.getString('cloud_webdav_cfg');
    if (webdavCfgRaw != null) {
      try {
        final cfg = decodeCloudConfig(webdavCfgRaw);
        if (cfg.webdavUrl != null &&
            cfg.webdavUsername != null &&
            cfg.webdavPassword != null) {
          webdavConfig = WebdavConfig(
            url: cfg.webdavUrl!,
            username: cfg.webdavUsername!,
            password: cfg.webdavPassword!,
            remotePath: cfg.webdavRemotePath,
          );
        }
      } catch (e) {
        logW('ConfigExport', '读取WebDAV配置失败: $e');
      }
    }

    // 读取AI配置
    AIConfig? aiConfig;
    final glmApiKey = prefs.getString('ai_glm_api_key');
    final aiStrategy = prefs.getString('ai_strategy');
    final aiEnabled = prefs.getBool('ai_bill_extraction_enabled');

    if (glmApiKey != null || aiStrategy != null || aiEnabled != null) {
      aiConfig = AIConfig(
        glmApiKey: glmApiKey,
        strategy: aiStrategy,
        enabled: aiEnabled,
      );
    }

    final config = AppConfig(
      supabase: supabaseConfig,
      webdav: webdavConfig,
      ai: aiConfig,
    );

    // 转换为YAML格式
    final yamlMap = config.toYaml();

    // 手动构建YAML字符串以保持良好格式
    final buffer = StringBuffer();
    buffer.writeln('# BeeCount 应用配置');
    buffer.writeln('# 导出时间: ${DateTime.now().toIso8601String()}');
    buffer.writeln();

    if (yamlMap.containsKey('supabase')) {
      buffer.writeln('supabase:');
      final sb = yamlMap['supabase'] as Map<String, dynamic>;
      buffer.writeln('  url: "${sb['url']}"');
      buffer.writeln('  anon_key: "${sb['anon_key']}"');
      buffer.writeln();
    }

    if (yamlMap.containsKey('webdav')) {
      buffer.writeln('webdav:');
      final wd = yamlMap['webdav'] as Map<String, dynamic>;
      buffer.writeln('  url: "${wd['url']}"');
      buffer.writeln('  username: "${wd['username']}"');
      buffer.writeln('  password: "${wd['password']}"');
      if (wd.containsKey('remote_path')) {
        buffer.writeln('  remote_path: "${wd['remote_path']}"');
      }
      buffer.writeln();
    }

    if (yamlMap.containsKey('ai')) {
      buffer.writeln('ai:');
      final ai = yamlMap['ai'] as Map<String, dynamic>;
      if (ai.containsKey('glm_api_key')) {
        buffer.writeln('  glm_api_key: "${ai['glm_api_key']}"');
      }
      if (ai.containsKey('strategy')) {
        buffer.writeln('  strategy: "${ai['strategy']}"');
      }
      if (ai.containsKey('enabled')) {
        buffer.writeln('  enabled: ${ai['enabled']}');
      }
    }

    return buffer.toString();
  }

  /// 从YAML字符串导入配置
  static Future<void> importFromYaml(String yamlContent) async {
    final doc = loadYaml(yamlContent);

    if (doc is! Map) {
      throw const FormatException('无效的YAML格式');
    }

    final config = AppConfig.fromYaml(doc);
    final prefs = await SharedPreferences.getInstance();

    // 导入Supabase配置
    if (config.supabase != null) {
      final supabaseCfg = CloudServiceConfig(
        type: CloudBackendType.supabase,
        name: 'Supabase',
        supabaseUrl: config.supabase!.url,
        supabaseAnonKey: config.supabase!.anonKey,
      );
      await prefs.setString(
          'cloud_supabase_cfg', encodeCloudConfig(supabaseCfg));
      logI('ConfigImport', 'Supabase配置已导入');
    }

    // 导入WebDAV配置
    if (config.webdav != null) {
      final webdavCfg = CloudServiceConfig(
        type: CloudBackendType.webdav,
        name: 'WebDAV',
        webdavUrl: config.webdav!.url,
        webdavUsername: config.webdav!.username,
        webdavPassword: config.webdav!.password,
        webdavRemotePath: config.webdav!.remotePath,
      );
      await prefs.setString('cloud_webdav_cfg', encodeCloudConfig(webdavCfg));
      logI('ConfigImport', 'WebDAV配置已导入');
    }

    // 导入AI配置
    if (config.ai != null) {
      if (config.ai!.glmApiKey != null) {
        await prefs.setString('ai_glm_api_key', config.ai!.glmApiKey!);
      }
      if (config.ai!.strategy != null) {
        await prefs.setString('ai_strategy', config.ai!.strategy!);
      }
      if (config.ai!.enabled != null) {
        await prefs.setBool('ai_bill_extraction_enabled', config.ai!.enabled!);
      }
      logI('ConfigImport', 'AI配置已导入');
    }
  }

  /// 导出配置到文件
  static Future<void> exportToFile(String filePath) async {
    final yamlContent = await exportToYaml();
    final file = File(filePath);
    await file.writeAsString(yamlContent);
    logI('ConfigExport', '配置已导出到: $filePath');
  }

  /// 从文件导入配置
  static Future<void> importFromFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('文件不存在: $filePath');
    }

    final yamlContent = await file.readAsString();
    await importFromYaml(yamlContent);
    logI('ConfigImport', '配置已从文件导入: $filePath');
  }
}
