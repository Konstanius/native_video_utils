package me.konstanius.native_video_utils;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * NativeVideoUtilsPlugin
 */
public class NativeVideoUtilsPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "native_video_utils");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "trimVideo": {
                String inputPath = call.argument("inputPath");
                String outputPath = call.argument("outputPath");
                Integer startMs = Integer.parseInt(call.argument("startMs"));
                Integer endMs = Integer.parseInt(call.argument("endMs"));

                try {
                    result.success(VideoUtils.trimVideo(inputPath, outputPath, startMs, endMs));
                } catch (Exception e) {
                    result.success(e.toString());
                }
                break;
            }
            case "rotateVideo": {
                String inputPath = call.argument("inputPath");
                String outputPath = call.argument("outputPath");
                Integer rotationSteps = Integer.parseInt(call.argument("rotationSteps"));

                try {
                    result.success(VideoUtils.rotateVideo(inputPath, outputPath, rotationSteps));
                } catch (Exception e) {
                    result.success(e.toString());
                }
                break;
            }
            default: {
                result.notImplemented();
            }
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
