import 'dart:ui';

import 'package:vuitv/src/utils/logs.dart';

///Parse Hex color
class HexColor extends Color {
  ///
  HexColor(String hexColor) : super(_getColorFromHex(hexColor));

  ///
  factory HexColor.fromJson(String? json) => HexColor(json ?? '');

  ///
  static List<HexColor>? fromListJson(List listJson) {
    try {
      final listColor = listJson.map((dynamic e) {
        return HexColor.fromJson(e is String ? e : '');
      }).toList();

      return listColor;
    } catch (e, trace) {
      printLog(e);
      printLog(trace);
      return [];
    }
  }

  static int _getColorFromHex(String hexColor) {
    try {
      var sColor = hexColor;
      sColor = hexColor.toUpperCase().replaceAll('#', '');
      if (sColor.length == 6) {
        sColor = 'FF$hexColor';
      }

      if (sColor.isNotEmpty) {
        return int.parse(sColor, radix: 16);
      }
      return int.parse('FFFFFFFF', radix: 16);
    } catch (e, trace) {
      printLog(e);
      printLog(trace);
      return int.parse('FFFFFFFF', radix: 16);
    }
  }

  ///
  String toJson() => super.value.toRadixString(16);
}
