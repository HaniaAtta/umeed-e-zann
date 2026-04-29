import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../providers/cycle_tracker_provider.dart';
import '../widgets/cycle_phase_dial.dart';
import '../widgets/cycle_sync_card.dart';
import '../widgets/dr_ai_diagnosis_card.dart';
import '../widgets/symptom_logger.dart';
import '../widgets/period_start_dialog.dart';
import '../../domain/entities/cycle_phase.dart';

/// Detailed Cycle Tracker Screen
/// Scrollable screen with cycle information, symptom logging, and health insights
/// Soft, feminine, medical-grade but friendly design
class CycleTrackerScreen extends StatefulWidget {
  const CycleTrackerScreen({super.key});

  @override
  State<CycleTrackerScreen> createState() => _CycleTrackerScreenState();
}

class _CycleTrackerScreenState extends State<CycleTrackerScreen> {
  @override
  void initState() {
    super.initState();
    // Load cycle data from Firebase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CycleTrackerProvider>(context, listen: false);
      provider.loadCycleProfile();
      final now = DateTime.now();
      provider.loadCycleLogs(
        startDate: DateTime(now.year, now.month - 1, 1),
        endDate: DateTime(now.year, now.month + 1, 0),
      );
      
      // Show period start dialog if profile doesn't exist
      if (provider.cycleProfile?.lastPeriodDate == null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const PeriodStartDialog(),
            ).then((_) {
              // Reload profile after dialog closes
              provider.loadCycleProfile();
              if (mounted) setState(() {});
            });
          }
        });
      }
    });
  }
  
  // Helper methods to get data from provider
  CyclePhase? get _currentPhase {
    final provider = Provider.of<CycleTrackerProvider>(context, listen: true);
    return provider.getCurrentPhase();
  }

  int get _currentCycleDay {
    final profile = Provider.of<CycleTrackerProvider>(context, listen: true).cycleProfile;
    if (profile?.lastPeriodDate == null) return 1;
    final lastPeriod = profile!.lastPeriodDate!;
    final cycleLength = profile.averageCycleLength; // Has default value of 28, not nullable
    final daysSince = DateTime.now().difference(lastPeriod).inDays;
    return (daysSince % cycleLength) + 1;
  }

  double get _cycleProgress {
    final profile = Provider.of<CycleTrackerProvider>(context, listen: true).cycleProfile;
    final cycleLength = profile?.averageCycleLength ?? 28;
    return _currentCycleDay / cycleLength;
  }

  Color get _phaseColor {
    final phase = _currentPhase;
    if (phase == null) return AppColors.softPink;
    switch (phase) {
      case CyclePhase.menstruation:
        return AppColors.dustyPink;
      case CyclePhase.follicular:
        return AppColors.softPink;
      case CyclePhase.ovulation:
        return AppColors.palePink;
      case CyclePhase.luteal:
        return AppColors.secondaryPurple;
    }
  }

  String get _foodTip {
    final provider = Provider.of<CycleTrackerProvider>(context, listen: false);
    final recommendations = provider.getPhaseRecommendations();
    if (recommendations == null || recommendations.dietTips.isEmpty) {
      return 'Maintain a balanced diet with plenty of fruits and vegetables.';
    }
    return recommendations.dietTips.first;
  }

  String get _habitTip {
    final provider = Provider.of<CycleTrackerProvider>(context, listen: false);
    final recommendations = provider.getPhaseRecommendations();
    if (recommendations == null || recommendations.exerciseTips.isEmpty) {
      return 'Listen to your body and adjust activities accordingly.';
    }
    return recommendations.exerciseTips.first;
  }


  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = Provider.of<CycleTrackerProvider>(context, listen: true);
    final phase = _currentPhase;
    final phaseName = phase?.displayName ?? 'Not Set';
    
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'wellness'),
      appBar: const CustomAppBar(
        title: 'Cycle Tracker',
        showLogo: true,
        showBackButton: true,
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: responsive.screenPadding.copyWith(
                top: responsive.spacingXL,
                bottom: responsive.spacingXXL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Cycle Phase Dial
                  CyclePhaseDial(
                    currentDay: _currentCycleDay,
                    phase: phaseName,
                    phaseColor: _phaseColor,
                    progress: _cycleProgress,
                  ),
                  
                  SizedBox(height: responsive.spacingXL),
                  
                  // 2. Symptom Logger - Right under the dial
                  const SymptomLogger(),
                  
                  // 3. Cycle Sync Card
                  CycleSyncCard(
                    phase: phaseName,
                    foodTip: _foodTip,
                    habitTip: _habitTip,
                  ),
                  
                  // 4. Doctorbot Card
                  const DrAiDiagnosisCard(),
                ],
              ),
            ),
    );
  }
}
