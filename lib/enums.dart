enum NVURotation {

  /// Rotate 90 degrees clockwise
  right90(1),

  /// Rotate 180 degrees clockwise
  right180(2),

  /// Rotate 270 degrees clockwise
  right270(3);

  final int value;

  const NVURotation(this.value);
}