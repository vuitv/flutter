import 'package:flutter/painting.dart';
import 'package:vuitv/vuitv.dart';

const _kDefaultPrimaryColor = Color(0xFFe21d55);

/// The `ThemeConfig` class is responsible for managing
/// the theme settings of the application.
class ThemeConfig {
  /// Creates a new instance of `ThemeConfig` with default values.
  const ThemeConfig({
    this.primaryColor = _kDefaultPrimaryColor,
    this.secondaryColor,
    this.backgroundColor,
    this.textColor,
    this.fontFamily = '',
    this.fontHeader = '',
  });

  /// Creates a new instance of `ThemeConfig` from a JSON map.
  ThemeConfig.fromJson(Map<String, dynamic> json)
      : primaryColor = HexColor.fromJson(json.getString('primaryColor')) //
            ??
            _kDefaultPrimaryColor,
        secondaryColor = HexColor.fromJson(json.getString('secondaryColor')),
        backgroundColor = HexColor.fromJson(json.getString('backgroundColor')),
        textColor = HexColor.fromJson(json.getString('textColor')),
        fontFamily = json.getString('fontFamily') ?? '',
        fontHeader = json.getString('fontHeader') ?? '';

  /// The primary color of the theme.
  final Color primaryColor;

  /// The secondary color of the theme.
  final Color? secondaryColor;

  /// The background color of the theme.
  final Color? backgroundColor;

  /// The text color of the theme.
  final Color? textColor;

  /// The font family used in the theme.
  final String fontFamily;

  /// The font family used for headers in the theme.
  final String fontHeader;

  /// Converts the `ThemeConfig` instance to a JSON map.
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
