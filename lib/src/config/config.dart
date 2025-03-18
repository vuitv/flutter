library;

import 'package:vuitv/vuitv.dart';

export 'model/app_config.dart';
export 'model/server_config.dart';
export 'model/theme_config.dart';

part 'configurations/config_key.dart';

part 'configurations/configurations.dart';

part 'configurations/default_env.dart';

/// A static utility class providing centralized access
/// to application configuration values.
///
/// The `Config` class serves as a facade for accessing various configuration settings
/// throughout the application. It encapsulates the complexity of configuration management
/// and provides a clean, strongly-typed API for retrieving configuration values.
///
/// This class doesn't need to be instantiated and all properties are accessed statically.
/// The underlying configuration values are managed by the private `Configurations` class.
class Config {
  /// Gets the current application environment
  /// (e.g., 'development', 'staging', 'production').
  static String get environments => Configurations._environment;

  /// Gets the server configuration containing server-specific settings.
  ///
  /// Returns a [ServerConfig] object constructed from
  /// the underlying JSON configuration.
  static ServerConfig get serverConfig => ServerConfig.fromJson(
        Configurations._serverConfig,
      );

  /// Gets the base API URL as a [Uri] object.
  ///
  /// This is the root endpoint for all API requests in the application.
  static Uri get baseUrl => Uri.parse(Configurations._baseUrl);

  /// Gets the WebSocket server URL as a [Uri] object.
  ///
  /// This endpoint is used for real-time communication features.
  static Uri get socketUrl => Uri.parse(Configurations._socketUrl);

  /// Gets the media server URL as a [Uri] object.
  ///
  /// This endpoint is used for accessing images, videos, and other media assets.
  static Uri get mediaUrl => Uri.parse(Configurations._mediaUrl);

  /// Gets the display name of the application.
  static String get appName => Configurations._appName;

  /// Gets the default language/locale code for the application.
  static String get defaultLanguage => Configurations._defaultLanguage;

  /// Gets the application-specific configuration settings.
  ///
  /// Returns an [AppConfig] object constructed from the underlying JSON configuration.
  static AppConfig get appConfig => AppConfig.fromJson(Configurations._appConfig);

  /// Gets whether dark theme is enabled by default.
  ///
  /// Returns `true` if dark theme should be used as the default, `false` otherwise.
  static bool get defaultDarkTheme => Configurations._defaultDarkTheme;

  /// Gets the dark theme configuration settings.
  ///
  /// Returns a [ThemeConfig] object constructed from the underlying JSON configuration.
  static ThemeConfig get darkTheme => ThemeConfig.fromJson(Configurations._darkConfig);

  /// Gets the light theme configuration settings.
  ///
  /// Returns a [ThemeConfig] object constructed from the underlying JSON configuration.
  static ThemeConfig get lightTheme => ThemeConfig.fromJson(Configurations._lightConfig);
}
