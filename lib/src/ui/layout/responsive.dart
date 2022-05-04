import 'package:flutter/material.dart';

///Base reponsive layout
class Responsive extends StatelessWidget {
  ///
  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  ///Layout for mobile
  final Widget mobile;

  ///Layout for tablet
  final Widget? tablet;

  ///Layout for desktop
  final Widget desktop;

  ///
  static bool isMobile(BuildContext context) => context.screen.width < 600;

  ///
  static bool isTablet(BuildContext context) {
    return 600 <= context.screen.width && context.screen.width < 992;
  }

  ///
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

///Context layout extension
extension ContextExt on BuildContext {
  ///Get screen size
  Size get screen => MediaQuery.of(this).size;

  ///
  bool get isMobile => Responsive.isMobile(this);

  ///
  bool get isTablet => Responsive.isTablet(this);

  ///
  bool get isDesktop => Responsive.isDesktop(this);

  ///Get screen size
  double get statusbarHeight => MediaQuery.of(this).padding.top;

  ///build reponse object
  T responsive<T>(T desktop, T mobile, [T? tablet]) {
    if (isDesktop || (isTablet && tablet == null)) {
      return desktop;
    } else if (isTablet && tablet != null) {
      return tablet;
    }
    return mobile;
  }
}
