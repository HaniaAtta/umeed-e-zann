import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class FinancialLiteracyScreen extends StatelessWidget {
  const FinancialLiteracyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'growth'),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.financialLiteracy,
        showLogo: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mediumPurple,
                    AppColors.mediumBluePurple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: context.responsive(64),
                    color: AppColors.lightText,
                  ),
                  SizedBox(height: ThemeHelper.spacingM(context)),
                  Text(
                    AppLocalizations.of(context)!.financialLiteracy,
                    style: AppTextStyles.heading2(context).copyWith(
                      color: AppColors.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingS(context)),
                  Text(
                    AppLocalizations.of(context)!.empowerFinancialKnowledge,
                    style: AppTextStyles.bodyMedium1(context).copyWith(
                      color: AppColors.lightText.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),
            // Topics Section
            Text(
              AppLocalizations.of(context)!.keyTopics,
              style: AppTextStyles.heading3(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ThemeHelper.spacingM(context)),
            _buildTopicCard(
              context,
              icon: Icons.savings,
              title: AppLocalizations.of(context)!.budgetingSaving,
              description: AppLocalizations.of(context)!.budgetingDesc,
            ),
            _buildTopicCard(
              context,
              icon: Icons.credit_card,
              title: AppLocalizations.of(context)!.bankingCredit,
              description: AppLocalizations.of(context)!.bankingDesc,
            ),
            _buildTopicCard(
              context,
              icon: Icons.trending_up,
              title: AppLocalizations.of(context)!.investingBasics,
              description: AppLocalizations.of(context)!.investingDesc,
            ),
            _buildTopicCard(
              context,
              icon: Icons.security,
              title: AppLocalizations.of(context)!.financialSecurity,
              description: AppLocalizations.of(context)!.securityDesc,
            ),
            _buildTopicCard(
              context,
              icon: Icons.business,
              title: AppLocalizations.of(context)!.entrepreneurship,
              description: AppLocalizations.of(context)!.entrepreneurshipDesc,
            ),
            _buildTopicCard(
              context,
              icon: Icons.receipt_long,
              title: AppLocalizations.of(context)!.taxPlanning,
              description: AppLocalizations.of(context)!.taxDesc,
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),
            // Resources Section
            Text(
              AppLocalizations.of(context)!.resources,
              style: AppTextStyles.heading3(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ThemeHelper.spacingM(context)),
            _buildResourceCard(
              context,
              title: AppLocalizations.of(context)!.financialCalculators,
              description: AppLocalizations.of(context)!.calculatorsDesc,
              icon: Icons.calculate,
            ),
            _buildResourceCard(
              context,
              title: AppLocalizations.of(context)!.videoTutorials,
              description: AppLocalizations.of(context)!.tutorialsDesc,
              icon: Icons.video_library,
            ),
            _buildResourceCard(
              context,
              title: AppLocalizations.of(context)!.articlesGuides,
              description: AppLocalizations.of(context)!.articlesDesc,
              icon: Icons.article,
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),
            // Coming Soon Notice
            Container(
              padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
              decoration: BoxDecoration(
                color: AppColors.mediumPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                border: Border.all(
                  color: AppColors.mediumPurple.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.mediumPurple,
                  ),
                  SizedBox(width: ThemeHelper.spacingM(context)),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.moreContentComingSoon,
                      style: AppTextStyles.bodyMedium1(context).copyWith(
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(ThemeHelper.spacingM(context)),
        leading: Container(
          padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
          decoration: BoxDecoration(
            color: AppColors.mediumPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
          ),
          child: Icon(
            icon,
            color: AppColors.mediumPurple,
            size: context.responsive(28),
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium1(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: ThemeHelper.spacingS(context)),
          child: Text(
            description,
            style: AppTextStyles.bodySmall1(context),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: context.responsive(16),
          color: AppColors.grey,
        ),
        onTap: () {
          _showTopicDetails(context, title, description, icon);
        },
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(ThemeHelper.spacingM(context)),
        leading: Icon(
          icon,
          color: AppColors.mediumPurple,
          size: context.responsive(28),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium1(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          description,
          style: AppTextStyles.bodySmall1(context),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: context.responsive(16),
          color: AppColors.grey,
        ),
        onTap: () {
          _showResourceDetails(context, title, description, icon);
        },
      ),
    );
  }

  void _showTopicDetails(BuildContext context, String title, String description, IconData icon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ThemeHelper.radiusXL),
            topRight: Radius.circular(ThemeHelper.radiusXL),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mediumPurple,
                    AppColors.mediumBluePurple,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ThemeHelper.radiusXL),
                  topRight: Radius.circular(ThemeHelper.radiusXL),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                    ),
                    child: Icon(icon, color: AppColors.lightText, size: 32),
                  ),
                  SizedBox(width: ThemeHelper.spacingM(context)),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.heading3(context).copyWith(
                        color: AppColors.lightText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.lightText),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: AppTextStyles.bodyMedium1(context),
                    ),
                    SizedBox(height: ThemeHelper.spacingXL(context)),
                    Text(
                      AppLocalizations.of(context)!.keyLearningPoints,
                      style: AppTextStyles.heading4(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mediumPurple,
                      ),
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    _buildLearningPoint(context, AppLocalizations.of(context)!.understandFundamentals),
                    _buildLearningPoint(context, AppLocalizations.of(context)!.learnPracticalApps),
                    _buildLearningPoint(context, AppLocalizations.of(context)!.getActionableTips),
                    _buildLearningPoint(context, AppLocalizations.of(context)!.accessRealWorldExamples),
                    SizedBox(height: ThemeHelper.spacingXL(context)),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!.detailedContentComingSoon(title)),
                              backgroundColor: AppColors.mediumPurple,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mediumPurple,
                          padding: EdgeInsets.symmetric(
                            vertical: ThemeHelper.spacingM(context),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.startLearning,
                          style: AppTextStyles.buttonMedium(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningPoint(BuildContext context, String point) {
    return Padding(
      padding: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.successColor,
            size: 20,
          ),
          SizedBox(width: ThemeHelper.spacingM(context)),
          Expanded(
            child: Text(
              point,
              style: AppTextStyles.bodyMedium1(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showResourceDetails(BuildContext context, String title, String description, IconData icon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: AppColors.mediumPurple),
            SizedBox(width: ThemeHelper.spacingM(context)),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.heading3(context),
              ),
            ),
          ],
        ),
        content: Text(
          description,
          style: AppTextStyles.bodyMedium1(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.close,
              style: AppTextStyles.bodyMedium1(context).copyWith(
                color: AppColors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.featureComingSoon(title)),
                  backgroundColor: AppColors.mediumPurple,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mediumPurple,
            ),
            child: Text(
              AppLocalizations.of(context)!.access,
              style: AppTextStyles.buttonMedium(context),
            ),
          ),
        ],
      ),
    );
  }
}
