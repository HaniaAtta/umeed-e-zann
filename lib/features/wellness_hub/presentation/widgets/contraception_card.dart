import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/contraception_method.dart';

/// Contraception Card Widget
/// Tall, portrait card for horizontal carousel
/// Shows icon, name, and efficacy badge
class ContraceptionCard extends StatelessWidget {
  final ContraceptionMethod method;
  final VoidCallback onTap;
  final bool isVertical;

  const ContraceptionCard({
    super.key,
    required this.method,
    required this.onTap,
    this.isVertical = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isVertical ? double.infinity : responsive.size(180),
        margin: EdgeInsets.only(
          right: isVertical ? 0 : responsive.spacingL,
          bottom: isVertical ? responsive.spacingL : 0,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(responsive.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.08),
              blurRadius: responsive.spacingL,
              offset: Offset(0, responsive.spacingS),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.spacingL,
            vertical: responsive.spacingL,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top: Large Icon in circle
              Container(
                width: responsive.size(80),
                height: responsive.size(80),
                decoration: BoxDecoration(
                  color: AppColors.palePink.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  method.icon,
                  color: AppColors.secondaryPurple,
                  size: responsive.iconSize(40),
                ),
              ),
              
              SizedBox(height: responsive.spacingXL),
              
              // Middle: Method Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.spacingM),
                child: Text(
                  method.name,
                  style: AppTextStyles.headingSmall(
                    color: AppColors.primaryDark,
                  ).copyWith(
                    fontSize: responsive.fontSize(18),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              SizedBox(height: responsive.spacingL),
              
              // Bottom: Efficacy Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.spacingM,
                  vertical: responsive.spacingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryPurple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(responsive.radiusRound),
                  border: Border.all(
                    color: AppColors.secondaryPurple.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${method.efficacyPercentage} Effective',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.secondaryPurple,
                  ).copyWith(
                    fontSize: responsive.fontSize(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





