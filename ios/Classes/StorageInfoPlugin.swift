import Flutter
import UIKit

public class StorageInfoPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.example.storage_info", binaryMessenger: registrar.messenger())
        let instance = StorageInfoPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getStorageInfo":
            let fileURL = URL(fileURLWithPath: NSHomeDirectory())
            do {
                let values = try fileURL.resourceValues(forKeys: [
                    .volumeTotalCapacityKey, .volumeAvailableCapacityForImportantUsageKey,
                ])
                let totalBytes = values.volumeTotalCapacity ?? 0
                let freeBytes = values.volumeAvailableCapacityForImportantUsage ?? 0

                result([
                    "totalBytes": totalBytes,
                    "freeBytes": freeBytes,
                ])
            } catch {
                result(
                    FlutterError(
                        code: "STORAGE_ERROR", message: error.localizedDescription, details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
