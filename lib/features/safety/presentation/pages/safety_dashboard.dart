import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../widgets/safety_card.dart';
import '../viewmodels/safety_provider.dart';
import 'sos_screen.dart';
import 'live_tracking_screen.dart';
import 'shake_alert_screen.dart';
import 'fake_call_screen.dart';
import 'trusted_contacts_screen.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class SafetyDashboard extends StatefulWidget {
  const SafetyDashboard({super.key});

  @override
  State<SafetyDashboard> createState() => _SafetyDashboardState();
}

class _SafetyDashboardState extends State<SafetyDashboard> {
  @override
  void initState() {
    super.initState();
    // Initialize provider when dashboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SafetyProvider>(context, listen: false);
      provider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SafetyProvider>(
      builder: (context, provider, _) {
        return _buildDashboard(context, provider);
      },
    );
  }

  Widget _buildDashboard(BuildContext context, SafetyProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: l10n.safetyShield,
        showBackButton: false,
        showLogo: true,
      ),
      drawer: const SideDrawer(currentModule: 'safety'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mediumPurple,
                    AppColors.softPink,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mediumPurple.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Shield Icon with Logo inside or beside
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.shield_outlined,
                          size: context.responsive(64),
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ThemeHelper.spacingM(context)),
                  Text(
                    l10n.safetyShieldTitle,
                    style: AppTextStyles.heading2(context).copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ThemeHelper.spacingS(context)),
                  Text(
                    l10n.safetyShieldDesc,
                    style: AppTextStyles.bodyMedium1(context).copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),

            // Quick Actions Section
            Text(
              l10n.quickActions,
              style: AppTextStyles.heading3(context).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: ThemeHelper.spacingM(context)),

            // SOS Card - Most Important
            SafetyCard(
              title: l10n.oneTouchSos,
              description: l10n.oneTouchSosDesc,
              icon: Icons.emergency_rounded,
              iconColor: AppColors.dangerColor,
              cardColor: AppColors.lightPink.withValues(alpha: 0.3),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SosScreen()),
                );
              },
            ),
            SizedBox(height: ThemeHelper.spacingM(context)),

            // Other Safety Features
            SafetyCard(
              title: l10n.liveTracking,
              description: l10n.liveTrackingDesc,
              icon: Icons.location_on_rounded,
              iconColor: AppColors.mediumBluePurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LiveTrackingScreen()),
                );
              },
            ),
            SizedBox(height: ThemeHelper.spacingM(context)),

            SafetyCard(
              title: l10n.shakeToAlert,
              description: l10n.shakeToAlertDesc,
              icon: Icons.vibration_rounded,
              iconColor: AppColors.dustyRose,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShakeAlertScreen()),
                );
              },
            ),
            SizedBox(height: ThemeHelper.spacingM(context)),

            SafetyCard(
              title: l10n.fakeCallGenerator,
              description: l10n.fakeCallDesc,
              icon: Icons.phone_in_talk_rounded,
              iconColor: AppColors.softPink,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FakeCallScreen()),
                );
              },
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),

            // Trusted Contacts Section
            SafetyCard(
              title: l10n.manageTrustedContacts,
              description: l10n.manageTrustedContactsDesc,
              icon: Icons.contacts_rounded,
              iconColor: AppColors.mediumPurple,
              cardColor: AppColors.mediumPurple.withValues(alpha: 0.1),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TrustedContactsScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),

            // Demonstration / Fallback Section
            Container(
              padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                border: Border.all(color: AppColors.mediumPurple.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.mediumPurple),
                      SizedBox(width: ThemeHelper.spacingS(context)),
                      Expanded(
                        child: Text(
                          'iOS Notification Fallback',
                          style: AppTextStyles.bodyMedium1(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.mediumPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ThemeHelper.spacingS(context)),
                  Text(
                    'Since push notifications require an Apple Developer Account, this app uses a Global Firestore Listener to deliver high-priority SOS alerts instantly when the app is open (Foreground).',
                    style: AppTextStyles.bodySmall1(context),
                  ),
                  SizedBox(height: ThemeHelper.spacingM(context)),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        provider.triggerTestSosLocally();
                      },
                      icon: const Icon(Icons.emergency_share, size: 18),
                      label: const Text('TEST SOS IN-APP ALERT'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.dangerColor,
                        side: BorderSide(color: AppColors.dangerColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ThemeHelper.spacingL(context)),
          ],
        ),
      ),
    );
  }
}

