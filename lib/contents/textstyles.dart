import 'package:flutter/material.dart';
import 'colors.dart';
import '../core/extensions/extensions.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTextStyles {
  // Headings
  static TextStyle heading1(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(32),
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    letterSpacing: -0.5,
  );

  static TextStyle heading2(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(24),
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    letterSpacing: -0.3,
  );

  static TextStyle heading3(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(20),
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    letterSpacing: -0.2,
  );

  static TextStyle heading4(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(18),
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  // Body Text
  static TextStyle bodyLarge1(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(16),
    fontWeight: FontWeight.normal,
    color: AppColors.primaryText,
    height: 1.5,
  );

  static TextStyle bodyMedium1(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(14),
    fontWeight: FontWeight.normal,
    color: AppColors.primaryText,
    height: 1.5,
  );

  static TextStyle bodySmall1(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(12),
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
    height: 1.4,
  );

  // Button Text
  static TextStyle buttonLarge(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(16),
    fontWeight: FontWeight.w600,
    color: AppColors.lightText,
    letterSpacing: 0.5,
  );

  static TextStyle buttonMedium(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(14),
    fontWeight: FontWeight.w600,
    color: AppColors.lightText,
    letterSpacing: 0.3,
  );

  // Special Text Styles
  static TextStyle caption1(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(12),
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
    height: 1.3,
  );

  static TextStyle label(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(14),
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static TextStyle errorText(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.responsive(12),
    fontWeight: FontWeight.normal,
    color: AppColors.dangerColor,
    height: 1.3,
  );
  static TextStyle headingSmall({
    Color? color,
    FontWeight? weight,
    double? fontSize,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 20,
      fontWeight: weight ?? FontWeight.w600,
      color: color ?? AppColors.primaryDark,
      letterSpacing: -0.2,
      height: 1.4,
    );
  }

  static TextStyle headingLarge({
    Color? color,
    FontWeight? weight,
    double? fontSize,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 32,
      fontWeight: weight ?? FontWeight.bold,
      color: color ?? AppColors.primaryDark,
      letterSpacing: -0.5,
      height: 1.2,
    );
  }

  static TextStyle headingMedium({
    Color? color,
    FontWeight? weight,
    double? fontSize,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 24,
      fontWeight: weight ?? FontWeight.w600,
      color: color ?? AppColors.primaryDark,
      letterSpacing: -0.3,
      height: 1.3,
    );
  }


  static TextStyle bodyLarge({
    Color? color,
    FontWeight? weight,
    double? fontSize,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 16,
      fontWeight: weight ?? FontWeight.normal,
      color: color ?? AppColors.primaryDark,
      letterSpacing: 0.1,
      height: 1.5,
    );
  }

  static TextStyle bodyMedium({
    Color? color,
    FontWeight? weight,
    double? fontSize,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 14,
      fontWeight: weight ?? FontWeight.normal,
      color: color ?? AppColors.primaryDark,
      letterSpacing: 0.1,
      height: 1.5,
    );
  }

  static TextStyle bodySmall({
    Color? color,
    FontWeight? weight,
    double? fontSize,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 12,
      fontWeight: weight ?? FontWeight.normal,
      color: color ?? AppColors.grey,
      letterSpacing: 0.2,
      height: 1.5,
    );
  }

  // Special Styles
  static TextStyle buttonText({
    Color? color,
    double? fontSize,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.white,
      letterSpacing: 0.5,
      height: 1.2,
    );
  }

  static TextStyle caption({
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.grey,
      letterSpacing: 0.2,
      height: 1.4,
    );
  }

  // Premium Display Styles
  static TextStyle displayLarge({
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.primaryDark,
      letterSpacing: -1.0,
      height: 1.1,
    );
  }

  static TextStyle displayMedium({
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.primaryDark,
      letterSpacing: -0.5,
      height: 1.2,
    );
  }

  // Label Styles
  static TextStyle labelLarge({
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.primaryDark,
      letterSpacing: 0.1,
      height: 1.4,
    );
  }

  static TextStyle labelMedium({
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.primaryDark,
      letterSpacing: 0.2,
      height: 1.4,
    );
  }
  // Premium Font Family
  static String get fontFamily => 'Poppins';

  // Urdu/Punjabi Text Styles - Using Noto Nastaliq Urdu
  static TextStyle urduHeading1(BuildContext context) => GoogleFonts.notoNastaliqUrdu(
    fontSize: context.responsive(32),
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    height: 1.5,
  );

  static TextStyle urduHeading2(BuildContext context) => GoogleFonts.notoNastaliqUrdu(
    fontSize: context.responsive(24),
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    height: 1.5,
  );

  static TextStyle urduHeading3(BuildContext context) => GoogleFonts.notoNastaliqUrdu(
    fontSize: context.responsive(20),
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.5,
  );

  static TextStyle urduHeading4(BuildContext context) => GoogleFonts.notoNastaliqUrdu(
    fontSize: context.responsive(18),
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.5,
  );

  static TextStyle urduBodyLarge1(BuildContext context) => GoogleFonts.notoNastaliqUrdu(
    fontSize: context.responsive(16),
    fontWeight: FontWeight.normal,
    color: AppColors.primaryText,
    height: 1.8,
  );

  static TextStyle urduBodyMedium1(BuildContext context) => GoogleFonts.notoNastaliqUrdu(
    fontSize: context.responsive(14),
    fontWeight: FontWeight.normal,
    color: AppColors.primaryText,
    height: 1.8,
  );

  static TextStyle urduBodySmall1(BuildContext context) => GoogleFonts.notoNastaliqUrdu(
    fontSize: context.responsive(12),
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
    height: 1.7,
  );

  static TextStyle urduCaption1(BuildContext context) => GoogleFonts.notoNastaliqUrdu(
    fontSize: context.responsive(12),
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
    height: 1.6,
  );

  // Helper method to get appropriate style based on language
  static TextStyle getUrduStyle(BuildContext context, TextStyle baseStyle) {
    return GoogleFonts.notoNastaliqUrdu(
      fontSize: baseStyle.fontSize,
      fontWeight: baseStyle.fontWeight,
      color: baseStyle.color,
      height: (baseStyle.height ?? 1.0) * 1.1, // Slightly more line height for Urdu
    );
  }
}

