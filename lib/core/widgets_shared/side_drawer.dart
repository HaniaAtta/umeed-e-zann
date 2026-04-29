import 'package:flutter/material.dart';
import '../../contents/colors.dart';
import '../../contents/textstyles.dart';
import '../../contents/assets.dart';
import '../services/user_service.dart';
import '../extensions/extensions.dart';
import '../theme/theme_helper.dart';
import '../navigation/app_router.dart';
import '../../features/growth/presentation/pages/my_progress_screen.dart';
import '../../features/growth/presentation/pages/bookmarked_courses_screen.dart';
import '../../features/growth/presentation/pages/certificates_screen.dart';
import '../../features/growth/presentation/pages/financial_literacy_screen.dart';
import '../../features/profile/presentation/pages/settings_screen.dart';
import '../navigation/route_paths.dart';
import '../widgets/language_selector.dart';

class SideDrawer extends StatelessWidget {
  final String? currentModule; // 'safety', 'wellness', 'growth', etc.
  
  const SideDrawer({super.key, this.currentModule});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mediumPurple,
                    AppColors.mediumBluePurple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: context.responsive(40),
                    backgroundColor: AppColors.white,
                    child: Image.asset(
                      AppAssets.logo,
                      width: context.responsive(50),
                      height: context.responsive(50),
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: context.responsive(40),
                          color: AppColors.mediumPurple,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingM(context)),
                  Text(
                    UserService().userName,
                    style: AppTextStyles.heading3(context).copyWith(
                      color: AppColors.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingS(context)),
                  Text(
                    UserService().userEmail.isNotEmpty 
                        ? UserService().userEmail 
                        : 'user@example.com',
                    style: AppTextStyles.bodySmall1(context).copyWith(
                      color: AppColors.lightText.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            // Drawer items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Home/Notification/Community Module Items (same as home)
                  if (currentModule == null || currentModule == 'community') ...[
                    _buildSectionHeader(context, 'Quick Access'),
                    _buildDrawerItem(
                      context,
                      icon: Icons.shield,
                      title: 'Safety Shield',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.safety);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.health_and_safety,
                      title: 'Wellness Hub',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.wellness);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.school,
                      title: 'Growth Academy',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.growth);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.shopping_bag,
                      title: 'Marketplace',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.marketplace);
                      },
                    ),
                    const Divider(),
                  ],
                  // Module-specific items
                  if (currentModule == 'safety') ...[
                    _buildSectionHeader(context, 'Safety Features'),
                    _buildDrawerItem(
                      context,
                      icon: Icons.emergency,
                      title: 'SOS Emergency',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.safety);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.location_on,
                      title: 'Live Tracking',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.safety);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.vibration,
                      title: 'Shake to Alert',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.safety);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.phone_in_talk,
                      title: 'Fake Call',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.safety);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.contacts,
                      title: 'Trusted Contacts',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.safety);
                      },
                    ),
                    const Divider(),
                  ],
                  if (currentModule == 'growth') ...[
                    _buildSectionHeader(context, 'Growth Academy'),
                    _buildDrawerItem(
                      context,
                      icon: Icons.school,
                      title: 'All Courses',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.growth);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.trending_up,
                      title: 'My Progress',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MyProgressScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.bookmark,
                      title: 'Bookmarked Courses',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const BookmarkedCoursesScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.verified,
                      title: 'Certificates',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CertificatesScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.account_balance_wallet,
                      title: 'Financial Literacy',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const FinancialLiteracyScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                  // Wellness Module Items
                  if (currentModule == 'wellness') ...[
                    _buildSectionHeader(context, 'Wellness Hub'),
                    _buildDrawerItem(
                      context,
                      icon: Icons.calendar_today,
                      title: 'Cycle Tracker',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.wellness);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.self_improvement,
                      title: 'Mental Health',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.wellness);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.child_care,
                      title: 'Pregnancy',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.wellness);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.video_call,
                      title: 'Tele-Health',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.wellness);
                      },
                    ),
                    const Divider(),
                  ],
                  // Marketplace Module Items
                  if (currentModule == 'marketplace') ...[
                    _buildSectionHeader(context, 'Marketplace'),
                    _buildDrawerItem(
                      context,
                      icon: Icons.add_circle_outline,
                      title: 'Add Product',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(RoutePaths.createListing);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.shopping_bag,
                      title: 'My Listings',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.marketplace);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.chat_bubble_outline,
                      title: 'Messages',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(RoutePaths.chatList);
                      },
                    ),
                    const Divider(),
                  ],
                  // Legal Module Items
                  if (currentModule == 'legal') ...[
                    _buildSectionHeader(context, 'Legal Aid'),
                    _buildDrawerItem(
                      context,
                      icon: Icons.article_rounded,
                      title: 'Legal Rights Wiki',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(AppRouter.legal);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.smart_toy_rounded,
                      title: 'AI Assistant',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(RoutePaths.aiAssistant);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.mic_rounded,
                      title: 'Voice Assistant',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(RoutePaths.voiceAssistant);
                      },
                    ),

                    _buildDrawerItem(
                      context,
                      icon: Icons.handshake_rounded,
                      title: 'Support Contacts',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(RoutePaths.supportContacts);
                      },
                    ),
                    const Divider(),
                  ],
                  // General app items
                  _buildSectionHeader(context, 'App Features'),
                  _buildDrawerItem(
                    context,
                    icon: Icons.gavel,
                    title: 'Legal Aid & Rights Wiki',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(AppRouter.legal);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.smart_toy,
                    title: 'AI Assistant',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(RoutePaths.aiAssistant);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.people,
                    title: 'Community Forum',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(AppRouter.community);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.folder,
                    title: 'Document Vault',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(RoutePaths.documentVault);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.phone,
                    title: 'Helplines Directory',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(RoutePaths.helpline);
                    },
                  ),
                  const Divider(),
                  _buildDrawerItem(
                    context,
                    icon: Icons.language,
                    title: 'Language',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LanguageSelector(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(AppRouter.profile);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: ThemeHelper.spacingL(context),
        top: ThemeHelper.spacingM(context),
        bottom: ThemeHelper.spacingS(context),
      ),
      child: Text(
        title,
        style: AppTextStyles.bodySmall1(context).copyWith(
          color: AppColors.mediumPurple,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.mediumPurple,
        size: context.responsive(24),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium1(context).copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: AppTextStyles.heading3(context),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium1(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium1(context).copyWith(
                color: AppColors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.login,
                    (route) => false,
              );
            },
            child: Text(
              'Logout',
              style: AppTextStyles.bodyMedium1(context).copyWith(
                color: AppColors.dangerColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

