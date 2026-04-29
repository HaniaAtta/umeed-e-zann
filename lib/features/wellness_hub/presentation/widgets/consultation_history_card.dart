import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/doctor.dart';

/// Consultation History Card Widget
/// Compact card showing the last doctor visited
/// With prominent 'Re-book' button
class ConsultationHistoryCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onReBook;

  const ConsultationHistoryCard({
    super.key,
    required this.doctor,
    required this.onReBook,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacingXL),
      padding: responsive.paddingL,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(responsive.radiusL),
        border: Border.all(
          color: AppColors.lightGrey,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.05),
            blurRadius: responsive.spacingS,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Doctor Avatar
          Container(
            width: responsive.size(60),
            height: responsive.size(60),
            decoration: BoxDecoration(
              color: AppColors.palePink,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.secondaryPurple,
              size: responsive.iconSize(30),
            ),
          ),
          
          SizedBox(width: responsive.spacingM),
          
          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Consultation',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.grey,
                  ).copyWith(
                    fontSize: responsive.fontSize(11),
                  ),
                ),
                SizedBox(height: responsive.spacingXS),
                Text(
                  doctor.name,
                  style: AppTextStyles.bodyLarge(
                    color: AppColors.primaryDark,
                  ).copyWith(
                    fontSize: responsive.fontSize(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: responsive.spacingXS),
                Text(
                  doctor.specialty,
                  style: AppTextStyles.bodySmall(
                    color: AppColors.grey,
                  ).copyWith(
                    fontSize: responsive.fontSize(13),
                  ),
                ),
              ],
            ),
          ),
          
          // Re-book Button
    // Re-book Button
    ElevatedButton.icon(
    onPressed: onReBook,
    icon: Icon(
    Icons.calendar_today_rounded,
    size: responsive.iconSize(18),
    ),
    label: Text(
    'Re-book',
    style: AppTextStyles.bodyMedium(
    color: AppColors.white,
    ).copyWith(
    fontSize: responsive.fontSize(14),
    fontWeight: FontWeight.w600,
    ),
    ),
    style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryDark,
    foregroundColor: AppColors.white,
    padding: EdgeInsets.symmetric(
    horizontal: responsive.spacingL,
    vertical: responsive.spacingM,
    ),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(responsive.radiusM),
    ),
    elevation: 2,
    ),
    ),


        ],
      ),
    );
  }
}






