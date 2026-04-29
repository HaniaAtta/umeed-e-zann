import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../viewmodels/safety_provider.dart';
import '../../domain/entities/sos_alert_entity.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with TickerProviderStateMixin {
  bool _isSosActive = false;
  Timer? _countdownTimer;
  int _countdown = 5;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Initialize provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SafetyProvider>(context, listen: false);
      provider.initialize();
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _startSos() {
    if (_isSosActive) return;

    setState(() {
      _isSosActive = true;
      _countdown = 5;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        _triggerSos();
      }
    });
  }

  void _cancelSos() {
    _countdownTimer?.cancel();
    setState(() {
      _isSosActive = false;
      _countdown = 5;
    });
  }

  Future<void> _triggerSos() async {
    final provider = Provider.of<SafetyProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    try {
      // Get current location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.locationServicesDisabled),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
        setState(() {
          _isSosActive = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.locationPermissionsRequired),
                backgroundColor: AppColors.dangerColor,
              ),
            );
          }
          setState(() {
            _isSosActive = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.locationPermissionsDeniedForever),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
        setState(() {
          _isSosActive = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Create SOS alert
      final location = LocationEntity(
        lat: position.latitude,
        lng: position.longitude,
        accuracy: position.accuracy,
        timestamp: DateTime.now(),
      );

      final alertId = await provider.createSosAlert(
        location: location,
        message: l10n.sosAlertMessageContent,
      );

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        if (alertId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.sosAlertSent),
              backgroundColor: AppColors.successColor,
              duration: Duration(seconds: 3),
            ),
          );
        } else if (provider.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.error}: ${provider.error}'),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
      }
      
      setState(() {
        _isSosActive = false;
      });
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorSendingSos}: $e'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
      setState(() {
        _isSosActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: l10n.oneTouchSos,
        showLogo: true,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
          child: Column(
            children: [
              // Information Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dangerColor.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.dangerColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                      decoration: BoxDecoration(
                        color: AppColors.dangerColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: context.responsive(32),
                        color: AppColors.dangerColor,
                      ),
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    Text(
                      l10n.sosActivationInfo,
                      style: AppTextStyles.heading4(context).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    _buildInfoItem(
                      context,
                      Icons.location_on_rounded,
                      l10n.liveLocationShared,
                    ),
                    SizedBox(height: ThemeHelper.spacingS(context)),
                    _buildInfoItem(
                      context,
                      Icons.mic_rounded,
                      l10n.audioRecordingStarted,
                    ),
                    SizedBox(height: ThemeHelper.spacingS(context)),
                    _buildInfoItem(
                      context,
                      Icons.message_rounded,
                      l10n.helpMessageSent,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ThemeHelper.spacingXL(context)),

              // SOS Button
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isSosActive ? _pulseAnimation.value : 1.0,
                    child: GestureDetector(
                      onTap: _isSosActive ? _cancelSos : _startSos,
                      child: Container(
                        width: context.responsive(200),
                        height: context.responsive(200),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isSosActive
                              ? AppColors.dangerColor
                              : AppColors.mediumPurple,
                          boxShadow: [
                            BoxShadow(
                              color: (_isSosActive
                                  ? AppColors.dangerColor
                                  : AppColors.mediumPurple)
                                  .withValues(alpha: 0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isSosActive
                                    ? Icons.close_rounded
                                    : Icons.emergency_rounded,
                                size: context.responsive(64),
                                color: AppColors.white,
                              ),
                              SizedBox(height: ThemeHelper.spacingS(context)),
                              Text(
                                _isSosActive
                                    ? l10n.cancel.toUpperCase()
                                    : l10n.sos,
                                style: AppTextStyles.heading2(context).copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                              ),
                              if (_isSosActive) ...[
                                SizedBox(height: ThemeHelper.spacingS(context)),
                                Text(
                                  '$_countdown',
                                  style: AppTextStyles.heading1(context).copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: ThemeHelper.spacingXL(context)),

              // Status Text
              Text(
                _isSosActive
                    ? l10n.sosCountdownText(_countdown)
                    : l10n.tapToActivateSos,
                style: AppTextStyles.bodyMedium1(context).copyWith(
                  color: _isSosActive ? AppColors.dangerColor : AppColors.secondaryText,
                  fontWeight: _isSosActive ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ThemeHelper.spacingXL(context)),

              // Quick Actions
              Text(
                l10n.quickActions,
                style: AppTextStyles.heading4(context).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: ThemeHelper.spacingM(context)),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      l10n.testAlert,
                      Icons.notifications_active_rounded,
                          () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.testAlertSent),
                            duration: Duration(seconds: 2),
                            backgroundColor: AppColors.mediumPurple,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: ThemeHelper.spacingM(context)),
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      l10n.shareLocation,
                      Icons.share_location_rounded,
                          () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.locationShared),
                            duration: Duration(seconds: 2),
                            backgroundColor: AppColors.mediumPurple,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context,
      IconData icon,
      String text,
      ) {
    return Row(
      children: [
        Icon(icon, size: context.responsive(20), color: AppColors.dangerColor),
        SizedBox(width: ThemeHelper.spacingS(context)),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall1(context),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
      child: Container(
        padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
        ),
        child: Column(
          children: [
            Icon(icon, size: context.responsive(32), color: AppColors.mediumPurple),
            SizedBox(height: ThemeHelper.spacingS(context)),
            Text(
              title,
              style: AppTextStyles.bodySmall1(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

