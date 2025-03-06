import Flutter
import UIKit

public class NativeVideoUtilsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_video_utils", binaryMessenger: registrar.messenger())
    let instance = NativeVideoUtilsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "trimVideo":
      let inputPath = call.argument("inputPath")!
      let outputPath = call.argument("outputPath")!
      let start = call.argument("start")!
      let end = call.argument("end")!

      result(VideoUtils.trimVideo(inputPath, outputPath, start, end))
    case "rotateVideo":
      let inputPath = call.argument("inputPath")!
      let outputPath = call.argument("outputPath")!
      let rotation = call.argument("rotation")!

      result(VideoUtils.rotateVideo(inputPath, outputPath, rotation))
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
