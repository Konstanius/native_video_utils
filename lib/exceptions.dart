/// Exception thrown when the source file does not exist.
class NVUSourceFileNotFoundException implements Exception {
  String message = "The source file does not exist.";

  @override
  String toString() {
    return "NVUSourceFileNotFoundException: $message";
  }
}

/// Exception thrown when the target file already exists.
class NVUTargetFileExistsException implements Exception {
  String message = "The target file already exists.";

  @override
  String toString() {
    return "NVUTargetFileExistsException: $message";
  }
}

/// Exception thrown when an exception occurs in creating or writing the target file.
class NVUTargetFileAccessException implements Exception {
  String message = "The target file could not be created or written to.";

  @override
  String toString() {
    return "NVUTargetFileAccessException: $message";
  }
}

/// Exception thrown when the trim start time is after the trim end time.
class NVUTrimStartAfterEndException implements Exception {
  String message = "The specified trim start time is after the trim end time.";

  @override
  String toString() {
    return "NVUTrimStartAfterEndException: $message";
  }
}

/// Exception thrown when the trim start time is later than the video duration.
class NVUTrimStartTooLateException implements Exception {
  String message = "The specified trim start time is later than the video duration.";

  @override
  String toString() {
    return "NVUTrimStartTooLateException: $message";
  }
}

/// Exception thrown when the source file is corrupted, possibly because it is not a video.
class NVUSourceCorruptException implements Exception {
  String message = "The source file is unreadable, possibly corrupted or not a video file.";

  @override
  String toString() {
    return "NVUSourceCorruptException: $message";
  }
}

/// Exception thrown when the trimming process fails
class NVUProcessException implements Exception {
  String message = "An error occurred during the native_video_utils process: ";

  NVUProcessException(String message) {
    this.message = this.message + message;
  }

  @override
  String toString() {
    return "NVUProcessException: $message";
  }
}
