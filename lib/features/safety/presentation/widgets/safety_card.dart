import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';

class SafetyCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;
  final Color? cardColor;
  final VoidCallback onTap;

  const SafetyCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor,
    this.cardColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
      child: Container(
        padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
        decoration: BoxDecoration(
          color: cardColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
          boxShadow: ThemeHelper.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.mediumPurple).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
              ),
              child: Icon(
                icon,
                size: context.responsive(32),
                color: iconColor ?? AppColors.mediumPurple,
              ),
            ),
            SizedBox(width: ThemeHelper.spacingM(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading4(context),
                  ),
                  SizedBox(height: ThemeHelper.spacingXS(context)),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall1(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: context.responsive(16),
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

