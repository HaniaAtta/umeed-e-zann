import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';

/// Affirmation Card Widget
/// Individual card for swipeable affirmations deck
/// Shows English and Urdu text with gradient background
class AffirmationCard extends StatelessWidget {
  final String englishText;
  final String urduText;
  final List<Color> gradientColors;
  final VoidCallback? onShare;

  const AffirmationCard({
    super.key,
    required this.englishText,
    required this.urduText,
    required this.gradientColors,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(responsive.radiusXL),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: responsive.spacingXL,
            offset: Offset(0, responsive.spacingM),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Share button in top right
          Positioned(
            top: responsive.spacingL,
            right: responsive.spacingL,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onShare,
                borderRadius: BorderRadius.circular(responsive.radiusRound),
                child: Container(
                  padding: responsive.paddingS,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.share_rounded,
                    color: AppColors.white,
                    size: responsive.iconSize(24),
                  ),
                ),
              ),
            ),
          ),
          
          // Center content
          Padding(
            padding: responsive.paddingXXL,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // English text
                Text(
                  englishText,
                  style: AppTextStyles.headingLarge(
                    color: AppColors.white,
                  ).copyWith(
                    fontSize: responsive.fontSize(24),
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: responsive.spacingXL),
                
                // Urdu text
                Text(
                  urduText,
                  style: AppTextStyles.getUrduStyle(
                    context,
                    AppTextStyles.headingMedium(
                      color: AppColors.white,
                    ).copyWith(
                      fontSize: responsive.fontSize(20),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






