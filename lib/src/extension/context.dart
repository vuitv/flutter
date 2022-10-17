import 'package:flutter/material.dart';

/// BuildContextTheme
extension BuildContextThemeExt on BuildContext {
  ///
  Color get primaryColor => Theme.of(this).primaryColor;

  ///
  Color get backgroundColor => Theme.of(this).backgroundColor;

  ///
  Color get disabledColor => Theme.of(this).disabledColor;

  ///
  TextStyle? get textStyle => Theme.of(this).textTheme.bodyText2;
}
