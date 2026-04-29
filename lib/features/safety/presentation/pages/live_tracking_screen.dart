import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../viewmodels/safety_provider.dart';
import '../../domain/entities/sos_alert_entity.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  bool _isTrackingActive = false;
  String? _selectedDuration;
  String? _trackingId;
  Timer? _locationUpdateTimer;
  StreamSubscription? _trackingSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedDuration ??= AppLocalizations.of(context)!.thirtyMin;
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    _trackingSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startTracking() async {
    final provider = Provider.of<SafetyProvider>(context, listen: false);
    
    try {
      // Get trusted contacts
      final trustedContacts = provider.trustedContacts;
      if (trustedContacts.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.addTrustedContactsFirst),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
        return;
      }

      // Get location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.locationServicesDisabled),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.locationPermissionRequired),
                backgroundColor: AppColors.dangerColor,
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.locationPermissionDeniedForever),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
        return;
      }

      // Start tracking
      final viewerIds = trustedContacts.map((c) => c.contactId).toList();
      final trackingId = await provider.startLiveTracking(viewerIds);
      
      if (trackingId != null) {
        setState(() {
          _isTrackingActive = true;
          _trackingId = trackingId;
        });

        // Start location updates
        _startLocationUpdates(trackingId);

        // Listen to tracking updates
        _trackingSubscription = provider.getLiveTrackingStream(trackingId).listen((tracking) {
          if (tracking != null && mounted) {
            setState(() {});
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.trackingStarted),
              backgroundColor: AppColors.successColor,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorStartingTracking(e.toString())),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    }
  }

  void _startLocationUpdates(String trackingId) {
    // Capture provider reference before async timer
    final provider = Provider.of<SafetyProvider>(context, listen: false);
    
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!_isTrackingActive) {
        timer.cancel();
        return;
      }

      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );

        final location = LocationEntity(
          lat: position.latitude,
          lng: position.longitude,
          accuracy: position.accuracy,
          timestamp: DateTime.now(),
        );

        await provider.updateLiveTrackingLocation(trackingId, location);
      } catch (e) {
        // Continue tracking even if one update fails
      }
    });
  }

  Future<void> _stopTracking() async {
    if (_trackingId == null) return;

    final provider = Provider.of<SafetyProvider>(context, listen: false);
    
    try {
      await provider.stopLiveTracking(_trackingId!);
      _locationUpdateTimer?.cancel();
      _trackingSubscription?.cancel();
      
      setState(() {
        _isTrackingActive = false;
        _trackingId = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.trackingStopped),
            backgroundColor: AppColors.grey,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorStoppingTracking(e.toString())),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.liveTracking,
        showLogo: true,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Information Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
                decoration: BoxDecoration(
                  color: AppColors.mediumBluePurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                  border: Border.all(
                    color: AppColors.mediumBluePurple.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: context.responsive(48),
                      color: AppColors.mediumBluePurple,
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    Text(
                      AppLocalizations.of(context)!.shareLocation,
                      style: AppTextStyles.heading3(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ThemeHelper.spacingS(context)),
                    Text(
                      AppLocalizations.of(context)!.shareLocationDesc,
                      style: AppTextStyles.bodyMedium1(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ThemeHelper.spacingXL(context)),

              // Duration Selection
              Text(
                AppLocalizations.of(context)!.trackingDuration,
                style: AppTextStyles.heading4(context),
              ),
              SizedBox(height: ThemeHelper.spacingM(context)),
              _buildDurationOption(context, AppLocalizations.of(context)!.fifteenMin),
              SizedBox(height: ThemeHelper.spacingS(context)),
              _buildDurationOption(context, AppLocalizations.of(context)!.thirtyMin),
              SizedBox(height: ThemeHelper.spacingS(context)),
              _buildDurationOption(context, AppLocalizations.of(context)!.oneHour),
              SizedBox(height: ThemeHelper.spacingS(context)),
              _buildDurationOption(context, AppLocalizations.of(context)!.untilStop),
              SizedBox(height: ThemeHelper.spacingXL(context)),

              // Status Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
                decoration: BoxDecoration(
                  color: _isTrackingActive
                      ? AppColors.successColor.withValues(alpha: 0.1)
                      : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                  border: Border.all(
                    color: _isTrackingActive
                        ? AppColors.successColor
                        : AppColors.grey.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _isTrackingActive
                          ? Icons.location_searching
                          : Icons.location_off,
                      size: context.responsive(48),
                      color: _isTrackingActive
                          ? AppColors.successColor
                          : AppColors.grey,
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    Text(
                      _isTrackingActive
                          ? AppLocalizations.of(context)!.liveTrackingActive
                          : AppLocalizations.of(context)!.trackingNotActive,
                      style: AppTextStyles.heading4(context).copyWith(
                        color: _isTrackingActive
                            ? AppColors.successColor
                            : AppColors.grey,
                      ),
                    ),
                    if (_isTrackingActive) ...[
                      SizedBox(height: ThemeHelper.spacingS(context)),
                      Text(
                        AppLocalizations.of(context)!.locationSharedDesc,
                        style: AppTextStyles.bodySmall1(context),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: ThemeHelper.spacingXL(context)),

              // Action Button
              CustomButton(
                text: _isTrackingActive
                    ? AppLocalizations.of(context)!.stopTracking
                    : AppLocalizations.of(context)!.startLiveTracking,
                icon: _isTrackingActive ? Icons.stop : Icons.play_arrow,
                backgroundColor: _isTrackingActive
                    ? AppColors.dangerColor
                    : AppColors.mediumBluePurple,
                onPressed: _isTrackingActive ? _stopTracking : _startTracking,
              ),
              SizedBox(height: ThemeHelper.spacingL(context)),

              // Trusted Contacts Info
              Container(
                padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                decoration: BoxDecoration(
                  color: AppColors.lightPink.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: context.responsive(20),
                      color: AppColors.mediumPurple,
                    ),
                    SizedBox(width: ThemeHelper.spacingS(context)),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.onlyTrustedContactsView,
                        style: AppTextStyles.bodySmall1(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationOption(BuildContext context, String duration) {
    final isSelected = _selectedDuration == duration;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedDuration = duration;
        });
      },
      borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
      child: Container(
        padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.mediumBluePurple.withValues(alpha: 0.1)
              : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
          border: Border.all(
            color: isSelected
                ? AppColors.mediumBluePurple
                : AppColors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected
                  ? AppColors.mediumBluePurple
                  : AppColors.grey,
              size: context.responsive(24),
            ),
            SizedBox(width: ThemeHelper.spacingM(context)),
            Text(
              duration,
              style: AppTextStyles.bodyMedium1(context).copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppColors.mediumBluePurple
                    : AppColors.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

