import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/contraception_method.dart';

/// Contraception Detail Bottom Sheet
/// Shows detailed information about a contraception method
/// Includes pros, cons, and myth buster section
class ContraceptionDetailSheet extends StatelessWidget {
  final ContraceptionMethod method;

  const ContraceptionDetailSheet({
    super.key,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Container(
      padding: EdgeInsets.only(
        left: responsive.spacingXL,
        right: responsive.spacingXL,
        top: responsive.spacingXL,
        bottom: MediaQuery.of(context).viewInsets.bottom + responsive.spacingXL,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(responsive.radiusXXL),
          topRight: Radius.circular(responsive.radiusXXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: responsive.size(40),
              height: responsive.size(4),
              margin: EdgeInsets.only(bottom: responsive.spacingL),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(responsive.radiusRound),
              ),
            ),
          ),
          
          // Header: Method Name & Effectiveness Bar
          Row(
            children: [
              Expanded(
                child: Text(
                  method.name,
                  style: AppTextStyles.headingLarge(
                    color: AppColors.primaryDark,
                  ).copyWith(
                    fontSize: responsive.fontSize(24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.spacingM,
                  vertical: responsive.spacingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryPurple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(responsive.radiusRound),
                ),
                child: Text(
                  method.efficacyPercentage,
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.secondaryPurple,
                  ).copyWith(
                    fontSize: responsive.fontSize(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: responsive.spacingM),
          
          // Effectiveness Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(responsive.radiusRound),
            child: LinearProgressIndicator(
              value: method.efficacy,
              minHeight: responsive.size(8),
              backgroundColor: AppColors.lightGrey,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.secondaryPurple,
              ),
            ),
          ),
          
          SizedBox(height: responsive.spacingXXL),
          
          // Section A: Pros
          _buildSection(
            context: context,
            title: 'Benefits',
            items: method.pros,
            icon: Icons.check_circle_rounded,
            iconColor: Colors.green,
            responsive: responsive,
          ),
          
          SizedBox(height: responsive.spacingXL),
          
          // Section B: Cons
          _buildSection(
            context: context,
            title: 'Considerations',
            items: method.cons,
            icon: Icons.cancel_rounded,
            iconColor: Colors.orange,
            responsive: responsive,
          ),
          
          SizedBox(height: responsive.spacingXL),
          
          // Section C: Myth Buster
          Container(
            padding: responsive.paddingL,
            decoration: BoxDecoration(
              color: AppColors.palePink.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(responsive.radiusL),
              border: Border.all(
                color: AppColors.palePink.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_rounded,
                  color: AppColors.secondaryPurple,
                  size: responsive.iconSize(24),
                ),
                SizedBox(width: responsive.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Did you know?',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.primaryDark,
                        ).copyWith(
                          fontSize: responsive.fontSize(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: responsive.spacingXS),
                      Text(
                        method.mythBuster,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.primaryDark,
                        ).copyWith(
                          fontSize: responsive.fontSize(13),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: responsive.spacingXL),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<String> items,
    required IconData icon,
    required Color iconColor,
    required Responsive responsive,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headingSmall(
            color: AppColors.primaryDark,
          ).copyWith(
            fontSize: responsive.fontSize(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: responsive.spacingM),
        ...items.map((item) => Padding(
          padding: EdgeInsets.only(bottom: responsive.spacingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: responsive.iconSize(20),
              ),
              SizedBox(width: responsive.spacingM),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.primaryDark,
                  ).copyWith(
                    fontSize: responsive.fontSize(14),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}






