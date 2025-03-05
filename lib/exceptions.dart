abstract class NVUException {
  late String message;
}

/// Exception thrown when the source file does not exist.
class NVUSourceFileNotFoundException implements NVUException {
  @override
  String message = "The source file does not exist.";
}

/// Exception thrown when the target file already exists.
class NVUTargetFileExistsException implements NVUException {
  @override
  String message = "The target file already exists.";
}

/// Exception thrown when an exception occurs in creating or writing the target file.
class NVUTargetFileAccessException implements NVUException {
  @override
  String message = "The target file could not be created or written to.";
}

/// Exception thrown when the trim start time is after the trim end time.
class NVUTrimStartAfterEndException implements NVUException {
  @override
  String message = "The specified trim start time is after the trim end time.";
}

/// Exception thrown when the trim start time is later than the video duration.
class NVUTrimStartTooLateException implements NVUException {
  @override
  String message = "The specified trim start time is later than the video duration.";
}

/// Exception thrown when the source file is corrupted, possibly because it is not a video.
class NVUSourceCorruptException implements NVUException {
  @override
  String message = "The source file is unreadable, possibly corrupted or not a video file.";
}

/// Exception thrown when the trimming process fails
class NVUProcessException implements NVUException {
  @override
  String message = "An error occurred during the native_video_utils process: ";

  NVUProcessException(String message) {
    this.message = this.message + message;
  }
}
