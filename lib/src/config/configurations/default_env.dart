part of '../config.dart';

/// A class that holds default configuration values for the application.
///
/// This class provides static properties that store default configuration settings
/// for various aspects of the application including environment information,
/// server endpoints, app metadata, and theming preferences.
///
/// These values serve as fallbacks or initial values before loading
/// environment-specific configurations.
class DefaultConfig {
  /// The name of the application.
  static String appName = '';

  /// The current environment the application is running in.
  /// Examples: 'development', 'staging', 'production'.
  static String environment = '';

  /// The base URL for API requests.
  static String baseUrl = '';

  /// The WebSocket server URL for real-time communication.
  static String socketUrl = '';

  /// The base URL for media/asset resources.
  static String mediaUrl = '';

  /// Server-specific configuration settings.
  /// May include authentication settings, rate limits, etc.
  static Map<String, dynamic> serverConfig = <String, dynamic>{};

  /// Application-specific configuration settings.
  /// May include feature flags, timeouts, etc.
  static Map<String, dynamic> appConfig = <String, dynamic>{};

  /// The default language/locale code for the application.
  /// Example: 'en', 'vi', etc.
  static String defaultLanguage = '';

  /// Whether dark theme is enabled by default.
  /// Set to true for dark mode, false for light mode.
  static bool defaultDarkTheme = false;

  /// Configuration settings specific to dark theme.
  /// May include color values, opacity settings, etc.
  static Map<String, dynamic> darkConfig = <String, dynamic>{};

  /// Configuration settings specific to light theme.
  /// May include color values, opacity settings, etc.
  static Map<String, dynamic> lightConfig = <String, dynamic>{};
}
