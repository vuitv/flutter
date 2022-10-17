import 'package:flutter/painting.dart';

/// Color extension
extension ColorExt on Color {
  /// Color to Hex
  String toJson() => '#${value.toRadixString(16)}';
}
