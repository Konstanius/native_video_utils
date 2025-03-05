import 'package:flutter_test/flutter_test.dart';
import 'package:native_video_utils/native_video_utils.dart';
import 'package:native_video_utils/native_video_utils_platform_interface.dart';
import 'package:native_video_utils/native_video_utils_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativeVideoUtilsPlatform
    with MockPlatformInterfaceMixin
    implements NativeVideoUtilsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NativeVideoUtilsPlatform initialPlatform = NativeVideoUtilsPlatform.instance;

  test('$MethodChannelNativeVideoUtils is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativeVideoUtils>());
  });

  test('getPlatformVersion', () async {
    NativeVideoUtils nativeVideoUtilsPlugin = NativeVideoUtils();
    MockNativeVideoUtilsPlatform fakePlatform = MockNativeVideoUtilsPlatform();
    NativeVideoUtilsPlatform.instance = fakePlatform;

    expect(await nativeVideoUtilsPlugin.getPlatformVersion(), '42');
  });
}
