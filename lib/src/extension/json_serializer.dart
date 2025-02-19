// ignore_for_file: unnecessary_null_comparison

import 'package:vuitv/src/utils/logs.dart';

/// Type definition for a function that creates an object of type T from a Map
typedef MapFactoryFunction<T> = T Function(Map<String, dynamic>);

/// Extension methods for Map<String, dynamic> to help with
/// JSON parsing and type conversion
extension MapExt on Map<String, dynamic> {
  /// Gets a value of type T from the map for the given key
  ///
  /// Returns null if:
  /// - The map is null
  /// - The key doesn't exist
  /// - The value cannot be cast to type T
  T? getValue<T>(String key) {
    try {
      if (this == null) return null;
      return containsKey(key) && this[key] is T ? this[key] as T : null;
    } catch (e) {
      printLog(e);
    }
    return null;
  }

  /// Gets an integer value from the map for the given key
  ///
  /// Handles both numeric and string values that represent integers
  /// Returns null if the value cannot be converted to an integer
  int? getInt(String key) {
    if (this == null) return null;
    final dynamic value = getValue<dynamic>(key);
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Gets a double value from the map for the given key
  ///
  /// Handles both numeric and string values that represent doubles
  /// Returns null if the value cannot be converted to a double
  double? getDouble(String key) {
    if (this == null) return null;
    final dynamic value = getValue<dynamic>(key);
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Gets a string value from the map for the given key
  String? getString(String key) => getValue<String>(key);

  /// Gets a boolean value from the map for the given key
  bool? getBool(String key) => getValue<bool>(key);

  /// Gets a DateTime value from the map for the given key
  ///
  /// Attempts to parse string values as DateTime
  /// Returns null if the value cannot be parsed to DateTime
  DateTime? getDateTime(String key) {
    if (this == null) return null;
    final dynamic value = getValue<dynamic>(key);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  /// Gets a nested map value from the map for the given key
  Map<String, dynamic>? getMap(String key) {
    return getValue<Map<String, dynamic>>(key);
  }

  /// Attempts to build an object of type T from a nested map at the given key
  ///
  /// Uses the provided builder function to create the object
  /// Returns null if the value is not a valid map
  T? tryGetObject<T>(
    String key,
    MapFactoryFunction<T> builder,
  ) {
    if (this == null) return null;
    final object = getValue<Map<String, dynamic>>(key);
    if (object is Map<String, dynamic>) return builder(object);
    return null;
  }

  /// Attempts to build a list of objects of type T from an array at the
  /// given key
  ///
  /// Uses the provided builder function to create each object
  /// Returns an empty list if the key doesn't exist or value is not a list
  List<T> tryGetList<T>(
    String key,
    MapFactoryFunction<T> builder,
  ) {
    if (this == null) return <T>[];
    final list = getValue<List<dynamic>>(key) ?? <T>[];
    return tryGetListObject(list, builder);
  }

  /// Attempts to build a list of objects of type T from a dynamic list
  ///
  /// Uses the provided builder function to create each object from map elements
  /// Skips any elements that are not valid maps
  List<T> tryGetListObject<T>(
    List<dynamic> json,
    MapFactoryFunction<T> builder,
  ) {
    final list = <T>[];
    for (final element in json) {
      if (element is Map<String, dynamic>) {
        final value = builder(element);
        list.add(value);
      }
    }
    return list;
  }
}
