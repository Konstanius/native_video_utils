import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_video_utils_platform_interface.dart';

/// An implementation of [NativeVideoUtilsPlatform] that uses method channels.
class MethodChannelNativeVideoUtils extends NativeVideoUtilsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_video_utils');

  @override
  Future<String?> trimVideo(String inputPath, String outputPath, int startMs, int endMs) {
    return methodChannel.invokeMethod<String>('trimVideo', {
    'inputPath': inputPath,
    'outputPath': outputPath,
    'startMs': "$startMs",
    'endMs': "$endMs",
    });
  }

  @override
  Future<String?> rotateVideo(String inputPath, String outputPath, int rotationSteps) {
    return methodChannel.invokeMethod<String>('rotateVideo', {
    'inputPath': inputPath,
    'outputPath': outputPath,
    'rotationSteps': "$rotationSteps",
    });
  }
}
