part of '../config.dart';

///
class Configurations {
  static String _environment = DefaultConfig.environment;
  static String _baseUrl = DefaultConfig.baseUrl;
  static String _socketUrl = DefaultConfig.socketUrl;
  static String _mediaUrl = DefaultConfig.mediaUrl;
  static String _appName = DefaultConfig.appName;
  static String _defaultLanguage = DefaultConfig.defaultLanguage;
  static Map<String, dynamic> _serverConfig = DefaultConfig.serverConfig;
  static Map<String, dynamic> _appConfig = DefaultConfig.appConfig;

  static bool _defaultDarkTheme = DefaultConfig.defaultDarkTheme;
  static Map<String, dynamic> _darkConfig = DefaultConfig.darkConfig;
  static Map<String, dynamic> _lightConfig = DefaultConfig.lightConfig;

  static void setConfig(Map<String, dynamic> json) {
    _environment = json.getString(ConfigKey.environment) ?? DefaultConfig.environment;
    _appConfig = json.getMap(ConfigKey.appConfig) ?? DefaultConfig.appConfig;
    _serverConfig = json.getMap(ConfigKey.serverConfig) ?? DefaultConfig.serverConfig;

    /// Server Config
    _baseUrl = _serverConfig.getString(ConfigKey.baseUrl) ?? DefaultConfig.baseUrl;
    _socketUrl = _serverConfig.getString(ConfigKey.socketUrl) ?? DefaultConfig.socketUrl;
    _mediaUrl = _serverConfig.getString(ConfigKey.mediaUrl) ?? DefaultConfig.mediaUrl;

    /// App Config
    _appName = json.getString(ConfigKey.appName) ?? DefaultConfig.appName;
    _defaultLanguage = json.getString(ConfigKey.defaultLanguage) ?? DefaultConfig.defaultLanguage;
    _defaultDarkTheme = json.getBool(ConfigKey.defaultDarkTheme) ?? DefaultConfig.defaultDarkTheme;
    _darkConfig = json.getMap(ConfigKey.darkConfig) ?? DefaultConfig.darkConfig;
    _lightConfig = json.getMap(ConfigKey.lightConfig) ?? DefaultConfig.lightConfig;
  }
}
