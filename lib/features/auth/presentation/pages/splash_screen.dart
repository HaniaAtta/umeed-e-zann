import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../contents/assets.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/services/notification_service.dart';
import 'package:provider/provider.dart';

/// Splash Screen with Urdu app name and Get Started button
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // We don't want to block the UI, so we initialize in the background
    // but we do it early in the splash screen
    try {
      final notificationService = Provider.of<NotificationService>(context, listen: false);
      await notificationService.initialize();
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.warmCream,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mediumPurple.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    AppAssets.logo,
                    width: context.responsive(120),
                    height: context.responsive(120),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: context.responsive(100),
                        height: context.responsive(100),
                        decoration: BoxDecoration(
                          color: AppColors.mediumPurple.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified_user,
                          size: context.responsive(60),
                          color: AppColors.mediumPurple,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: ThemeHelper.spacingXL(context)),
                // App Name in Urdu: امیدِ زن
                Text(
                  'امیدِ زن',
                  style: AppTextStyles.urduHeading1(context).copyWith(
                    fontSize: context.responsive(36),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: ThemeHelper.spacingM(context)),
                // Tagline in Urdu: خواتین کو بااختیار بنانا، مستقبل کی تعمیر
                Text(
                  'خواتین کو بااختیار بنانا، مستقبل کی تعمیر',
                  style: AppTextStyles.urduHeading3(context).copyWith(
                    color: AppColors.mediumPurple,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: ThemeHelper.spacingS(context)),
                // English subtitle
                Text(
                  'Empowering Women, Building Futures',
                  style: AppTextStyles.bodyMedium1(context).copyWith(
                    color: AppColors.secondaryText,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ThemeHelper.spacingXL(context) * 2),
                // Get Started Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(AppRouter.onboarding);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mediumPurple,
                      padding: EdgeInsets.symmetric(
                        vertical: ThemeHelper.spacingL(context),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'Get Started',
                      style: AppTextStyles.buttonLarge(context).copyWith(
                        fontSize: context.responsive(18),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
