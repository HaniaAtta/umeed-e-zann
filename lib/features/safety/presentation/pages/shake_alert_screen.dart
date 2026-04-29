import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../viewmodels/safety_provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/sos_alert_entity.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class ShakeAlertScreen extends StatefulWidget {
  const ShakeAlertScreen({super.key});

  @override
  State<ShakeAlertScreen> createState() => _ShakeAlertScreenState();
}

class _ShakeAlertScreenState extends State<ShakeAlertScreen> {
  bool _isShakeAlertEnabled = false;
  int _sensitivity = 3; // 1-5 scale
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  static const int _shakeCooldownSeconds = 3; // Prevent multiple alerts in quick succession
  double _lastX = 0, _lastY = 0, _lastZ = 0;
  int _shakeCount = 0;
  DateTime? _lastShakeDetection;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final provider = Provider.of<SafetyProvider>(context, listen: false);
    await provider.loadShakeAlertSettings();
    final settings = provider.shakeAlertSettings;
    if (settings != null && mounted) {
      setState(() {
        _isShakeAlertEnabled = settings.enabled;
        _sensitivity = settings.sensitivity;
      });
      
      // Start shake detection if enabled
      if (_isShakeAlertEnabled) {
        _startShakeDetection();
      }
    }
  }

  Future<void> _saveSettings() async {
    final provider = Provider.of<SafetyProvider>(context, listen: false);
    await provider.saveShakeAlertSettings(
      enabled: _isShakeAlertEnabled,
      sensitivity: _sensitivity,
    );
    if (mounted && provider.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isShakeAlertEnabled
              ? AppLocalizations.of(context)!.shakeAlertEnabledSnack
              : AppLocalizations.of(context)!.shakeAlertDisabledSnack),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Start or stop shake detection based on setting
      if (_isShakeAlertEnabled) {
        _startShakeDetection();
      } else {
        _stopShakeDetection();
      }
    }
  }

  /// Start listening to accelerometer for shake detection
  void _startShakeDetection() {
    _stopShakeDetection(); // Cancel any existing subscription
    
    if (!_isShakeAlertEnabled) return;
    
    // Sensitivity threshold: lower number = more sensitive (needs less force)
    // Sensitivity 1 = 10.0 (High force needed)
    // Sensitivity 3 = 6.0 (Moderate)
    // Sensitivity 5 = 2.0 (Very sensitive)
    final threshold = 12.0 - (_sensitivity * 2.0);
    debugPrint('Starting shake detection with sensitivity $_sensitivity (threshold: $threshold)');
    
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (!_isShakeAlertEnabled) return;
      
      // Calculate acceleration difference
      final double acceleration = sqrt(
        pow(event.x - _lastX, 2) +
        pow(event.y - _lastY, 2) +
        pow(event.z - _lastZ, 2)
      );
      
      _lastX = event.x;
      _lastY = event.y;
      _lastZ = event.z;
      
      // Check if acceleration exceeds threshold
      if (acceleration > threshold) {
        final now = DateTime.now();
        
        // Reset shake count if too much time has passed
        if (_lastShakeDetection == null || 
            now.difference(_lastShakeDetection!).inSeconds > 1) {
          _shakeCount = 0;
        }
        
        _shakeCount++;
        _lastShakeDetection = now;
        
        // Trigger alert if shake count reaches threshold (2-3 shakes)
        if (_shakeCount >= 2) {
          _handleShakeDetected();
          _shakeCount = 0;
        }
      }
    });
  }

  /// Stop shake detection
  void _stopShakeDetection() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _shakeCount = 0;
    _lastShakeDetection = null;
  }

  /// Handle shake detected - trigger SOS alert
  Future<void> _handleShakeDetected() async {
    // Prevent multiple alerts in quick succession
    final now = DateTime.now();
    if (_lastShakeTime != null && 
        now.difference(_lastShakeTime!).inSeconds < _shakeCooldownSeconds) {
      return; // Too soon, ignore
    }
    
    _lastShakeTime = now;
    await _triggerShakeAlert();
  }

  Future<void> _triggerShakeAlert() async {
    final provider = Provider.of<SafetyProvider>(context, listen: false);
    
    try {
      // Get current location
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
 
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
 
      Position position = await Geolocator.getCurrentPosition(
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

      final message = l10n?.sosTriggeredByShake ?? 'SOS Triggered by Shake';
      final alertId = await provider.createSosAlert(
        location: location,
        message: message,
      );

      if (mounted) {
        if (alertId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n?.sosAlertSentShort ?? 'SOS Alert Sent'),
              backgroundColor: AppColors.successColor,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (provider.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${provider.error}'),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorSendingSosAlert(e.toString())),
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
        title: AppLocalizations.of(context)!.shakeToAlert,
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
                  color: AppColors.dustyRose.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                  border: Border.all(
                    color: AppColors.dustyRose.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.vibration,
                      size: context.responsive(48),
                      color: AppColors.dustyRose,
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    Text(
                      AppLocalizations.of(context)!.discreetSosActivation,
                      style: AppTextStyles.heading3(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ThemeHelper.spacingS(context)),
                    Text(
                      AppLocalizations.of(context)!.discreetSosDesc,
                      style: AppTextStyles.bodyMedium1(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ThemeHelper.spacingXL(context)),

              // Enable/Disable Toggle
              Container(
                padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.shakeToAlert,
                            style: AppTextStyles.heading4(context),
                          ),
                          SizedBox(height: ThemeHelper.spacingXS(context)),
                          Text(
                            _isShakeAlertEnabled
                                ? AppLocalizations.of(context)!.shakeAlertEnabledMsg
                                : AppLocalizations.of(context)!.shakeAlertDisabledMsg,
                            style: AppTextStyles.bodySmall1(context),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isShakeAlertEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isShakeAlertEnabled = value;
                        });
                        _saveSettings();
                      },
                      activeThumbColor: AppColors.dustyRose,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ThemeHelper.spacingXL(context)),

              // Sensitivity Settings
              if (_isShakeAlertEnabled) ...[
                Text(
                  AppLocalizations.of(context)!.sensitivity,
                  style: AppTextStyles.heading4(context),
                ),
                SizedBox(height: ThemeHelper.spacingM(context)),
                Text(
                  AppLocalizations.of(context)!.adjustSensitivityDesc,
                  style: AppTextStyles.bodySmall1(context),
                ),
                SizedBox(height: ThemeHelper.spacingM(context)),
                Container(
                  padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                    boxShadow: ThemeHelper.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.low,
                            style: AppTextStyles.bodySmall1(context),
                          ),
                          Text(
                            AppLocalizations.of(context)!.high,
                            style: AppTextStyles.bodySmall1(context),
                          ),
                        ],
                      ),
                      Slider(
                        value: _sensitivity.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: _getSensitivityLabel(_sensitivity),
                        activeColor: AppColors.dustyRose,
                        onChanged: (value) {
                          setState(() {
                            _sensitivity = value.toInt();
                          });
                          if (_isShakeAlertEnabled) {
                            _saveSettings();
                          }
                        },
                      ),
                      Text(
                        _getSensitivityLabel(_sensitivity),
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.dustyRose,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ThemeHelper.spacingXL(context)),
              ],

              // Test Shake
              if (_isShakeAlertEnabled)
                CustomButton(
                  text: AppLocalizations.of(context)!.testShakeDetection,
                  icon: Icons.science,
                  backgroundColor: AppColors.dustyRose,
                  onPressed: () {
                    _triggerShakeAlert();
                  },
                ),
              SizedBox(height: ThemeHelper.spacingL(context)),

              // Instructions
              Container(
                padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                decoration: BoxDecoration(
                  color: AppColors.lightPink.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: context.responsive(20),
                          color: AppColors.mediumPurple,
                        ),
                        SizedBox(width: ThemeHelper.spacingS(context)),
                        Text(
                          AppLocalizations.of(context)!.howItWorks,
                          style: AppTextStyles.label(context),
                        ),
                      ],
                    ),
                    SizedBox(height: ThemeHelper.spacingS(context)),
                    _buildInstructionItem(
                      context,
                      '1',
                      AppLocalizations.of(context)!.enableShakeAlert,
                    ),
                    _buildInstructionItem(
                      context,
                      '2',
                      AppLocalizations.of(context)!.shakePhoneHelp,
                    ),
                    _buildInstructionItem(
                      context,
                      '3',
                      AppLocalizations.of(context)!.sosAlertSentAuto,
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

  String _getSensitivityLabel(int sensitivity) {
    final l10n = AppLocalizations.of(context)!;
    switch (sensitivity) {
      case 1:
        return l10n.veryLow;
      case 2:
        return l10n.low;
      case 3:
        return l10n.medium;
      case 4:
        return l10n.high;
      case 5:
        return l10n.veryHigh;
      default:
        return l10n.medium;
    }
  }

  Widget _buildInstructionItem(
      BuildContext context,
      String number,
      String text,
      ) {
    return Padding(
      padding: EdgeInsets.only(top: ThemeHelper.spacingS(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.responsive(24),
            height: context.responsive(24),
            decoration: BoxDecoration(
              color: AppColors.mediumPurple,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.bodySmall1(context).copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: ThemeHelper.spacingS(context)),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall1(context),
            ),
          ),
        ],
      ),
    );
  }
}

