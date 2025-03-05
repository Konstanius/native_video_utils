
import 'native_video_utils_platform_interface.dart';

class NativeVideoUtils {
  Future<String?> getPlatformVersion() {
    return NativeVideoUtilsPlatform.instance.getPlatformVersion();
  }
}
