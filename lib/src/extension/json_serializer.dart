// ignore_for_file: unnecessary_null_comparison

import 'package:vuitv/src/utils/logs.dart';

///Map Factory function
typedef MapFactoryFunction<T> = T Function(Map<String, dynamic>);

///Parse json serializer
extension MapExt on Map<String, dynamic> {
  ///Try get value
  T? getValue<T>(String key) {
    try {
      if (this == null) return null;
      return containsKey(key) && this[key] is T ? this[key] as T : null;
    } catch (e) {
      printLog(e);
    }
    return null;
  }

  ///Try get value int
  int? getInt(String key) {
    if (this == null) return null;
    final dynamic value = getValue<dynamic>(key);
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  ///Try get value double
  double? getDouble(String key) {
    if (this == null) return null;
    final dynamic value = getValue<dynamic>(key);
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  ///Try get value string
  String? getString(String key) => getValue<String>(key);

  ///Try get value bool
  bool? getBool(String key) => getValue<bool>(key);

  ///Try get value date time
  DateTime? getDateTime(String key) {
    if (this == null) return null;
    final dynamic value = getValue<dynamic>(key);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  ///Try get value map
  Map<String, dynamic>? getMap(String key) {
    return getValue<Map<String, dynamic>>(key);
  }

  ///Try builder value object
  T? tryGetObject<T>(
    String key,
    MapFactoryFunction<T> builder,
  ) {
    if (this == null) return null;
    final object = getValue<Map<String, dynamic>>(key);
    if (object is Map<String, dynamic>) return builder(object);
    return null;
  }

  ///Try builder value list
  List<T> tryGetList<T>(
    String key,
    MapFactoryFunction<T> builder,
  ) {
    if (this == null) return <T>[];
    final list = getValue<List<dynamic>>(key) ?? <T>[];
    return tryGetListObject(list, builder);
  }

  ///Try builder value list object
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
