import 'package:flutter/material.dart';
import '../../contents/colors.dart';
import '../../contents/textstyles.dart';
import '../extensions/extensions.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _buildNavIcon(BuildContext context, IconData icon) {
    return Icon(
      icon,
      size: context.responsive(22), // Smaller icon for more space
    );
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = context.responsive(10); // Smaller font size
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.mediumPurple,
        unselectedItemColor: AppColors.grey,
        selectedFontSize: fontSize,
        unselectedFontSize: fontSize,
        iconSize: context.responsive(22),
        selectedLabelStyle: AppTextStyles.bodySmall1(context).copyWith(
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
          color: AppColors.mediumPurple,
        ),
        unselectedLabelStyle: AppTextStyles.bodySmall1(context).copyWith(
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
          color: AppColors.grey,
        ),
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon(context, Icons.home_outlined),
            activeIcon: _buildNavIcon(context, Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(context, Icons.shield_outlined),
            activeIcon: _buildNavIcon(context, Icons.shield),
            label: 'Safety',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(context, Icons.favorite_outline),
            activeIcon: _buildNavIcon(context, Icons.favorite),
            label: 'Wellness',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(context, Icons.trending_up_outlined),
            activeIcon: _buildNavIcon(context, Icons.trending_up),
            label: 'Growth',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(context, Icons.gavel_outlined),
            activeIcon: _buildNavIcon(context, Icons.gavel),
            label: 'Legal',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(context, Icons.shopping_bag_outlined),
            activeIcon: _buildNavIcon(context, Icons.shopping_bag),
            label: 'Market',
          ), // Shortened from 'Marketplace'
        ],
      ),
    );
  }
}

