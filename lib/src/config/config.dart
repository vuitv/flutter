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

  static String get version => Configurations._version;

  static Uri get baseUrl => Uri.parse(Configurations._baseUrl);

  static String get appName => Configurations._appName;

  static String get defaultLanguage => Configurations._defaultLanguage;

  static ServerConfig get serverConfig => ServerConfig.fromJson(Configurations._serverConfig);

  static AppConfig get appConfig => AppConfig.fromJson(Configurations._appConfig);

  static bool get defaultDarkTheme => Configurations._defaultDarkTheme;

  static ThemeConfig get darkTheme => ThemeConfig.fromJson(Configurations._darkConfig);

  static ThemeConfig get lightTheme => ThemeConfig.fromJson(Configurations._lightConfig);
}
