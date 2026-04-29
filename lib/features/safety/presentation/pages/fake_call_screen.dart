import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../viewmodels/safety_provider.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class FakeCallScreen extends StatefulWidget {
  const FakeCallScreen({super.key});

  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  bool _isCallActive = false;
  Timer? _callTimer;
  int _callDuration = 0;
  String _selectedCaller = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedCaller.isEmpty) {
      _selectedCaller = AppLocalizations.of(context)!.mom;
    }
  }

  List<String> _getLocalizedCallers() {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.mom,
      l10n.dad,
      l10n.bestFriend,
      l10n.boss,
      l10n.emergencyContact,
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SafetyProvider>(context, listen: false);
      provider.initialize();
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  void _startFakeCall() {
    if (_isCallActive) return;

    setState(() {
      _isCallActive = true;
      _callDuration = 0;
    });

    // Log fake call to Firebase
    final provider = Provider.of<SafetyProvider>(context, listen: false);
    provider.logFakeCall(
      contactName: _selectedCaller,
      contactNumber: null,
      scheduledTime: DateTime.now(),
    );

    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });
  }

  void _endFakeCall() {
    _callTimer?.cancel();
    
    // Update fake call duration in Firebase
    final provider = Provider.of<SafetyProvider>(context, listen: false);
    provider.logFakeCall(
      contactName: _selectedCaller,
      contactNumber: null,
      scheduledTime: DateTime.now().subtract(Duration(seconds: _callDuration)),
      duration: _callDuration,
    );
    
    setState(() {
      _isCallActive = false;
      _callDuration = 0;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.fakeCallGenerator,
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
                  color: AppColors.softPink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                  border: Border.all(
                    color: AppColors.softPink.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.phone_in_talk,
                      size: context.responsive(48),
                      color: AppColors.softPink,
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    Text(
                      AppLocalizations.of(context)!.exitUncomfortableSituations,
                      style: AppTextStyles.heading3(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ThemeHelper.spacingS(context)),
                    Text(
                      AppLocalizations.of(context)!.fakeCallDesc,
                      style: AppTextStyles.bodyMedium1(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ThemeHelper.spacingXL(context)),

              // Caller Selection
              Text(
                AppLocalizations.of(context)!.selectCaller,
                style: AppTextStyles.heading4(context),
              ),
              SizedBox(height: ThemeHelper.spacingM(context)),
              Container(
                padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                ),
                child: DropdownButton<String>(
                  value: _selectedCaller,
                  isExpanded: true,
                  underline: SizedBox(),
                  items: _getLocalizedCallers().map((String caller) {
                    return DropdownMenuItem<String>(
                      value: caller,
                      child: Text(
                        caller,
                        style: AppTextStyles.bodyMedium1(context),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCaller = newValue;
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: ThemeHelper.spacingXL(context)),

              // Fake Call Interface
              if (_isCallActive)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.softPink,
                        AppColors.lightPink,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(ThemeHelper.radiusXL),
                    boxShadow: ThemeHelper.elevatedShadow,
                  ),
                  child: Column(
                    children: [
                      // Caller Avatar
                      Container(
                        width: context.responsive(120),
                        height: context.responsive(120),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          boxShadow: ThemeHelper.cardShadow,
                        ),
                        child: Icon(
                          Icons.person,
                          size: context.responsive(64),
                          color: AppColors.softPink,
                        ),
                      ),
                      SizedBox(height: ThemeHelper.spacingL(context)),
                      Text(
                        _selectedCaller,
                        style: AppTextStyles.heading2(context).copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: ThemeHelper.spacingS(context)),
                      Text(
                        AppLocalizations.of(context)!.incomingCall,
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      SizedBox(height: ThemeHelper.spacingM(context)),
                      Text(
                        _formatDuration(_callDuration),
                        style: AppTextStyles.heading3(context).copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: ThemeHelper.spacingXL(context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCallButton(
                            context,
                            Icons.call_end,
                            AppLocalizations.of(context)!.end,
                            AppColors.dangerColor,
                            _endFakeCall,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(ThemeHelper.radiusXL),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.phone,
                        size: context.responsive(80),
                        color: AppColors.grey,
                      ),
                      SizedBox(height: ThemeHelper.spacingL(context)),
                      Text(
                        AppLocalizations.of(context)!.readyToGenerateCall,
                        style: AppTextStyles.heading4(context),
                      ),
                      SizedBox(height: ThemeHelper.spacingS(context)),
                      Text(
                        AppLocalizations.of(context)!.tapToStartFakeCall,
                        style: AppTextStyles.bodySmall1(context),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              SizedBox(height: ThemeHelper.spacingXL(context)),

              // Action Button
              CustomButton(
                text: _isCallActive
                    ? AppLocalizations.of(context)!.endCall
                    : AppLocalizations.of(context)!.generateFakeCall,
                icon: _isCallActive ? Icons.call_end : Icons.phone,
                backgroundColor: _isCallActive
                    ? AppColors.dangerColor
                    : AppColors.softPink,
                onPressed: _isCallActive ? _endFakeCall : _startFakeCall,
              ),
              SizedBox(height: ThemeHelper.spacingL(context)),

              // Tips
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
                          Icons.lightbulb_outline,
                          size: context.responsive(20),
                          color: AppColors.mediumPurple,
                        ),
                        SizedBox(width: ThemeHelper.spacingS(context)),
                        Text(
                          AppLocalizations.of(context)!.tips,
                          style: AppTextStyles.label(context),
                        ),
                      ],
                    ),
                    SizedBox(height: ThemeHelper.spacingS(context)),
                    Text(
                      '• ${AppLocalizations.of(context)!.tipAnswerNaturally}\n'
                          '• ${AppLocalizations.of(context)!.tipRealisticScreen}\n'
                          '• ${AppLocalizations.of(context)!.tipEndAnytime}',
                      style: AppTextStyles.bodySmall1(context),
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

  Widget _buildCallButton(
      BuildContext context,
      IconData icon,
      String label,
      Color color,
      VoidCallback onPressed,
      ) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(ThemeHelper.radiusCircular),
          child: Container(
            width: context.responsive(64),
            height: context.responsive(64),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: ThemeHelper.cardShadow,
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: context.responsive(32),
            ),
          ),
        ),
        SizedBox(height: ThemeHelper.spacingS(context)),
        Text(
          label,
          style: AppTextStyles.bodySmall1(context).copyWith(
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}

