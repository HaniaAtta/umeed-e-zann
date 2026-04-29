import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../providers/maternity_wing_provider.dart';

/// Pregnancy Tips Screen
/// Shows daily health tips based on current week
class PregnancyTipsScreen extends StatelessWidget {
  const PregnancyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = Provider.of<MaternityWingProvider>(context, listen: false);
    final currentWeek = provider.getCurrentWeek() ?? 20;

    final generalTips = [
      'Stay hydrated - aim for 8-10 glasses of water daily',
      'Get 7-9 hours of sleep each night',
      'Take prenatal vitamins daily',
      'Listen to your body and rest when needed',
      'Attend all prenatal appointments',
      'Practice good hygiene to prevent infections',
      'Avoid smoking and secondhand smoke',
      'Manage stress with relaxation techniques',
    ];

    final weekSpecificTips = _getWeekSpecificTips(currentWeek);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'wellness'),
      appBar: const CustomAppBar(
        title: 'Health Tips',
        showLogo: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: responsive.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Week-specific Tips
            Container(
              padding: responsive.paddingXL,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.softPink,
                    AppColors.palePink,
                  ],
                ),
                borderRadius: BorderRadius.circular(responsive.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softPink.withValues(alpha: 0.3),
                    blurRadius: responsive.spacingL,
                    offset: Offset(0, responsive.spacingM),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_rounded,
                        color: AppColors.white,
                        size: responsive.iconSize(28),
                      ),
                      SizedBox(width: responsive.spacingM),
                      Text(
                        'Week $currentWeek Tips',
                        style: AppTextStyles.headingSmall(
                          color: AppColors.white,
                        ).copyWith(
                          fontSize: responsive.fontSize(20),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.spacingL),
                  ...weekSpecificTips.map((tip) => Padding(
                        padding: EdgeInsets.only(bottom: responsive.spacingM),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: responsive.spacingXS),
                              width: responsive.size(6),
                              height: responsive.size(6),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: responsive.spacingM),
                            Expanded(
                              child: Text(
                                tip,
                                style: AppTextStyles.bodyMedium(
                                  color: AppColors.white,
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
              ),
            ),

            SizedBox(height: responsive.spacingXXL),

            // General Tips
            Text(
              'General Health Tips',
              style: AppTextStyles.headingLarge(
                color: AppColors.primaryDark,
              ).copyWith(
                fontSize: responsive.fontSize(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacingL),
            ...generalTips.map((tip) => Container(
                  margin: EdgeInsets.only(bottom: responsive.spacingM),
                  padding: responsive.paddingL,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(responsive.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withValues(alpha: 0.08),
                        blurRadius: responsive.spacingM,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.successColor,
                        size: responsive.iconSize(24),
                      ),
                      SizedBox(width: responsive.spacingM),
                      Expanded(
                        child: Text(
                          tip,
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
        ),
      ),
    );
  }

  List<String> _getWeekSpecificTips(int week) {
    if (week <= 12) {
      return [
        'Focus on folic acid - crucial for neural tube development',
        'Eat small, frequent meals to manage nausea',
        'Avoid strong smells that trigger morning sickness',
        'Start taking prenatal vitamins if you haven\'t already',
      ];
    } else if (week <= 24) {
      return [
        'This is a great time for light exercise',
        'Eat iron-rich foods to prevent anemia',
        'Stay hydrated to support increased blood volume',
        'Consider starting prenatal classes',
      ];
    } else if (week <= 36) {
      return [
        'Sleep on your left side for better circulation',
        'Practice breathing exercises for labor',
        'Prepare your hospital bag',
        'Continue light exercise but listen to your body',
      ];
    } else {
      return [
        'Rest as much as possible',
        'Watch for signs of labor',
        'Have your support person ready',
        'Trust your body - you\'ve got this!',
      ];
    }
  }
}


