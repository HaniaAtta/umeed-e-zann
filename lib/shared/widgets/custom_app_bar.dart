import 'package:flutter/material.dart';
import '../../contents/colors.dart';
import '../../contents/assets.dart';
import '../../core/responsive/responsive.dart';
import '../../core/navigation/app_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showLogo;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showLogo = true,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: AppBar(
          title: showLogo
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with girly styling
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.home, (route) => false),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildLogo(responsive),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: responsive.getFontSize(18, 20, 22),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: AppColors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Text(
                  title,
                  style: TextStyle(
                    fontSize: responsive.getFontSize(18, 20, 22),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.white,
                  ),
                ),
          centerTitle: centerTitle,
          leading: leading ?? (showBackButton
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.white,
                    size: responsive.getFontSize(18, 20, 22),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: AppColors.white,
                      size: responsive.getFontSize(22, 24, 26),
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                )),
          actions: actions,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB8A8D4), // Light cool purple
                  Color(0xFFA891C8), // Medium cool purple
                  Color(0xFF9A7FBD), // Slightly deeper cool purple
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(Responsive responsive) {
    return Image.asset(
      AppAssets.logo,
      height: responsive.getWidth(32, 36, 40),
      width: responsive.getWidth(32, 36, 40),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.verified_user, color: Colors.white, size: 20);
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);
}
