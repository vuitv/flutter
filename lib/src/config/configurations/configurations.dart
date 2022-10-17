part of '../config.dart';

class Configurations {
  static String _environment = DefaultConfig.environment;
  static String _baseUrl = DefaultConfig.baseUrl;
  static String _appName = DefaultConfig.appName;
  static String _defaultLanguage = DefaultConfig.defaultLanguage;
  static Map<String, dynamic> _serverConfig = DefaultConfig.serverConfig;
  static Map<String, dynamic> _appConfig = DefaultConfig.appConfig;
  static String _version = DefaultConfig.version;

  static bool _defaultDarkTheme = DefaultConfig.defaultDarkTheme;
  static Map<String, dynamic> _darkConfig = DefaultConfig.darkConfig;
  static Map<String, dynamic> _lightConfig = DefaultConfig.lightConfig;

  static void setConfig(Map<String, dynamic> json) {
    _environment = json.getString(ConfigKey.environment) ?? DefaultConfig.environment;
    _appConfig = json.getMap(ConfigKey.appConfig) ?? DefaultConfig.appConfig;
    _serverConfig = json.getMap(ConfigKey.serverConfig) ?? DefaultConfig.serverConfig;

    /// Server Config
    _baseUrl = _serverConfig.getString(ConfigKey.baseUrl) ?? DefaultConfig.baseUrl;

    /// App Config
    _appName = json.getString(ConfigKey.appName) ?? DefaultConfig.appName;
    _defaultLanguage = json.getString(ConfigKey.defaultLanguage) ?? DefaultConfig.defaultLanguage;
    _version = json.getString(ConfigKey.version) ?? DefaultConfig.version;

    _defaultDarkTheme = json.getBool(ConfigKey.defaultDarkTheme) ?? DefaultConfig.defaultDarkTheme;
    _darkConfig = json.getMap(ConfigKey.darkConfig) ?? DefaultConfig.darkConfig;
    _lightConfig = json.getMap(ConfigKey.lightConfig) ?? DefaultConfig.lightConfig;
  }
}
