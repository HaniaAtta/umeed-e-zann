import 'package:flutter/material.dart';
import '../../contents/colors.dart';
import '../../contents/textstyles.dart';
import '../../contents/assets.dart';
import '../../core/extensions/extensions.dart';
import '../navigation/app_router.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool showLogo;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.showLogo = false,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Standard height
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.showLogo
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _navigateToHome,
                  child: AnimatedBuilder(
                    animation: _bounceAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _bounceAnimation.value),
                        child: child,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (widget.titleColor ?? AppColors.white)
                                .withValues(alpha: 0.3),
                            blurRadius: context.responsive(8),
                            spreadRadius: context.responsive(2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppAssets.logo,
                        width: context.responsive(32),
                        height: context.responsive(32),
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: context.responsive(28),
                            height: context.responsive(28),
                            decoration: BoxDecoration(
                              color: (widget.titleColor ?? AppColors.white)
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.verified_user,
                              size: context.responsive(16),
                              color: widget.titleColor ?? AppColors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.responsive(8)),
                Flexible(
                  child: Text(
                    widget.title,
                    style: AppTextStyles.heading4(context).copyWith(
                      color: widget.titleColor ?? AppColors.white,
                      fontSize: context.responsive(16).clamp(12.0, double.infinity),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : Flexible(
              child: Text(
                widget.title,
                style: AppTextStyles.heading4(context).copyWith(
                  color: widget.titleColor ?? AppColors.white,
                  fontSize: context.responsive(16),
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: widget.backgroundColor != null
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFB8A8D4), // Light cool purple
                    Color(0xFFA891C8), // Medium cool purple
                    Color(0xFF9A7FBD), // Slightly deeper cool purple
                  ],
                ),
          color: widget.backgroundColor,
        ),
      ),
      elevation: 0,
      centerTitle: true,
      leading: widget.showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: widget.titleColor ?? AppColors.white,
                size: context.responsive(20),
              ),
              onPressed: widget.onBackPressed ??
                  () => Navigator.of(context).pop(),
            )
          : Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: widget.titleColor ?? AppColors.white,
                  size: context.responsive(24),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
      actions: widget.actions,
    );
  }
}

