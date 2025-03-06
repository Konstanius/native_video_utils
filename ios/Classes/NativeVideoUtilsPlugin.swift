import Flutter
import UIKit

public class NativeVideoUtilsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_video_utils", binaryMessenger: registrar.messenger())
    let instance = NativeVideoUtilsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if let args = call.arguments as? Dictionary<String, Any> {
      switch call.method {
      case "trimVideo":
        let inputPath = args["inputPath"] as! String
        let outputPath = args["outputPath"] as! String
        let start = Int(args["startMs"]!) as! String
        let end = Int(args["endMs"] as String!)!

        result(VideoUtils.trimVideo(srcPath: inputPath, dstPath: outputPath, startMs: start, endMs: end))
      case "rotateVideo":
        let inputPath = args["inputPath"] as! String
        let outputPath = args["outputPath"] as! String
        let rotation = Int(args["rotationSteps"] as! String)!

        result(VideoUtils.rotateVideo(srcPath: inputPath, dstPath: outputPath, rotationSteps: rotation))
      default:
        result(FlutterMethodNotImplemented)
      }
    } else {
        result(FlutterMethodNotImplemented)
    }
  }
}
