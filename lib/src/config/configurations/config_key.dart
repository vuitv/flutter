part of '../config.dart';

/// A collection of constant string keys used for accessing configuration values
/// throughout the application.
///
/// These keys are used with configuration providers to retrieve specific settings
/// such as environment variables, URLs, theme configurations, and application metadata.
class ConfigKey {
  /// The key for the application environment (e.g., 'development', 'production').
  static const environment = 'environment';

  /// The key for the API base URL.
  static const baseUrl = 'baseUrl';

  /// The key for the WebSocket server URL.
  static const socketUrl = 'socketUrl';

  /// The key for the media/assets URL.
  static const mediaUrl = 'mediaUrl';

  /// The key for the application name.
  static const appName = 'appName';

  /// The key for the default language/locale setting.
  static const defaultLanguage = 'defaultLanguage';

  /// The key for the general application configuration.
  static const appConfig = 'appConfig';

  /// The key for server-specific configuration.
  static const serverConfig = 'serverConfig';

  /// The key for the application version.
  static const version = 'version';

  /// The key for the default dark theme identifier.
  static const defaultDarkTheme = 'defaultDarkTheme';

  /// The key for dark theme configuration settings.
  static const darkConfig = 'darkConfig';

  /// The key for light theme configuration settings.
  static const lightConfig = 'lightConfig';
}
