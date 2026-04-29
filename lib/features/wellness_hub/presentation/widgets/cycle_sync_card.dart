import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';

/// Cycle Sync Card Widget
/// Dynamic suggestions card with food and habit tips based on cycle phase
/// Soft, feminine design with helpful recommendations
class CycleSyncCard extends StatelessWidget {
  final String phase;
  final String foodTip;
  final String habitTip;

  const CycleSyncCard({
    super.key,
    required this.phase,
    required this.foodTip,
    required this.habitTip,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacingXL),
      padding: responsive.paddingXL,
      decoration: BoxDecoration(
        color: AppColors.softPink.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(responsive.radiusXL),
        border: Border.all(
          color: AppColors.softPink.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPink.withValues(alpha: 0.1),
            blurRadius: responsive.spacingL,
            offset: Offset(0, responsive.spacingS),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.sync_rounded,
                color: AppColors.dustyPink,
                size: responsive.iconSize(24),
              ),
              SizedBox(width: responsive.spacingM),
              Text(
                'Cycle Syncing: $phase',
                style: AppTextStyles.headingSmall(
                  color: AppColors.primaryDark,
                ).copyWith(
                  fontSize: responsive.fontSize(18),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          SizedBox(height: responsive.spacingXL),
          
          // Food Tip
          _buildTipRow(
            context: context,
            icon: Icons.restaurant_rounded,
            text: foodTip,
            responsive: responsive,
          ),
          
          SizedBox(height: responsive.spacingL),
          
          // Habit Tip
          _buildTipRow(
            context: context,
            icon: Icons.self_improvement_rounded,
            text: habitTip,
            responsive: responsive,
          ),
        ],
      ),
    );
  }

  Widget _buildTipRow({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Responsive responsive,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: responsive.paddingS,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(responsive.radiusM),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.05),
                blurRadius: responsive.spacingS,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppColors.dustyPink,
            size: responsive.iconSize(20),
          ),
        ),
        SizedBox(width: responsive.spacingM),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium(
              color: AppColors.primaryDark,
            ).copyWith(
              fontSize: responsive.fontSize(14),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}






