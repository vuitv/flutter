import 'package:vuitv/src/extension/json_serializer.dart';

/// A model class representing server configuration settings.
///
/// [ServerConfig] encapsulates server-related configuration data, primarily
/// the server URL. This class is used to provide typed access to server
/// configuration values throughout the application.
///
/// Example:
/// ```dart
/// final serverConfig = ServerConfig(url: 'https://api.example.com');
/// ```
class ServerConfig {
  /// Creates a new immutable [ServerConfig] instance.
  ///
  /// [url] The server URL. Defaults to an empty string if not specified.
  const ServerConfig({
    this.url = '',
  });

  /// Creates a [ServerConfig] instance from a JSON map.
  ///
  /// This constructor deserializes server configuration data from a JSON
  /// source, extracting the 'url' property using extension methods from json.
  ///
  /// [json] The map containing server configuration key-value pairs.
  /// If the 'url' key is missing or null, an empty string will be used.
  ServerConfig.fromJson(Map<String, dynamic> json) //
      : url = json.getString('url') ?? '';

  /// The server URL endpoint.
  ///
  /// This URL is typically used as the base endpoint for server communication.
  final String url;
}
