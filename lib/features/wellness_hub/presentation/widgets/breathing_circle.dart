import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';

/// Breathing Circle Widget
/// Animated circle that scales up and down continuously
/// 4-second duration cycle for breathing exercise
class BreathingCircle extends StatefulWidget {
  const BreathingCircle({super.key});

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Breathing circle
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: responsive.size(200),
                height: responsive.size(200),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryPurple.withValues(alpha: 0.3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryPurple.withValues(alpha: 0.2),
                      blurRadius: responsive.spacingXL * 2,
                      spreadRadius: responsive.spacingM,
                    ),
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.all(responsive.spacingL),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryPurple.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: responsive.spacingXL),
            
            // Breathing text - synchronized with animation
            Text(
              _controller.value < 0.5 ? 'Inhale...' : 'Exhale...',
              style: AppTextStyles.headingMedium(
                color: AppColors.primaryDark,
              ).copyWith(
                fontSize: responsive.fontSize(22),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        );
      },
    );
  }
}

