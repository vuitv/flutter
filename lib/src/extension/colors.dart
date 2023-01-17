import 'dart:ui';

/// Color extension
extension ColorExt on Color {
  /// Color to Hex
  String toJson() => value.toRadixString(16).padLeft(8, '0');
}
