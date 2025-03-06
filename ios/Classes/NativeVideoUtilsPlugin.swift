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
      let start = call.argument("startMs")!
      let end = call.argument("endMs")!

      result(VideoUtils.trimVideo(srcPath: inputPath, dstPath: outputPath, startMs: start, endMs: end))
    case "rotateVideo":
      let inputPath = call.argument("inputPath")!
      let outputPath = call.argument("outputPath")!
      let rotation = call.argument("rotationSteps")!

      result(VideoUtils.rotateVideo(srcPath: inputPath, dstPath: outputPath, rotationSteps: rotation))
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
