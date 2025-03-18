import 'package:flutter/material.dart';

/// A responsive widget that displays different layouts based on screen width.
///
/// This widget helps to create responsive UIs by providing different layouts
/// for mobile, tablet and desktop screens. The layouts are chosen based on the
/// following breakpoints:
/// - Mobile: < 600px
/// - Tablet: 600px - 991px
/// - Desktop: >= 992px
/// If the [tablet] layout is not provided, the mobile layout will be used for
/// tablet screens.
/// ```dart
/// Responsive(
///  mobile: MobileLayout(),
///  tablet: TabletLayout(),
///  desktop: DesktopLayout(),
/// )
/// ```
/// You can also use the [ContextExt] extension methods to check the current
/// screen size and apply different styles based on the screen size.
/// ```dart
/// if (context.isMobile) {
///  return MobileLayout();
/// } else if (context.isTablet) {
///  return TabletLayout();
/// } else {
///  return DesktopLayout();
/// }
/// ```
/// See also:
/// - [ContextExt], an extension on [BuildContext] to help with
/// responsive layouts
class Responsive extends StatelessWidget {
  /// Creates a responsive widget with required mobile and desktop layouts.
  ///
  /// The [tablet] layout is optional. If not provided, the mobile layout will
  /// be used for tablet screens.
  const Responsive({
    required this.mobile,
    required this.desktop,
    this.tablet,
    super.key,
  });

  /// The widget to display on mobile screens (width < 600px)
  final Widget mobile;

  /// The widget to display on tablet screens (600px <= width < 992px)
  /// If null, [mobile] widget will be used
  final Widget? tablet;

  /// The widget to display on desktop screens (width >= 992px)
  final Widget desktop;

  /// Returns true if the screen width is less than 600px
  static bool isMobile(BuildContext context) => context.screen.width < 600;

  /// Returns true if the screen width is between 600px and 991px inclusive
  static bool isTablet(BuildContext context) {
    return 600 <= context.screen.width && context.screen.width < 992;
  }

  /// Returns true if => context.screen.width >= 992;
  static bool isDesktop(BuildContext context) => context.screen.width >= 992;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return desktop;
    } else if (context.isTablet && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Extension methods for BuildContext to help with responsive layouts
/// ```dart
/// if (context.isMobile) {
///  return MobileLayout();
/// } else if (context.isTablet) {
///  return TabletLayout();
/// } else {
///  return DesktopLayout();
/// }
/// ```
/// You can also use the [responsive] method to return a value based
/// on the current screen size
/// ```dart
/// final value = context.responsive(desktopValue, mobileValue, tabletValue);
/// ```
extension ContextExt on BuildContext {
  /// Returns the current screen size
  Size get screen => MediaQuery.sizeOf(this);

  /// Returns true if the current screen width is less than 600px
  bool get isMobile => Responsive.isMobile(this);

  /// Returns true if the current screen width is between 600px and 991px
  /// inclusive
  bool get isTablet => Responsive.isTablet(this);

  /// Returns true if the current screen width is 992px or greater
  bool get isDesktop => Responsive.isDesktop(this);

  /// Returns the height of the status bar
  double get statusbarHeight => MediaQuery.paddingOf(this).top;

  /// Returns a value based on the current screen size
  ///
  /// [desktop] value is used for desktop screens or tablet screens
  /// when [tablet] is null
  /// [mobile] value is used for mobile screens
  /// [tablet] value is used for tablet screens when provided
  T responsive<T>(T desktop, T mobile, [T? tablet]) {
    if (isDesktop || (isTablet && tablet == null)) {
      return desktop;
    } else if (isTablet && tablet != null) {
      return tablet;
    }
    return mobile;
  }
}
