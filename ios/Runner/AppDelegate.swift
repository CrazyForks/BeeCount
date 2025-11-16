import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // 设置通知中心代理
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    // 设置日志插件
    let controller = window?.rootViewController as! FlutterViewController
    let loggerChannel = FlutterMethodChannel(
      name: "com.beecount.logger",
      binaryMessenger: controller.binaryMessenger
    )
    LoggerPlugin.setup(channel: loggerChannel)

    // 测试日志
    LoggerPlugin.info(tag: "AppDelegate", message: "日志系统已初始化")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 前台显示通知
  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // 在前台也显示通知
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }

  // 处理通知点击
  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}

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
