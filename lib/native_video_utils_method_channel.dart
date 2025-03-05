import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_video_utils_platform_interface.dart';

/// An implementation of [NativeVideoUtilsPlatform] that uses method channels.
class MethodChannelNativeVideoUtils extends NativeVideoUtilsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_video_utils');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
