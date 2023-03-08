import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:vuitv/src/extension/colors.dart';
import 'package:vuitv/src/utils/colors.dart';

/// ```dart
/// @JsonSerializable()
/// class Example {
///   @BoolConverter()
///   final bool property;
/// }
/// ```
class BoolConverter implements JsonConverter<bool, int> {
  ///   @BoolConverter()
  const BoolConverter();

  @override
  bool fromJson(int json) => json == 1;

  @override
  int toJson(bool value) => value ? 1 : 0;
}

/// ```dart
/// @JsonSerializable()
/// class Example {
///   @ColorConverter()
///   final Color? property;
/// }
/// ```
class ColorConverter implements JsonConverter<Color?, String?> {
  ///   @ColorConverter()
  const ColorConverter();

  @override
  Color? fromJson(String? json) => HexColor.fromJson(json);

  @override
  String? toJson(Color? value) => value?.toJson();
}

/// ```dart
/// @JsonSerializable()
/// class Example {
///   @DateTimeConverter()
///   final Color? property;
/// }
/// ```
class DateTimeConverter implements JsonConverter<DateTime, String> {
  ///   @DateTimeConverter()
  const DateTimeConverter([this._format]);

  final DateFormat? _format;

  @override
  DateTime fromJson(String json) {
    return _format?.parse(json) ?? DateTime.parse(json);
  }

  @override
  String toJson(DateTime dateTime) => _format?.format(dateTime) ?? dateTime.toIso8601String();
}
