import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';

/// Animated Feature Card for Vertical Layout
/// Beautiful card with fade-in and slide animations, descriptions, and premium design
class AnimatedFeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback onTap;
  final int index; // For staggered animation

  const AnimatedFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onTap,
    required this.index,
  });

  @override
  State<AnimatedFeatureCard> createState() => _AnimatedFeatureCardState();
}

class _AnimatedFeatureCardState extends State<AnimatedFeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Staggered animation based on index
    final delay = widget.index * 100.0;
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          delay / 600,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          delay / 600,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          delay / 600,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // Start animation after a small delay
    Future.delayed(Duration(milliseconds: delay.toInt()), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _isPressed = true);
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              widget.onTap();
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.identity()
                // ignore: deprecated_member_use
                ..scale(_isPressed ? 0.98 : 1.0),
              margin: EdgeInsets.only(bottom: responsive.spacingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.primaryColor,
                    widget.secondaryColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(responsive.radiusXXL),
                boxShadow: [
                  BoxShadow(
                    color: widget.primaryColor.withValues(alpha: 0.4),
                    blurRadius: responsive.spacingXL,
                    offset: Offset(0, responsive.spacingM),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.1),
                    blurRadius: responsive.spacingL,
                    offset: Offset(0, responsive.spacingS),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(responsive.radiusXXL),
                  onTap: widget.onTap,
                  child: Padding(
                    padding: EdgeInsets.all(responsive.spacingXL),
                    child: Row(
                      children: [
                        // Icon Container
                        Container(
                          width: responsive.size(72),
                          height: responsive.size(72),
                          decoration: BoxDecoration(
                            color: widget.primaryColor.withValues(alpha: 0.35),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.4),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.primaryColor.withValues(alpha: 0.3),
                                blurRadius: responsive.spacingM,
                                offset: Offset(0, responsive.spacingS),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            color: AppColors.white,
                            size: responsive.iconSize(36),
                          ),
                        ),
                        SizedBox(width: responsive.spacingL),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: AppTextStyles.headingMedium(
                                  color: AppColors.white,
                                  weight: FontWeight.bold,
                                  fontSize: responsive.fontSize(22),
                                ),
                              ),
                              SizedBox(height: responsive.spacingS),
                              Text(
                                widget.description,
                                style: AppTextStyles.bodyMedium(
                                  color: AppColors.white.withValues(alpha: 0.95),
                                  fontSize: responsive.fontSize(14),
                                ).copyWith(
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: responsive.spacingM),
                        // Arrow Icon
                        Container(
                          padding: EdgeInsets.all(responsive.spacingM),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.white,
                            size: responsive.iconSize(20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

