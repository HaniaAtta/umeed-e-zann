import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../models/contraception_method.dart';
import '../widgets/contraception_card.dart';
import '../widgets/contraception_detail_sheet.dart';
import 'contraception_quiz_screen.dart';

/// Family Planning Screen
/// Educational module with vertical layout of contraception methods
/// Clean UI using AppColors.background and AppColors.secondaryPurple
class FamilyPlanningScreen extends StatelessWidget {
  const FamilyPlanningScreen({super.key});

  void _showMethodDetails(BuildContext context, ContraceptionMethod method) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContraceptionDetailSheet(method: method),
    );
  }

  void _findRightMethod(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ContraceptionQuizScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final methods = ContraceptionMethodsData.methods;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'wellness'),
      appBar: const CustomAppBar(
        title: 'Family Planning',
        showLogo: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: responsive.paddingXL.copyWith(
                top: responsive.spacingXXL,
                bottom: responsive.spacingXL,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.05),
                    blurRadius: responsive.spacingS,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Choose Your Method',
                    style: AppTextStyles.headingLarge(
                      color: AppColors.primaryDark,
                    ).copyWith(
                      fontSize: responsive.fontSize(26),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.spacingS),
                  Text(
                    'Tap a card to view details',
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.primaryDark.withValues(alpha: 0.7),
                    ).copyWith(
                      fontSize: responsive.fontSize(14),
                    ),
                  ),
                ],
              ),
            ),
            
            // Vertical Cards
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.spacingXL,
                vertical: responsive.spacingXL,
              ),
              child: Column(
                children: methods.map((method) {
                  return ContraceptionCard(
                    method: method,
                    isVertical: true,
                    onTap: () => _showMethodDetails(context, method),
                  );
                }).toList(),
              ),
            ),
            
            // Bottom Button
            Container(
              width: double.infinity,
              padding: responsive.screenPadding.copyWith(
                top: responsive.spacingL,
                bottom: responsive.spacingXXL,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.05),
                    blurRadius: responsive.spacingS,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _findRightMethod(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryPurple,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.spacingL,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(responsive.radiusL),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Find what is right for me',
                    style: AppTextStyles.buttonText(
                      color: AppColors.white,
                    ).copyWith(
                      fontSize: responsive.fontSize(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
