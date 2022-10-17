import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_config.freezed.dart';

part 'server_config.g.dart';

@freezed
class ServerConfig with _$ServerConfig {
  const factory ServerConfig({
    @Default('') String url,
  }) = _ServerConfig;

  factory ServerConfig.fromJson(Map<String, dynamic> json) => _$ServerConfigFromJson(json);
}
