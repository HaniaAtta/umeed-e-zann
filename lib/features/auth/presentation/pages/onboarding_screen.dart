import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/navigation/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Stay Safe — Anytime, Anywhere',
      description: 'Your safety is our priority. Access emergency features instantly.',
      icon: Icons.shield,
      features: [
        'SOS Alerts',
        'Live Location',
        'Shake-to-Alert',
      ],
      color: AppColors.dangerColor,
    ),
    OnboardingPage(
      title: 'Your Health, Tracked With Care',
      description: 'Comprehensive health tools designed for women\'s wellness.',
      icon: Icons.favorite,
      features: [
        'Cycle Tracker',
        'Pregnancy Tools',
        'Mental Health Support',
        'Doctor Consultations',
      ],
      color: AppColors.softPink,
    ),
    OnboardingPage(
      title: 'Learn. Earn. Connect.',
      description: 'Build skills, grow your business, and connect with a supportive community.',
      icon: Icons.trending_up,
      features: [
        'Skills & Courses',
        'Marketplace',
        'Legal Aid',
        'AI Assistant',
      ],
      color: AppColors.mediumBluePurple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacementNamed(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _goToLogin,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyMedium1(context).copyWith(
                      color: AppColors.mediumPurple,
                    ),
                  ),
                ),
              ),
            ),
            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_pages[index], context);
                },
              ),
            ),
            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => _buildPageIndicator(index == _currentPage, context),
              ),
            ),
            SizedBox(height: ThemeHelper.spacingL(context)),
            // Next/Get Started button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ThemeHelper.spacingXL(context),
                vertical: ThemeHelper.spacingM(context),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mediumPurple,
                    padding: EdgeInsets.symmetric(
                      vertical: ThemeHelper.spacingM(context),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ThemeHelper.radiusM,
                      ),
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: AppTextStyles.buttonLarge(context),
                  ),
                ),
              ),
            ),
            SizedBox(height: ThemeHelper.spacingM(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: context.responsive(120),
            height: context.responsive(120),
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: context.responsive(60),
              color: page.color,
            ),
          ),
          SizedBox(height: ThemeHelper.spacingXL(context)),
          // Title
          Text(
            page.title,
            style: AppTextStyles.heading2(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ThemeHelper.spacingM(context)),
          // Description
          Text(
            page.description,
            style: AppTextStyles.bodyLarge1(context).copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ThemeHelper.spacingXL(context)),
          // Features
          ...page.features.map((feature) => Padding(
            padding: EdgeInsets.only(
              bottom: ThemeHelper.spacingM(context),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: page.color,
                  size: context.responsive(24),
                ),
                SizedBox(width: ThemeHelper.spacingM(context)),
                Expanded(
                  child: Text(
                    feature,
                    style: AppTextStyles.bodyMedium1(context),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ThemeHelper.spacingS(context) / 2,
      ),
      width: isActive ? context.responsive(24) : context.responsive(8),
      height: context.responsive(8),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.mediumPurple
            : AppColors.mediumPurple.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(ThemeHelper.radiusCircular),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final List<String> features;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.features,
    required this.color,
  });
}

