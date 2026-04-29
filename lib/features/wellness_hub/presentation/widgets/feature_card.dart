import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';

/// Premium Feature Card Widget
/// Stunning card design with gradient backgrounds, smooth animations, and premium shadows
/// Fully responsive - no hard-coded values
class FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color iconBackgroundColor;
  final List<Color>? gradientColors;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconBackgroundColor,
    this.gradientColors,
    required this.onTap,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final gradientColors = widget.gradientColors ??
        [
          widget.iconBackgroundColor,
          widget.iconBackgroundColor.withValues(alpha: 0.7),
        ];

    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
      },
      onTapUp: (_) {
        _animationController.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(responsive.radiusXXL),
            boxShadow: [
              BoxShadow(
                color: widget.iconBackgroundColor.withValues(alpha: 0.3),
                blurRadius: responsive.spacingXL,
                offset: Offset(0, responsive.spacingS),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.1),
                blurRadius: responsive.spacingL,
                offset: Offset(0, responsive.spacingXS * 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(responsive.radiusXXL),
              onTap: widget.onTap,
              child: Padding(
                padding: responsive.paddingXL,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: responsive.size(64),
                      height: responsive.size(64),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.white.withValues(alpha: 0.3),
                            blurRadius: responsive.spacingL,
                            offset: Offset(0, responsive.spacingXS * 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: AppColors.white,
                        size: responsive.iconSize(32),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.title,
                      style: AppTextStyles.headingSmall(
                        color: AppColors.white,
                        weight: FontWeight.w700,
                        fontSize: responsive.fontSize(18),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: responsive.spacingS),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.white.withValues(alpha: 0.8),
                      size: responsive.iconSize(14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
