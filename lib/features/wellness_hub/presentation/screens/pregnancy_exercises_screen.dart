import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';

/// Pregnancy Exercises Screen
/// Shows safe exercises for pregnancy
class PregnancyExercisesScreen extends StatelessWidget {
  const PregnancyExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    final exercises = [
      {
        'name': 'Prenatal Yoga',
        'icon': Icons.self_improvement_rounded,
        'duration': '20-30 min',
        'benefits': 'Improves flexibility, reduces stress, prepares for labor',
        'instructions': 'Join a prenatal yoga class or follow online videos designed for pregnancy',
      },
      {
        'name': 'Walking',
        'icon': Icons.directions_walk_rounded,
        'duration': '30 min daily',
        'benefits': 'Low-impact cardio, improves circulation, boosts mood',
        'instructions': 'Walk at a comfortable pace. Stop if you feel tired or short of breath',
      },
      {
        'name': 'Swimming',
        'icon': Icons.pool_rounded,
        'duration': '30-45 min',
        'benefits': 'Full-body workout, reduces swelling, supports weight',
        'instructions': 'Swim at a moderate pace. Avoid diving or jumping',
      },
      {
        'name': 'Pilates',
        'icon': Icons.fitness_center_rounded,
        'duration': '20-30 min',
        'benefits': 'Strengthens core, improves posture, reduces back pain',
        'instructions': 'Focus on prenatal Pilates. Avoid exercises on your back after first trimester',
      },
      {
        'name': 'Light Strength Training',
        'icon': Icons.sports_gymnastics_rounded,
        'duration': '15-20 min',
        'benefits': 'Maintains muscle tone, prepares for carrying baby',
        'instructions': 'Use light weights. Focus on upper body and legs. Avoid heavy lifting',
      },
      {
        'name': 'Stretching',
        'icon': Icons.accessibility_new_rounded,
        'duration': '10-15 min',
        'benefits': 'Relieves muscle tension, improves flexibility',
        'instructions': 'Gentle stretches for back, legs, and hips. Avoid overstretching',
      },
    ];

    final exercisesToAvoid = [
      'Contact sports (basketball, soccer)',
      'High-impact activities (running, jumping)',
      'Exercises on your back after first trimester',
      'Activities with risk of falling (skiing, horseback riding)',
      'Hot yoga or hot Pilates',
      'Heavy weightlifting',
      'Scuba diving',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'wellness'),
      appBar: const CustomAppBar(
        title: 'Pregnancy Exercises',
        showLogo: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: responsive.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Safe Exercises
            Text(
              'Safe Exercises',
              style: AppTextStyles.headingLarge(
                color: AppColors.primaryDark,
              ).copyWith(
                fontSize: responsive.fontSize(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacingL),
            ...exercises.map((exercise) => Container(
                  margin: EdgeInsets.only(bottom: responsive.spacingL),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: responsive.paddingM,
                            decoration: BoxDecoration(
                              color: AppColors.successColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(responsive.radiusM),
                            ),
                            child: Icon(
                              exercise['icon'] as IconData,
                              color: AppColors.successColor,
                              size: responsive.iconSize(24),
                            ),
                          ),
                          SizedBox(width: responsive.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise['name'] as String,
                                  style: AppTextStyles.bodyLarge(
                                    color: AppColors.primaryDark,
                                  ).copyWith(
                                    fontSize: responsive.fontSize(18),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: responsive.spacingXS),
                                Text(
                                  exercise['duration'] as String,
                                  style: AppTextStyles.bodySmall(
                                    color: AppColors.primaryDark.withValues(alpha: 0.7),
                                  ).copyWith(
                                    fontSize: responsive.fontSize(13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.spacingM),
                      Container(
                        padding: responsive.paddingM,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(responsive.radiusM),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite_rounded,
                                  color: AppColors.dustyPink,
                                  size: responsive.iconSize(18),
                                ),
                                SizedBox(width: responsive.spacingS),
                                Text(
                                  'Benefits:',
                                  style: AppTextStyles.bodyMedium(
                                    color: AppColors.primaryDark,
                                  ).copyWith(
                                    fontSize: responsive.fontSize(14),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: responsive.spacingXS),
                            Text(
                              exercise['benefits'] as String,
                              style: AppTextStyles.bodySmall(
                                color: AppColors.primaryDark.withValues(alpha: 0.7),
                              ).copyWith(
                                fontSize: responsive.fontSize(13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: responsive.spacingM),
                      Container(
                        padding: responsive.paddingM,
                        decoration: BoxDecoration(
                          color: AppColors.palePink.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(responsive.radiusM),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.secondaryPurple,
                              size: responsive.iconSize(18),
                            ),
                            SizedBox(width: responsive.spacingS),
                            Expanded(
                              child: Text(
                                exercise['instructions'] as String,
                                style: AppTextStyles.bodySmall(
                                  color: AppColors.primaryDark,
                                ).copyWith(
                                  fontSize: responsive.fontSize(13),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),

            SizedBox(height: responsive.spacingXXL),

            // Exercises to Avoid
            Text(
              'Exercises to Avoid',
              style: AppTextStyles.headingLarge(
                color: AppColors.primaryDark,
              ).copyWith(
                fontSize: responsive.fontSize(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacingL),
            ...exercisesToAvoid.map((exercise) => Container(
                  margin: EdgeInsets.only(bottom: responsive.spacingM),
                  padding: responsive.paddingL,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(responsive.radiusL),
                    border: Border.all(
                      color: AppColors.dangerColor.withValues(alpha: 0.3),
                    ),
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
                        Icons.block_rounded,
                        color: AppColors.dangerColor,
                        size: responsive.iconSize(24),
                      ),
                      SizedBox(width: responsive.spacingM),
                      Expanded(
                        child: Text(
                          exercise,
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.primaryDark,
                          ).copyWith(
                            fontSize: responsive.fontSize(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

            SizedBox(height: responsive.spacingXXL),

            // Important Note
            Container(
              padding: responsive.paddingXL,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(responsive.radiusL),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: AppColors.warning,
                    size: responsive.iconSize(24),
                  ),
                  SizedBox(width: responsive.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important',
                          style: AppTextStyles.bodyLarge(
                            color: AppColors.primaryDark,
                          ).copyWith(
                            fontSize: responsive.fontSize(16),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: responsive.spacingS),
                        Text(
                          'Always consult with your healthcare provider before starting any exercise routine during pregnancy. Stop immediately if you experience pain, dizziness, or shortness of breath.',
                          style: AppTextStyles.bodySmall(
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
          ],
        ),
      ),
    );
  }
}


