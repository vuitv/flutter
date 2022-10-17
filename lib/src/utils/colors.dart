import 'dart:ui';

///Parse Hex color
class HexColor extends Color {
  ///
  HexColor(String hexColor) : super(_getColorFromHex(hexColor));

  ///
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
    } catch (e) {
      return null;
    }
    return null;
  }

  static int _getColorFromHex(String? hexColor) {
    return fromJson(hexColor)?.value ?? 0xFFFFFFFF;
  }

  ///
  String toJson() => super.value.toRadixString(16);
}
