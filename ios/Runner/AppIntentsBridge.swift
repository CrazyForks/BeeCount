import Foundation
import Flutter

/// AppIntents桥接插件
/// 使用弱链接支持iOS 15.0+，AppIntents功能仅在iOS 16+可用
@available(iOS 13.0, *)
class AppIntentsBridge: NSObject, FlutterPlugin {
    static let channelName = "com.beecount.app_intents"
    private static var eventChannel: FlutterEventChannel?
    private static var eventSink: FlutterEventSink?

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: registrar.messenger()
        )

        let instance = AppIntentsBridge()
        registrar.addMethodCallDelegate(instance, channel: channel)

        // 创建事件通道用于发送AppIntent事件
        eventChannel = FlutterEventChannel(
            name: "\(channelName)/events",
            binaryMessenger: registrar.messenger()
        )
        eventChannel?.setStreamHandler(instance)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isSupported":
            // 检查是否支持AppIntents（iOS 16+）
            if #available(iOS 16.0, *) {
                result(true)
            } else {
                result(false)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// 从AppIntent发送事件到Flutter
    static func sendEvent(_ event: String) {
        DispatchQueue.main.async {
            eventSink?(event)
        }
    }
}

// MARK: - FlutterStreamHandler
@available(iOS 13.0, *)
extension AppIntentsBridge: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        AppIntentsBridge.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        AppIntentsBridge.eventSink = nil
        return nil
    }
}
