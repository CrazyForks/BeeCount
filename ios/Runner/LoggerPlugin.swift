import Flutter
import Foundation

/// 日志插件 - 将 iOS 原生日志发送到 Flutter
class LoggerPlugin {
    static var channel: FlutterMethodChannel?

    /// 设置通道
    static func setup(channel: FlutterMethodChannel) {
        self.channel = channel
    }

    /// 发送日志到 Flutter
    static func log(level: String, tag: String, message: String) {
        let args: [String: Any] = [
            "platform": "ios",
            "level": level,
            "tag": tag,
            "message": message,
            "timestamp": Int64(Date().timeIntervalSince1970 * 1000)
        ]

        channel?.invokeMethod("onNativeLog", arguments: args)
    }

    // 便捷方法
    static func debug(tag: String, message: String) {
        log(level: "DEBUG", tag: tag, message: message)
    }

    static func info(tag: String, message: String) {
        log(level: "INFO", tag: tag, message: message)
    }

    static func warning(tag: String, message: String) {
        log(level: "WARNING", tag: tag, message: message)
    }

    static func error(tag: String, message: String) {
        log(level: "ERROR", tag: tag, message: message)
    }
}
