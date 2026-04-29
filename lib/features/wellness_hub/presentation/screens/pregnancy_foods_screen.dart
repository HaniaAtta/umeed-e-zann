import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';

/// Pregnancy Foods Screen
/// Shows recommended foods and foods to avoid during pregnancy
class PregnancyFoodsScreen extends StatelessWidget {
  const PregnancyFoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    final recommendedFoods = [
      {'name': 'Leafy Greens', 'icon': Icons.eco_rounded, 'benefit': 'Rich in folic acid'},
      {'name': 'Lean Protein', 'icon': Icons.set_meal_rounded, 'benefit': 'Essential for baby growth'},
      {'name': 'Whole Grains', 'icon': Icons.grain_rounded, 'benefit': 'Fiber and B vitamins'},
      {'name': 'Dairy Products', 'icon': Icons.local_drink_rounded, 'benefit': 'Calcium for bones'},
      {'name': 'Berries', 'icon': Icons.forest_rounded, 'benefit': 'Antioxidants and vitamin C'},
      {'name': 'Nuts & Seeds', 'icon': Icons.circle_rounded, 'benefit': 'Healthy fats and protein'},
      {'name': 'Legumes', 'icon': Icons.circle_outlined, 'benefit': 'Fiber, protein, iron'},
      {'name': 'Sweet Potatoes', 'icon': Icons.agriculture_rounded, 'benefit': 'Beta-carotene'},
    ];

    final foodsToAvoid = [
      {'name': 'Raw Fish', 'reason': 'Risk of parasites and bacteria'},
      {'name': 'Unpasteurized Cheese', 'reason': 'Listeria risk'},
      {'name': 'High-Mercury Fish', 'reason': 'Shark, swordfish, king mackerel'},
      {'name': 'Raw Eggs', 'reason': 'Salmonella risk'},
      {'name': 'Deli Meats', 'reason': 'Listeria unless heated'},
      {'name': 'Alcohol', 'reason': 'Can cause birth defects'},
      {'name': 'Caffeine (excess)', 'reason': 'Limit to 200mg per day'},
      {'name': 'Unwashed Produce', 'reason': 'Toxoplasmosis risk'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'wellness'),
      appBar: const CustomAppBar(
        title: 'Pregnancy Foods',
        showLogo: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: responsive.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recommended Foods Section
            Text(
              'Recommended Foods',
              style: AppTextStyles.headingLarge(
                color: AppColors.primaryDark,
              ).copyWith(
                fontSize: responsive.fontSize(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacingL),
            ...recommendedFoods.map((food) => Container(
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
                      Container(
                        padding: responsive.paddingM,
                        decoration: BoxDecoration(
                          color: AppColors.successColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(responsive.radiusM),
                        ),
                        child: Icon(
                          food['icon'] as IconData,
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
                              food['name'] as String,
                              style: AppTextStyles.bodyLarge(
                                color: AppColors.primaryDark,
                              ).copyWith(
                                fontSize: responsive.fontSize(16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: responsive.spacingXS),
                            Text(
                              food['benefit'] as String,
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
                )),

            SizedBox(height: responsive.spacingXXL),

            // Foods to Avoid Section
            Text(
              'Foods to Avoid',
              style: AppTextStyles.headingLarge(
                color: AppColors.primaryDark,
              ).copyWith(
                fontSize: responsive.fontSize(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacingL),
            ...foodsToAvoid.map((food) => Container(
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
                      Container(
                        padding: responsive.paddingM,
                        decoration: BoxDecoration(
                          color: AppColors.dangerColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(responsive.radiusM),
                        ),
                        child: Icon(
                          Icons.warning_rounded,
                          color: AppColors.dangerColor,
                          size: responsive.iconSize(24),
                        ),
                      ),
                      SizedBox(width: responsive.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food['name'] as String,
                              style: AppTextStyles.bodyLarge(
                                color: AppColors.primaryDark,
                              ).copyWith(
                                fontSize: responsive.fontSize(16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: responsive.spacingXS),
                            Text(
                              food['reason'] as String,
                              style: AppTextStyles.bodySmall(
                                color: AppColors.dangerColor,
                              ).copyWith(
                                fontSize: responsive.fontSize(13),
                              ),
                            ),
                          ],
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
}


