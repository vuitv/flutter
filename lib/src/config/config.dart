library config;

import 'package:vuitv/vuitv.dart';

export 'model/app_config.dart';
export 'model/server_config.dart';
export 'model/theme_config.dart';

part 'configurations/config_key.dart';

part 'configurations/configurations.dart';

part 'configurations/default_env.dart';

///
class Config {
  static String get environments => Configurations._environment;

  static ServerConfig get serverConfig => ServerConfig.fromJson(Configurations._serverConfig);

  static Uri get baseUrl => Uri.parse(Configurations._baseUrl);

  static Uri get socketUrl => Uri.parse(Configurations._socketUrl);

  static Uri get mediaUrl => Uri.parse(Configurations._mediaUrl);

  static String get appName => Configurations._appName;

  static String get defaultLanguage => Configurations._defaultLanguage;

  static AppConfig get appConfig => AppConfig.fromJson(Configurations._appConfig);

  static bool get defaultDarkTheme => Configurations._defaultDarkTheme;

  static ThemeConfig get darkTheme => ThemeConfig.fromJson(Configurations._darkConfig);

  static ThemeConfig get lightTheme => ThemeConfig.fromJson(Configurations._lightConfig);
}
