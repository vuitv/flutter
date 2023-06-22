import 'package:flutter/material.dart';

///
extension BuildContextExtensions on BuildContext {
  ///
  ThemeData get theme => Theme.of(this);

  ///
  TextTheme get textTheme => theme.textTheme;

  ///
  ColorScheme get colorScheme => theme.colorScheme;

  ///
  Color get primaryColor => theme.primaryColor;

  ///
  Color get backgroundColor => colorScheme.background;

  ///
  Color get disabledColor => theme.disabledColor;

  ///
  TextStyle? get textStyle => Theme.of(this).textTheme.bodyMedium;

  ///
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  ///
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ///
  NavigatorState get navigator => Navigator.of(this);

  ///
  FocusScopeNode get focusScope => FocusScope.of(this);

  ///
  ScaffoldState get scaffold => Scaffold.of(this);

  ///
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
}

///
extension MaterialStateHelpers on Iterable<MaterialState> {
  ///
  bool get isHovered => contains(MaterialState.hovered);

  ///
  bool get isFocused => contains(MaterialState.focused);

  ///
  bool get isPressed => contains(MaterialState.pressed);

  ///
  bool get isDragged => contains(MaterialState.dragged);

  ///
  bool get isSelected => contains(MaterialState.selected);

  ///
  bool get isScrolledUnder => contains(MaterialState.scrolledUnder);

  ///
  bool get isDisabled => contains(MaterialState.disabled);

  ///
  bool get isError => contains(MaterialState.error);
}
