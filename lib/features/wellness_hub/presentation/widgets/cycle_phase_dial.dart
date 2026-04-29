import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';

/// Cycle Phase Dial Widget
/// Large circular indicator showing current cycle phase and day
/// Animated fill with smooth arc drawing and color transition
class CyclePhaseDial extends StatelessWidget {
  final int currentDay;
  final String phase;
  final Color phaseColor;
  final double progress; // 0.0 to 1.0

  const CyclePhaseDial({
    super.key,
    required this.currentDay,
    required this.phase,
    required this.phaseColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      width: responsive.size(220),
      height: responsive.size(220),
      margin: EdgeInsets.symmetric(vertical: responsive.spacingXL),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: progress.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, child) {
          // Color transition from softPink to secondaryPurple (medium purple)
          final Color animatedColor = Color.lerp(
                AppColors.softPink,
                AppColors.secondaryPurple,
                animatedValue,
              ) ??
              AppColors.softPink;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Animated arc
              SizedBox(
                width: responsive.size(220),
                height: responsive.size(220),
                child: CircularProgressIndicator(
                  value: animatedValue,
                  strokeWidth: responsive.size(12),
                  backgroundColor: animatedColor.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(animatedColor),
                ),
              ),

              // Inner circle with gradient background
              Container(
                width: responsive.size(180),
                height: responsive.size(180),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      animatedColor.withValues(alpha: 0.3),
                      animatedColor.withValues(alpha: 0.1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: animatedColor.withValues(alpha: 0.3),
                      blurRadius: responsive.spacingXL,
                      offset: Offset(0, responsive.spacingM),
                    ),
                  ],
                ),
              ),

              // Center content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Day $currentDay',
                    style: AppTextStyles.displayMedium(
                      color: AppColors.primaryDark,
                    ).copyWith(
                      fontSize: responsive.fontSize(36),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.spacingXS),
                  Text(
                    phase,
                    style: AppTextStyles.bodyLarge(
                      color: AppColors.primaryDark,
                    ).copyWith(
                      fontSize: responsive.fontSize(16),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}





