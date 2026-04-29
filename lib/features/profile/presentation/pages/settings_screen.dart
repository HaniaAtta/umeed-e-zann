import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/services/user_service.dart';
import '../../../../features/auth/presentation/viewmodels/auth_provider.dart';
import '../../../../core/navigation/app_router.dart';
import 'terms_of_service_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserService _userService = UserService();
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _locationEnabled = true;
  bool _biometricEnabled = false;
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    // Defer loading to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  Future<void> _loadSettings() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.getCurrentUser();
      final user = authProvider.currentUser;
      if (user != null && user.settings != null) {
        setState(() {
          _notificationsEnabled = user.settings!['notificationsEnabled'] ?? true;
          _emailNotificationsEnabled = user.settings!['emailNotificationsEnabled'] ?? true;
          _locationEnabled = user.settings!['locationEnabled'] ?? true;
          _biometricEnabled = user.settings!['biometricEnabled'] ?? false;
          _language = user.settings!['language'] ?? 'English';
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveSettings() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.currentUser?.id;
      if (userId == null) return;

      await authProvider.updateUserData(userId, {
        'settings': {
          'notificationsEnabled': _notificationsEnabled,
          'emailNotificationsEnabled': _emailNotificationsEnabled,
          'locationEnabled': _locationEnabled,
          'biometricEnabled': _biometricEnabled,
          'language': _language,
        },
      });
    } catch (e) {
      // Handle error silently or show snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Settings',
        showLogo: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: ThemeHelper.spacingXL(context)),
        child: Column(
          children: [
            SizedBox(height: ThemeHelper.spacingM(context)),
            // Notifications section
            _buildSectionHeader(context, 'Notifications'),
            _buildSwitchTile(
              context,
              'Push Notifications',
              'Receive notifications about important updates',
              _notificationsEnabled,
                  (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _saveSettings();
              },
            ),
            _buildSwitchTile(
              context,
              'Email Notifications',
              'Receive updates via email',
              _emailNotificationsEnabled,
                  (value) {
                setState(() {
                  _emailNotificationsEnabled = value;
                });
                _saveSettings();
              },
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),
            // Privacy & Security section
            _buildSectionHeader(context, 'Privacy & Security'),
            _buildSwitchTile(
              context,
              'Location Services',
              'Allow app to access your location',
              _locationEnabled,
                  (value) {
                setState(() {
                  _locationEnabled = value;
                });
                _saveSettings();
              },
            ),
            _buildSwitchTile(
              context,
              'Biometric Authentication',
              'Use fingerprint or face ID to unlock',
              _biometricEnabled,
                  (value) {
                setState(() {
                  _biometricEnabled = value;
                });
                _saveSettings();
              },
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),
            // App Preferences section
            _buildSectionHeader(context, 'App Preferences'),
            _buildListTile(
              context,
              'Language',
              _language,
              Icons.language,
                  () {
                _showLanguageDialog(context);
              },
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),
            // About section
            _buildSectionHeader(context, 'About'),
            _buildListTile(
              context,
              'App Version',
              '1.0.0',
              Icons.info,
              null,
            ),
            _buildListTile(
              context,
              'Terms of Service',
              '',
              Icons.description,
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TermsOfServiceScreen(),
                  ),
                );
              },
            ),
            _buildListTile(
              context,
              'Privacy Policy',
              '',
              Icons.privacy_tip,
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),
            // Danger zone
            _buildSectionHeader(context, 'Account'),
            _buildListTile(
              context,
              'Delete Account',
              '',
              Icons.delete_outline,
                  () {
                _deleteAccount(context);
              },
              isDanger: true,
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ThemeHelper.spacingL(context),
        vertical: ThemeHelper.spacingM(context),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: AppTextStyles.heading4(context).copyWith(
            color: AppColors.mediumPurple,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      BuildContext context,
      String title,
      String subtitle,
      bool value,
      Function(bool) onChanged,
      ) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: ThemeHelper.spacingL(context),
        vertical: ThemeHelper.spacingS(context),
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: AppTextStyles.bodyMedium1(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall1(context),
        ),
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.mediumPurple.withValues(alpha: 0.5),
        activeThumbColor: AppColors.mediumPurple,
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      VoidCallback? onTap, {
        bool isDanger = false,
      }) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: ThemeHelper.spacingL(context),
        vertical: ThemeHelper.spacingS(context),
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDanger ? AppColors.dangerColor : AppColors.mediumPurple,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium1(context).copyWith(
            fontWeight: FontWeight.w600,
            color: isDanger ? AppColors.dangerColor : AppColors.primaryText,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
          subtitle,
          style: AppTextStyles.bodySmall1(context),
        )
            : null,
        trailing: onTap != null
            ? Icon(
          Icons.chevron_right,
          color: AppColors.grey,
        )
            : null,
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Language',
          style: AppTextStyles.heading3(context),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('English'),
                  value: 'English',
                  // ignore: deprecated_member_use
                  groupValue: _language,
                  // ignore: deprecated_member_use
                  onChanged: (value) async {
                    if (value != null) {
                      setDialogState(() {
                        _language = value;
                      });
                      setState(() {
                        _language = value;
                      });
                      await _saveSettings();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Urdu'),
                  value: 'Urdu',
                  // ignore: deprecated_member_use
                  groupValue: _language,
                  // ignore: deprecated_member_use
                  onChanged: (value) async {
                    if (value != null) {
                      setDialogState(() {
                        _language = value;
                      });
                      setState(() {
                        _language = value;
                      });
                      await _saveSettings();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _deleteAccount(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Deletion',
          style: AppTextStyles.heading3(context).copyWith(
            color: AppColors.dangerColor,
          ),
        ),
        content: Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
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
            onPressed: () async {
              Navigator.pop(context); // Close confirmation dialog
              
              if (!context.mounted) return;
              
              try {
                // Delete account (this also signs out the user)
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.deleteAccount();
                
                // Clear local user data
                _userService.clearUserData();
                
                // Navigate to signup page (like logout)
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                    AppRouter.signup,
                    (route) => false,
                  );
                  
                  // Show success message after navigation
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account deleted successfully'),
                          backgroundColor: AppColors.successColor,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  });
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete account: ${e.toString().replaceFirst('Exception: ', '')}'),
                      backgroundColor: AppColors.dangerColor,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              }
            },
            child: Text(
              'Delete Forever',
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

