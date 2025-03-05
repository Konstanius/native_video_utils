import 'native_video_utils_platform_interface.dart';
import 'exceptions.dart';

class NativeVideoUtils {
  /// Edit a video and trim it's content to the specified time range.
  ///
  /// [inputPath] - the absolute path of the source video file. <br>
  /// [outputPath] - the absolute path of the destination video file. <br>
  /// [startMs] - starting time in milliseconds for trimming. Set to negative or 0 if starting from beginning. <br>
  /// [endMs] - end time for trimming in milliseconds. Set to negative or 0 if no trimming at the end. <br>
  /// <br>
  /// Might throw the following exceptions:
  /// [NVUSourceFileNotFoundException], [NVUTargetFileExistsException], [NVUTargetFileAccessException],
  /// [NVUTrimStartAfterEndException], [NVUTrimStartTooLateException], [NVUProcessException],
  /// [NVUSourceCorruptException]
  Future<void> trimVideo(String inputPath, String outputPath, int startMs, int endMs) async {
    String? result;
    try {
      result = await NativeVideoUtilsPlatform.instance.trimVideo(inputPath, outputPath, startMs, endMs);
    } catch (e, s) {
      throw NVUProcessException("$e\n$s");
    }
    if (result != null && result.isNotEmpty) {
      switch (result) {
        case "source_file_not_found":
          throw NVUSourceFileNotFoundException();
        case "source_corrupt":
          throw NVUSourceCorruptException();
        case "target_file_exists":
          throw NVUTargetFileExistsException();
        case "target_file_access":
          throw NVUTargetFileAccessException();
        case "trim_start_after_end":
          throw NVUTrimStartAfterEndException();
        case "trim_start_too_late":
          throw NVUTrimStartTooLateException();
        default:
          throw NVUProcessException(result);
      }
    }
  }
}
