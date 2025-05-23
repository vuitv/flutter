import 'package:flutter/material.dart';

/// Extension methods for BuildContext to provide easy access to common Theme
/// and Widget properties.
extension BuildContextExtensions on BuildContext {
  /// Gets the current theme data.
  ThemeData get theme => Theme.of(this);

  /// Gets the current text theme.
  TextTheme get textTheme => theme.textTheme;

  /// Gets the current color scheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Gets the primary color from the current theme.
  Color get primaryColor => theme.primaryColor;

  /// Gets the background color from the current color scheme.
  Color get backgroundColor => colorScheme.surface;

  /// Gets the disabled color from the current theme.
  Color get disabledColor => theme.disabledColor;

  /// Gets the default body medium text style from the current theme.
  TextStyle? get textStyle => Theme.of(this).textTheme.bodyMedium;

  /// Gets the default text style from the closest DefaultTextStyle ancestor.
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  /// Gets the current media query data.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Gets the closest Navigator widget's state.
  NavigatorState get navigator => Navigator.of(this);

  /// Gets the closest FocusScope widget's node.
  FocusScopeNode get focusScope => FocusScope.of(this);

  /// Gets the closest Scaffold widget's state.
  ScaffoldState get scaffold => Scaffold.of(this);

  /// Gets the closest ScaffoldMessenger widget's state.
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
}

/// Extension methods for WidgetState to provide easy access to common state
/// checks.
extension WidgetStateHelpers on Iterable<WidgetState> {
  /// Whether the material widget is being hovered.
  bool get isHovered => contains(WidgetState.hovered);

  /// Whether the material widget has input focus.
  bool get isFocused => contains(WidgetState.focused);

  /// Whether the material widget is being pressed.
  bool get isPressed => contains(WidgetState.pressed);

  /// Whether the material widget is being dragged.
  bool get isDragged => contains(WidgetState.dragged);

  /// Whether the material widget is in a selected state.
  bool get isSelected => contains(WidgetState.selected);

  /// Whether the material widget has content scrolled underneath it.
  bool get isScrolledUnder => contains(WidgetState.scrolledUnder);

  /// Whether the material widget is in a disabled state.
  bool get isDisabled => contains(WidgetState.disabled);

  /// Whether the material widget is in an error state.
  bool get isError => contains(WidgetState.error);
}
