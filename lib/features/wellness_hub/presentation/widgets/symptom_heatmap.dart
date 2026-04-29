import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';

/// Symptom Heatmap Widget
/// Grid showing symptom intensity over days of the week
/// Darker color = Higher intensity, Lighter color = Low intensity
class SymptomHeatmap extends StatelessWidget {
  final Map<int, int> symptomData; // Day index (0-6) -> Intensity (0-5)
  final String symptomName;

  const SymptomHeatmap({
    super.key,
    required this.symptomData,
    required this.symptomName,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacingXL),
      padding: responsive.paddingXL,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            '$symptomName Intensity',
            style: AppTextStyles.headingSmall(
              color: AppColors.primaryDark,
            ).copyWith(
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: responsive.spacingL),
          
          // Heatmap Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final intensity = symptomData[index] ?? 0;
              final opacity = 0.2 + (intensity / 5) * 0.8; // 0.2 to 1.0
              
              return Expanded(
                child: Column(
                  children: [
                    // Day label
                    Text(
                      weekDays[index],
                      style: AppTextStyles.bodySmall(
                        color: AppColors.grey,
                      ).copyWith(
                        fontSize: responsive.fontSize(11),
                      ),
                    ),
                    SizedBox(height: responsive.spacingS),
                    
                    // Intensity square
                    Container(
                      width: responsive.size(40),
                      height: responsive.size(40),
                      margin: EdgeInsets.symmetric(horizontal: responsive.spacingXS),
                      decoration: BoxDecoration(
                        color: AppColors.softPink.withValues(alpha: opacity),
                        borderRadius: BorderRadius.circular(responsive.radiusS),
                        border: Border.all(
                          color: intensity > 0
                              ? AppColors.softPink.withValues(alpha: 0.5)
                              : AppColors.lightGrey,
                          width: 1,
                        ),
                      ),
                      child: intensity > 0
                          ? Center(
                              child: Text(
                                '$intensity',
                                style: AppTextStyles.bodySmall(
                                  color: intensity > 2
                                      ? AppColors.primaryDark
                                      : AppColors.grey,
                                ).copyWith(
                                  fontSize: responsive.fontSize(12),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              );
            }),
          ),
          
          SizedBox(height: responsive.spacingL),
          
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Low',
                style: AppTextStyles.bodySmall(
                  color: AppColors.grey,
                ).copyWith(
                  fontSize: responsive.fontSize(11),
                ),
              ),
              SizedBox(width: responsive.spacingS),
              Container(
                width: responsive.size(30),
                height: responsive.size(30),
                decoration: BoxDecoration(
                  color: AppColors.softPink.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(responsive.radiusS),
                ),
              ),
              SizedBox(width: responsive.spacingM),
              Container(
                width: responsive.size(30),
                height: responsive.size(30),
                decoration: BoxDecoration(
                  color: AppColors.softPink.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(responsive.radiusS),
                ),
              ),
              SizedBox(width: responsive.spacingM),
              Container(
                width: responsive.size(30),
                height: responsive.size(30),
                decoration: BoxDecoration(
                  color: AppColors.softPink.withValues(alpha: 1.0),
                  borderRadius: BorderRadius.circular(responsive.radiusS),
                ),
              ),
              SizedBox(width: responsive.spacingS),
              Text(
                'High',
                style: AppTextStyles.bodySmall(
                  color: AppColors.grey,
                ).copyWith(
                  fontSize: responsive.fontSize(11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}






