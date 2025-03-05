# native_video_utils

A Flutter plugin designed to combat the issue of FFmpeg-Kit being abandoned and instead use native
platform interfaces to edit videos.

## Why is this necessary

For basically as long as video manipulation functionality was needed in mobile Apps, FFmpeg was the
go-to approach.

However, with the recent (as of today, 05. March 2025) deprecation of FFmpeg-Kit, implementing even
the most basic video editing features in Flutter became difficult, considering most if not all
packages relied on FFmpeg-Kit in some way or another.

Since my own app development and continuous updating to the most recent version of Flutter and my
dependencies also required me to find an alternative to FFmpeg-Kit which I was unsuccessful in, this
project was launched to provide an alternative for some FFmpeg-Kit functionality.

## What makes this different

This plugin relies on 0 additional dependencies. That means, no FFmpeg-Kit or other fancy embedded
libraries are required.

All of the functionality this plugin provides is implemented in native, existing APIs, like
Androids MediaMuxer and iOS's AVFoundation.

For this reason, this package will cause significantly lower app installation sizes than FFmpeg-Kit,
have better OS compatibility and probably achieve better performance than running FFmpeg.

## Features implemented so far

- Trimming videos between a start and end time
- Rotating videos in fixed 90° steps

## Planned features

- Progress reporting via available singleton listener
- Mirroring videos horizontally and vertically
- Cropping videos to a specific area
- Removing audio from a video

## Usage

Trim a video from 5 seconds to 10.6 seconds:

```dart
Future<void> trimExample() async {
  String inputPath = "/path/to/input/video.mp4";
  String outputPath = "/path/to/output/video.mp4";

  await NativeVideoUtils.trimVideo(inputPath, outputPath, 5000, 10600);

  File trimmedFile = File(outputPath);
}
```

Rotate a video by 180 degrees:

```dart
Future<void> rotateExample() async {
  String inputPath = "/path/to/input/video.mp4";
  String outputPath = "/path/to/output/video.mp4";

  await NativeVideoUtils.rotateVideo(inputPath, outputPath, NVURotation.right180);

  File rotatedFile = File(outputPath);
}
```

## Error handling

Every common exception that can occur when performing native_video_utils operations has its own
Exception implemented with a human readable message alongside it.

The following exceptions are implemented:

- NVUSourceFileNotFoundException
- NVUTargetFileExistsException
- NVUTargetFileAccessException
- NVUTrimStartAfterEndException
- NVUTrimStartTooLateException
- NVUSourceCorruptException
- NVUProcessException (generic exception thrown on unknown causes, with more information in its
  message)
