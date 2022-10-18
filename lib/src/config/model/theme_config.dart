import 'package:flutter/painting.dart';
import 'package:vuitv/vuitv.dart';

const _kDefaultPrimaryColor = Color(0xFFe21d55);

///Theme create by config
class ThemeConfig {
  ///Theme create by config
  const ThemeConfig({
    this.primaryColor = _kDefaultPrimaryColor,
    this.secondaryColor,
    this.backgroundColor,
    this.textColor,
    this.fontFamily = '',
    this.fontHeader = '',
  });

  ///Theme fromJson
  ThemeConfig.fromJson(Map<String, dynamic> json)
      : primaryColor = HexColor.fromJson(json.getString('primaryColor')) ?? _kDefaultPrimaryColor,
        secondaryColor = HexColor.fromJson(json.getString('secondaryColor')),
        backgroundColor = HexColor.fromJson(json.getString('backgroundColor')),
        textColor = HexColor.fromJson(json.getString('textColor')),
        fontFamily = json.getString('fontFamily') ?? '',
        fontHeader = json.getString('fontHeader') ?? '';

  ///
  final Color primaryColor;

  ///
  final Color? secondaryColor;

  ///
  final Color? backgroundColor;

  ///
  final Color? textColor;

  ///
  final String fontFamily;

  ///
  final String fontHeader;

  ///
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['primaryColor'] = primaryColor.toJson();
    map['secondaryColor'] = secondaryColor?.toJson();
    map['backgroundColor'] = backgroundColor?.toJson();
    map['textColor'] = textColor?.toJson();
    map.removeWhere((key, dynamic value) => value == null);
    return map;
  }
}
