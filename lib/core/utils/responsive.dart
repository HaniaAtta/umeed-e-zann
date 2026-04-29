import 'package:flutter/material.dart';

/// Responsive Design Utilities
/// Provides responsive spacing, sizing, and layout helpers
/// No hard-coded values - everything scales based on screen size
class Responsive {
  final BuildContext context;
  
  Responsive(this.context);
  
  // Screen dimensions
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  
  // Safe area dimensions
  double get safeWidth => width - MediaQuery.of(context).padding.horizontal;
  double get safeHeight => height - MediaQuery.of(context).padding.vertical;
  
  // Breakpoints
  bool get isSmallPhone => width < 360;
  bool get isMediumPhone => width >= 360 && width < 480;
  bool get isLargePhone => width >= 480 && width < 720;
  bool get isTablet => width >= 720;
  
  // Responsive scaling factor
  double get scaleFactor {
    if (isSmallPhone) return 0.85;
    if (isMediumPhone) return 1.0;
    if (isLargePhone) return 1.1;
    return 1.25; // Tablet
  }
  
  // Responsive spacing (padding, margins)
  double spacing(double baseSpacing) => baseSpacing * scaleFactor;
  
  // Responsive font size
  double fontSize(double baseSize) => baseSize * scaleFactor;
  
  // Responsive icon size
  double iconSize(double baseSize) => baseSize * scaleFactor;
  
  // Responsive width/height
  double size(double baseSize) => baseSize * scaleFactor;
  
  // Percentage-based dimensions
  double widthPercent(double percent) => width * percent;
  double heightPercent(double percent) => height * percent;
  
  // Standard spacing values (responsive)
  double get spacingXS => spacing(4);
  double get spacingS => spacing(8);
  double get spacingM => spacing(12);
  double get spacingL => spacing(16);
  double get spacingXL => spacing(24);
  double get spacingXXL => spacing(32);
  double get spacingXXXL => spacing(40);
  
  // Standard padding
  EdgeInsets get paddingXS => EdgeInsets.all(spacingXS);
  EdgeInsets get paddingS => EdgeInsets.all(spacingS);
  EdgeInsets get paddingM => EdgeInsets.all(spacingM);
  EdgeInsets get paddingL => EdgeInsets.all(spacingL);
  EdgeInsets get paddingXL => EdgeInsets.all(spacingXL);
  EdgeInsets get paddingXXL => EdgeInsets.all(spacingXXL);
  
  // Horizontal padding
  EdgeInsets get paddingHorizontalXS => EdgeInsets.symmetric(horizontal: spacingXS);
  EdgeInsets get paddingHorizontalS => EdgeInsets.symmetric(horizontal: spacingS);
  EdgeInsets get paddingHorizontalM => EdgeInsets.symmetric(horizontal: spacingM);
  EdgeInsets get paddingHorizontalL => EdgeInsets.symmetric(horizontal: spacingL);
  EdgeInsets get paddingHorizontalXL => EdgeInsets.symmetric(horizontal: spacingXL);
  EdgeInsets get paddingHorizontalXXL => EdgeInsets.symmetric(horizontal: spacingXXL);
  
  // Vertical padding
  EdgeInsets get paddingVerticalXS => EdgeInsets.symmetric(vertical: spacingXS);
  EdgeInsets get paddingVerticalS => EdgeInsets.symmetric(vertical: spacingS);
  EdgeInsets get paddingVerticalM => EdgeInsets.symmetric(vertical: spacingM);
  EdgeInsets get paddingVerticalL => EdgeInsets.symmetric(vertical: spacingL);
  EdgeInsets get paddingVerticalXL => EdgeInsets.symmetric(vertical: spacingXL);
  EdgeInsets get paddingVerticalXXL => EdgeInsets.symmetric(vertical: spacingXXL);
  
  // Screen padding (standard horizontal padding for screens)
  EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: spacingXL);
  
  // Border radius (responsive)
  double radius(double baseRadius) => baseRadius * scaleFactor;
  
  // Standard border radius
  double get radiusS => radius(8);
  double get radiusM => radius(12);
  double get radiusL => radius(16);
  double get radiusXL => radius(20);
  double get radiusXXL => radius(24);
  double get radiusRound => radius(999); // Fully rounded
}

/// Extension for easy access to Responsive utilities
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
  
  // Quick shortcuts
  double r(double value) => responsive.spacing(value);
  double rf(double value) => responsive.fontSize(value);
  double rs(double value) => responsive.size(value);
}






