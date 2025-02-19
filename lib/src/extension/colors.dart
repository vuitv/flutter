import 'dart:ui';

/// Extension methods for the Color class
extension ColorExt on Color {
  /// Converts a Color to its hexadecimal string representation.
  ///
  /// Returns an 8-character string where:
  /// - First 2 characters represent the alpha channel (opacity)
  /// - Next 2 characters represent the red channel
  /// - Next 2 characters represent the green channel
  /// - Last 2 characters represent the blue channel
  ///
  /// Each channel is represented in hexadecimal format (00-ff).
  ///
  /// Example:
  /// ```dart
  /// Color(0xFF000000).toJson() // Returns 'ff000000'
  /// Color(0x80FF0000).toJson() // Returns '80ff0000'
  /// ```
  String toJson() => value.toRadixString(16).padLeft(8, '0');
}
