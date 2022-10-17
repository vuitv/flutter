import 'package:vuitv/vuitv.dart';

///Theme create by config
class ThemeConfig {
  ///Theme create by config
  const ThemeConfig({
    this.mainColor = 'e21d55',
    this.primaryColor = '',
    this.secondaryColor = '',
    this.backgroundColor = '',
    this.textColor = '',
    this.fontFamily = '',
    this.fontHeader = '',
  });

  ///Theme fromJson
  ThemeConfig.fromJson(Map<String, dynamic> json)
      : mainColor = json.getString('mainColor') ?? '',
        primaryColor = json.getString('primaryColor') ?? '',
        secondaryColor = json.getString('secondaryColor') ?? '',
        backgroundColor = json.getString('backgroundColor') ?? '',
        textColor = json.getString('textColor') ?? '',
        fontFamily = json.getString('fontFamily') ?? '',
        fontHeader = json.getString('fontHeader') ?? '';

  ///
  final String mainColor;

  ///
  final String primaryColor;

  ///
  final String secondaryColor;

  ///
  final String backgroundColor;

  ///
  final String textColor;

  ///
  final String fontFamily;

  ///
  final String fontHeader;

  ///
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mainColor'] = mainColor;
    map['primaryColor'] = primaryColor;
    map['secondaryColor'] = secondaryColor;
    map['backgroundColor'] = backgroundColor;
    map['textColor'] = textColor;
    map.removeWhere((key, dynamic value) => value == null);
    return map;
  }
}
