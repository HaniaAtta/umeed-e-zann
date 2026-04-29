import 'package:flutter/material.dart';

/// Responsive breakpoints
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Responsive utility class
class Responsive {
  final BuildContext context;
  final Size size;

  Responsive(this.context) : size = MediaQuery.of(context).size;

  /// Check if current screen is mobile
  bool get isMobile => size.width < Breakpoints.mobile;

  /// Check if current screen is tablet
  bool get isTablet =>
      size.width >= Breakpoints.mobile && size.width < Breakpoints.desktop;

  /// Check if current screen is desktop
  bool get isDesktop => size.width >= Breakpoints.desktop;

  /// Get responsive width
  double getWidth(double mobile, [double? tablet, double? desktop]) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Get responsive padding
  EdgeInsets getPadding({
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile ?? const EdgeInsets.all(16);
  }

  /// Get responsive font size
  double getFontSize(double mobile, [double? tablet, double? desktop]) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Get responsive columns count
  int getColumns(int mobile, [int? tablet, int? desktop]) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}

/// Extension on BuildContext for easy access
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
}

