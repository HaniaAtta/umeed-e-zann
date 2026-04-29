import 'package:flutter/material.dart';

extension SizeExtensions on BuildContext {
  // FULL WIDTH * percent (default = 100%)
  double screenWidth([double percent = 1]) =>
      MediaQuery.of(this).size.width * percent;

  // FULL HEIGHT * percent
  double screenHeight([double percent = 1]) =>
      MediaQuery.of(this).size.height * percent;

  // SAFE HEIGHT without status bar
  double safeHeight([double percent = 1]) =>
      (MediaQuery.of(this).size.height -
          MediaQuery.of(this).padding.top -
          MediaQuery.of(this).padding.bottom) * percent;

  // SAFE WIDTH without side paddings3
  double safeWidth([double percent = 1]) =>
      (MediaQuery.of(this).size.width -
          MediaQuery.of(this).padding.left -
          MediaQuery.of(this).padding.right) * percent;

  // RESPONSIVE SIZE (used for font, icons, spacing)
  // Ensures minimum font size of 12
  double responsive(double size) {
    final width = MediaQuery.of(this).size.width;
    double result;

    if (width < 350) {
      result = size * 0.85;  // Small phones
    } else if (width < 500) {
      result = size * 1.0;   // Regular phones
    } else if (width < 800) {
      result = size * 1.1;   // Tablets small
    } else {
      result = size * 1.25;                   // Large tablets
    }
    
    // Ensure minimum font size is 12 if original size is 12 or more
    if (size >= 12 && result < 12) {
      return 12.0;
    }
    
    return result;
  }

  // DIRECT TEXT SIZE SHORTCUT
  double textSize(double size) => responsive(size);

  // Percent Width Shortcut (ex: context.pw(0.2) = 20% width)
  double pw(double percent) => screenWidth(percent);

  // Percent Height Shortcut (ex: context.ph(0.1) = 10% height)
  double ph(double percent) => screenHeight(percent);
}
