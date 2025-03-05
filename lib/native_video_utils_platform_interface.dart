import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_video_utils_method_channel.dart';

abstract class NativeVideoUtilsPlatform extends PlatformInterface {
  /// Constructs a NativeVideoUtilsPlatform.
  NativeVideoUtilsPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeVideoUtilsPlatform _instance = MethodChannelNativeVideoUtils();

  /// The default instance of [NativeVideoUtilsPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeVideoUtils].
  static NativeVideoUtilsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeVideoUtilsPlatform] when
  /// they register themselves.
  static set instance(NativeVideoUtilsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> trimVideo(String inputPath, String outputPath, int startMs, int endMs) {
    throw UnimplementedError('trimVideo() has not been implemented.');
  }

  Future<String?> rotateVideo(String inputPath, String outputPath, int rotationSteps) {
    throw UnimplementedError('rotateVideo() has not been implemented.');
  }
}
