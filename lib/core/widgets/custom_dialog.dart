import 'package:flutter/material.dart';
import '../../contents/colors.dart';
import '../../contents/textstyles.dart';
import '../../core/extensions/extensions.dart';
import '../theme/theme_helper.dart';
import 'custom_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
      ),
      child: Padding(
        padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: context.responsive(48),
                color: iconColor ?? AppColors.mediumPurple,
              ),
              SizedBox(height: ThemeHelper.spacingM(context)),
            ],
            Text(
              title,
              style: AppTextStyles.heading3(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ThemeHelper.spacingS(context)),
            Text(
              message,
              style: AppTextStyles.bodyMedium1(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ThemeHelper.spacingL(context)),
            Row(
              children: [
                if (cancelText != null) ...[
                  Expanded(
                    child: CustomButton(
                      text: cancelText!,
                      onPressed: onCancel ?? () => Navigator.of(context).pop(),
                      backgroundColor: AppColors.lightGrey,
                      textColor: AppColors.primaryText,
                    ),
                  ),
                  SizedBox(width: ThemeHelper.spacingM(context)),
                ],
                Expanded(
                  child: CustomButton(
                    text: confirmText ?? 'OK',
                    onPressed: onConfirm ?? () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

