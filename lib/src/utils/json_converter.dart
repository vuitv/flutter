import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vuitv/src/extension/colors.dart';
import 'package:vuitv/src/utils/colors.dart';

/// A collection of JSON converters for commonly used data types.
///
/// These converters can be used with the `@JsonSerializable()` annotation from
/// the `json_serializable` package to customize how certain types are
/// serialized and deserialized.

/// Converts between `bool` and `int` values.
///
/// Converts `true` to `1` and `false` to `0` during serialization.
/// During deserialization, treats `1` as `true` and anything else as `false`.
///
/// Example:
/// ```dart
/// @JsonSerializable()
/// class Example {
///   @BoolConverter()
///   final bool property;
/// }
/// ```
class BoolConverter implements JsonConverter<bool, int> {
  /// Creates a new [BoolConverter].
  const BoolConverter();

  @override
  bool fromJson(int json) => json == 1;

  @override
  int toJson(bool value) => value ? 1 : 0;
}

/// Converts between [Color] and hex string values.
///
/// During serialization, converts Color objects to hex strings.
/// During deserialization, parses hex strings into Color objects.
///
/// Supports both RGB (6 characters) and ARGB (8 characters) hex formats,
/// with or without the '#' prefix.
///
/// Example:
/// ```dart
/// @JsonSerializable()
/// class Example {
///   @ColorConverter()
///   final Color? property;
/// }
/// ```
class ColorConverter implements JsonConverter<Color?, String?> {
  /// Creates a new [ColorConverter].
  const ColorConverter();

  @override
  Color? fromJson(String? json) => HexColor.fromJson(json);

  @override
  String? toJson(Color? value) => value?.toJson();
}

/// Converts between [DateTime] and string values.
///
/// During serialization, formats DateTime objects as strings.
/// During deserialization, parses strings into DateTime objects.
///
/// Optionally accepts a [DateFormat] to customize the date format.
/// If no format is provided, uses ISO 8601 format.
///
/// Example:
/// ```dart
/// @JsonSerializable()
/// class Example {
///   @DateTimeConverter()
///   final DateTime property;
/// }
/// ```
class DateTimeConverter implements JsonConverter<DateTime, String> {
  /// Creates a new [DateTimeConverter] with an optional [DateFormat].
  const DateTimeConverter([this._format]);

  final DateFormat? _format;

  @override
  DateTime fromJson(String json) {
    return _format?.parse(json) ?? DateTime.parse(json);
  }

  @override
  String toJson(DateTime dateTime) => //
      _format?.format(dateTime) ?? dateTime.toIso8601String();
}
