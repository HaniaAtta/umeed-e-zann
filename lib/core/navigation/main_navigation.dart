import 'package:flutter/material.dart';
import '../../features/marketplace/presentation/pages/marketplace_home_page.dart';
import '../../features/community/presentation/pages/forum_home_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/verification/presentation/pages/verification_status_page.dart';
import '../../contents/colors.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MarketplaceHomePage(),
    const ForumHomePage(),
    const ChatListPage(),
    const VerificationStatusPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: AppColors.bottomNavGradient,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, -4),
            ),
            BoxShadow(
              color: AppColors.primaryPurple.withValues(alpha: 0.2),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: AppColors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.primaryLightPink,
            unselectedItemColor: AppColors.white.withValues(alpha: 0.6),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _currentIndex == 0
                        ? AppColors.primaryLightPink.withValues(alpha: 0.2)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    _currentIndex == 0
                        ? Icons.shopping_bag
                        : Icons.shopping_bag_outlined,
                    size: 24,
                  ),
                ),
                label: 'Marketplace',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _currentIndex == 1
                        ? AppColors.primaryLightPink.withValues(alpha: 0.2)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    _currentIndex == 1
                        ? Icons.forum
                        : Icons.forum_outlined,
                    size: 24,
                  ),
                ),
                label: 'Community',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _currentIndex == 2
                        ? AppColors.primaryLightPink.withValues(alpha: 0.2)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    _currentIndex == 2
                        ? Icons.chat_bubble
                        : Icons.chat_bubble_outline,
                    size: 24,
                  ),
                ),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _currentIndex == 3
                        ? AppColors.primaryLightPink.withValues(alpha: 0.2)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    _currentIndex == 3
                        ? Icons.verified_user
                        : Icons.verified_user_outlined,
                    size: 24,
                  ),
                ),
                label: 'Verification',
              ),
            ],
          ),
        ),
      ),
    );
  }
}


