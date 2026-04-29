import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../widgets/affirmation_card.dart';
import '../widgets/breathing_circle.dart';
import '../widgets/vent_box.dart';

/// Mental Sanctuary Screen
/// Calming, interactive space with affirmations, breathing exercise, and vent box
/// Uses AppColors.primaryDark (text) and AppColors.softPink (accents)
class MentalHealthScreen extends StatefulWidget {
  const MentalHealthScreen({super.key});

  @override
  State<MentalHealthScreen> createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  final PageController _pageController = PageController();
  int _currentAffirmationIndex = 0;

  // Mock affirmation data with English and Urdu
  final List<Map<String, dynamic>> affirmations = [
    {
      'english': 'You are strong',
      'urdu': 'تم بہت بہادر ہو',
      'gradient': [
        AppColors.softPink,
        AppColors.palePink,
      ],
    },
    {
      'english': 'This too shall pass',
      'urdu': 'یہ وقت بھی گزر جائے گا',
      'gradient': [
        AppColors.secondaryPurple,
        AppColors.accentPurple,
      ],
    },
    {
      'english': 'You are enough',
      'urdu': 'تم کافی ہو',
      'gradient': [
        AppColors.dustyPink,
        AppColors.softPink,
      ],
    },
    {
      'english': 'You are loved',
      'urdu': 'تم محبت کے قابل ہو',
      'gradient': [
        AppColors.accentPurple,
        AppColors.secondaryPurple,
      ],
    },
    {
      'english': 'Take it one day at a time',
      'urdu': 'ایک ایک دن کر کے دیکھو',
      'gradient': [
        AppColors.palePink,
        AppColors.softPink,
      ],
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _shareAffirmation() {
    // Handle share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Affirmation shared!'),
        backgroundColor: AppColors.primaryDark,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'wellness'),
      appBar: const CustomAppBar(
        title: 'Mental Health',
        showLogo: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: responsive.screenPadding.copyWith(
          top: responsive.spacingXL,
          bottom: responsive.spacingXXL,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Section: Swipeable Affirmations
            _buildAffirmationsSection(context, responsive),
            
            SizedBox(height: responsive.spacingXXL),
            
            // 2. Middle Section: Breathing Circle
            _buildBreathingSection(context, responsive),
            
            SizedBox(height: responsive.spacingXXL),
            
            // 3. Bottom Section: Vent Box
            const VentBox(),
          ],
        ),
      ),
    );
  }

  /// Build swipeable affirmations section with PageView
  Widget _buildAffirmationsSection(BuildContext context, Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.spacingL),
          child: Text(
            'Daily Affirmations',
            style: AppTextStyles.headingMedium(
              color: AppColors.primaryDark,
            ).copyWith(
              fontSize: responsive.fontSize(22),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        SizedBox(height: responsive.spacingL),
        
        // PageView for swipeable cards
        SizedBox(
          height: responsive.size(280),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentAffirmationIndex = index;
              });
            },
            itemCount: affirmations.length,
            itemBuilder: (context, index) {
              final affirmation = affirmations[index];
              return AffirmationCard(
                englishText: affirmation['english'] as String,
                urduText: affirmation['urdu'] as String,
                gradientColors: affirmation['gradient'] as List<Color>,
                onShare: _shareAffirmation,
              );
            },
          ),
        ),
        
        SizedBox(height: responsive.spacingM),
        
        // Page indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            affirmations.length,
            (index) => Container(
              width: responsive.size(8),
              height: responsive.size(8),
              margin: EdgeInsets.symmetric(horizontal: responsive.spacingXS),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentAffirmationIndex == index
                    ? AppColors.softPink
                    : AppColors.softPink.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build breathing exercise section
  Widget _buildBreathingSection(BuildContext context, Responsive responsive) {
    return Container(
      padding: responsive.paddingXXL,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(responsive.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: responsive.spacingL,
            offset: Offset(0, responsive.spacingS),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section title
          Text(
            'Breathe',
            style: AppTextStyles.headingSmall(
              color: AppColors.primaryDark,
            ).copyWith(
              fontSize: responsive.fontSize(20),
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: responsive.spacingXL),
          
          // Breathing circle animation
          const BreathingCircle(),
          
          SizedBox(height: responsive.spacingL),
          
          // Instruction text
          Text(
            'Follow the rhythm and breathe naturally',
            style: AppTextStyles.bodySmall(
              color: AppColors.primaryDark.withValues(alpha: 0.7),
            ).copyWith(
              fontSize: responsive.fontSize(13),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
