/// A class responsible for managing application configuration settings.
///
/// `AppConfig` serves as a container for application-level configuration data,
/// providing a structured way to access settings throughout the application.
/// This class is typically instantiated once during application startup and
/// may be accessed via dependency injection or a global accessor.
///
/// Configuration data may include:
/// - Environment-specific settings
/// - Feature flags
/// - API endpoints
/// - Theming preferences
/// - Application metadata
class AppConfig {
  /// Creates a new instance of [AppConfig] with default values.
  ///
  /// Use this constructor when you need an empty configuration object
  /// that will be populated programmatically.
  const AppConfig();

  /// Creates a new instance of [AppConfig] from a JSON map.
  ///
  /// This factory constructor deserializes configuration data from a JSON
  /// source, making it easy to load settings from config files, API responses,
  /// or other data sources.
  ///
  /// Example:
  /// ```dart
  /// final config = AppConfig.fromJson({
  ///   'environment': 'production',
  ///   'apiUrl': 'https://api.example.com'
  /// });
  /// ```
  ///
  /// [json] The map containing configuration key-value pairs.
  AppConfig.fromJson(Map<String, dynamic> json);
}
