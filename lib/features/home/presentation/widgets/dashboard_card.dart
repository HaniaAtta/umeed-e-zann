import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Icon(
                    icon,
                    size: context.responsive(40),
                    color: color,
                  ),
                ),
                SizedBox(height: ThemeHelper.spacingS(context)),
                Flexible(
                  child: Text(
                    title,
                    style: AppTextStyles.bodyMedium1(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                      fontSize: context.responsive(14),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

