import 'package:flutter/material.dart';
import '../../contents/colors.dart';
import '../../contents/textstyles.dart';
import '../../core/extensions/extensions.dart';
import '../theme/theme_helper.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isLoading;
  final IconData? icon;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.isLoading = false,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.mediumPurple;
    final txtColor = textColor ?? AppColors.lightText;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? context.responsive(56),
      child: isOutlined
          ? OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: bgColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ThemeHelper.spacingM(context),
            vertical: ThemeHelper.spacingM(context),
          ),
        ),
        child: _buildButtonContent(context, txtColor),
      )
          : ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: txtColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ThemeHelper.spacingM(context),
            vertical: ThemeHelper.spacingM(context),
          ),
        ),
        child: _buildButtonContent(context, txtColor),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context, Color txtColor) {
    if (isLoading) {
      return SizedBox(
        height: context.responsive(20),
        width: context.responsive(20),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(txtColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: context.responsive(20), color: txtColor),
          SizedBox(width: ThemeHelper.spacingS(context)),
          Text(
            text,
            style: AppTextStyles.buttonLarge(context).copyWith(color: txtColor),
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTextStyles.buttonLarge(context).copyWith(color: txtColor),
    );
  }
}

