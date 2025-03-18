import 'dart:ui';

/// A color that is created from a hex string.
/// The hex string can be provided with or without the leading '#'.
class HexColor extends Color {
  /// Creates a color from a hex string.
  ///
  /// The [hexColor] string can be in the format:
  /// - '#RRGGBB'
  /// - '#AARRGGBB'
  /// - 'RRGGBB'
  /// - 'AARRGGBB'
  HexColor(String hexColor) : super(_getColorFromHex(hexColor));

  /// Creates a [Color] from a hex string, returning null if the string
  /// is invalid.
  ///
  /// Accepts hex color strings with or without '#' prefix.
  /// Supports both RGB (6 characters) and ARGB (8 characters) formats.
  static Color? fromJson(String? hexColor) {
    if (hexColor == null) return null;
    try {
      var sColor = hexColor;
      sColor = sColor.toUpperCase().replaceAll('#', '');
      if (sColor.length == 6) {
        sColor = 'FF$sColor';
      }

      if (sColor.isNotEmpty) {
        return Color(int.parse(sColor, radix: 16));
      }
    } on Exception {
      return null;
    }
    return null;
  }

  /// Converts a hex color string to a color integer value.
  /// Returns white (0xFFFFFFFF) if the conversion fails.
  static int _getColorFromHex(String? hexColor) {
    return fromJson(hexColor)?.value ?? 0xFFFFFFFF;
  }
}
