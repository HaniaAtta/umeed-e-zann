import 'package:flutter/material.dart';
import '../../contents/colors.dart';
import '../../core/extensions/extensions.dart';

class ThemeHelper {
  // Spacing constants
  static double spacingXS(BuildContext context) => context.responsive(4);
  static double spacingS(BuildContext context) => context.responsive(8);
  static double spacingM(BuildContext context) => context.responsive(16);
  static double spacingL(BuildContext context) => context.responsive(24);
  static double spacingXL(BuildContext context) => context.responsive(32);
  static double spacingXXL(BuildContext context) => context.responsive(48);

  // Border radius
  static double radiusS = 8;
  static double radiusM = 12;
  static double radiusL = 16;
  static double radiusXL = 24;
  static double radiusCircular = 1000;

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: AppColors.black.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: AppColors.black.withValues(alpha: 0.15),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}

