import 'package:flutter/material.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../widgets/animated_feature_card.dart';
import 'cycle_tracker_screen.dart';
import 'mental_health_screen.dart';
import 'tele_health_screen.dart';
import 'maternity_wing_screen.dart';
import 'family_planning_screen.dart';

/// Premium Wellness Dashboard Screen
/// Beautiful vertical scrolling cards with animations and premium design
class WellnessDashboard extends StatelessWidget {
  const WellnessDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Premium Header with gradient
            SliverToBoxAdapter(
              child: _buildPremiumHeader(context, responsive, l10n),
            ),
            
            // Welcome Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  responsive.spacingXL,
                  responsive.spacingXXL,
                  responsive.spacingXL,
                  responsive.spacingXL,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.welcomeGreeting,
                      style: AppTextStyles.headingLarge(
                        color: AppColors.primaryDark,
                        weight: FontWeight.bold,
                        fontSize: responsive.fontSize(28),
                      ),
                    ),
                    SizedBox(height: responsive.spacingS),
                    Text(
                      l10n.exploreWellness,
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.primaryDark.withValues(alpha: 0.7),
                        fontSize: responsive.fontSize(15),
                      ).copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Feature Cards - Vertical List
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                responsive.spacingXL,
                responsive.spacingL,
                responsive.spacingXL,
                responsive.spacingXXL,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  AnimatedFeatureCard(
                    icon: Icons.calendar_today_rounded,
                    title: l10n.cycleTracker,
                    description: l10n.cycleTrackerDesc,
                    primaryColor: AppColors.softPink,
                    secondaryColor: AppColors.palePink,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CycleTrackerScreen(),
                        ),
                      );
                    },
                    index: 0,
                  ),
                  AnimatedFeatureCard(
                    icon: Icons.pregnant_woman_rounded,
                    title: l10n.maternityWing,
                    description: l10n.maternityWingDesc,
                    primaryColor: AppColors.dustyPink,
                    secondaryColor: AppColors.softPink,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MaternityWingScreen(),
                        ),
                      );
                    },
                    index: 1,
                  ),
                  AnimatedFeatureCard(
                    icon: Icons.psychology_rounded,
                    title: l10n.mentalSanctuary,
                    description: l10n.mentalSanctuaryDesc,
                    primaryColor: AppColors.secondaryPurple,
                    secondaryColor: AppColors.accentPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MentalHealthScreen(),
                        ),
                      );
                    },
                    index: 2,
                  ),
                  AnimatedFeatureCard(
                    icon: Icons.video_call_rounded,
                    title: l10n.teleHealth,
                    description: l10n.teleHealthDesc,
                    primaryColor: AppColors.accentPurple,
                    secondaryColor: AppColors.secondaryPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeleHealthScreen(),
                        ),
                      );
                    },
                    index: 3,
                  ),
                  AnimatedFeatureCard(
                    icon: Icons.family_restroom_rounded,
                    title: l10n.familyPlanning,
                    description: l10n.familyPlanningDesc,
                    primaryColor: AppColors.palePink,
                    secondaryColor: AppColors.softPink,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FamilyPlanningScreen(),
                        ),
                      );
                    },
                    index: 4,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build premium header with gradient and decorative elements
  Widget _buildPremiumHeader(BuildContext context, Responsive responsive, AppLocalizations l10n) {
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(responsive.radiusXXL),
          bottomRight: Radius.circular(responsive.radiusXXL),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.3),
            blurRadius: responsive.spacingXL,
            offset: Offset(0, responsive.spacingL),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated decorative circles (responsive)
          Positioned(
            top: -responsive.spacingXXL,
            right: -responsive.spacingXL,
            child: Container(
              width: responsive.size(150),
              height: responsive.size(150),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondaryPurple.withValues(alpha: 0.3),
                    AppColors.secondaryPurple.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: responsive.size(60),
            left: -responsive.spacingXXL,
            child: Container(
              width: responsive.size(120),
              height: responsive.size(120),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.softPink.withValues(alpha: 0.3),
                    AppColors.softPink.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -responsive.spacingXXXL,
            right: responsive.size(50),
            child: Container(
              width: responsive.size(100),
              height: responsive.size(100),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentPurple.withValues(alpha: 0.2),
                    AppColors.accentPurple.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          
          // Logo and App Name
          Padding(
            padding: EdgeInsets.fromLTRB(
              responsive.spacingXL,
              responsive.spacingXXXL,
              responsive.spacingXL,
              responsive.spacingXXXL,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(responsive.radiusL),
                  child: Container(
                    width: responsive.size(60),
                    height: responsive.size(60),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.softPink,
                          AppColors.palePink,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.softPink.withValues(alpha: 0.5),
                          blurRadius: responsive.spacingM + responsive.spacingS,
                          offset: Offset(0, responsive.spacingS),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      color: AppColors.white,
                      size: responsive.iconSize(32),
                    ),
                  ),
                ),
                SizedBox(width: responsive.spacingL),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appName,
                        style: AppTextStyles.headingLarge(
                          color: AppColors.white,
                          weight: FontWeight.bold,
                          fontSize: responsive.fontSize(24),
                        ),
                      ),
                      SizedBox(height: responsive.spacingXS),
                      Text(
                        l10n.wellnessHub,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.white.withValues(alpha: 0.8),
                          fontSize: responsive.fontSize(14),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: responsive.paddingS,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.white,
                    size: responsive.iconSize(24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
