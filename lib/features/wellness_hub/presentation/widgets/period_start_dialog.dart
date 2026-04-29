import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/cycle_tracker_provider.dart';
import '../../domain/entities/user_cycle_profile.dart';

/// Period Start Date Dialog
/// Asks user to select the first day of their last period
class PeriodStartDialog extends StatefulWidget {
  const PeriodStartDialog({super.key});

  @override
  State<PeriodStartDialog> createState() => _PeriodStartDialogState();
}

class _PeriodStartDialogState extends State<PeriodStartDialog> {
  DateTime? selectedDate;
  int cycleLength = 28;

  @override
  void initState() {
    super.initState();
    // Load existing profile if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CycleTrackerProvider>(context, listen: false);
      if (provider.cycleProfile?.lastPeriodDate != null) {
        setState(() {
          selectedDate = provider.cycleProfile!.lastPeriodDate;
          cycleLength = provider.cycleProfile!.averageCycleLength;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = Provider.of<CycleTrackerProvider>(context, listen: false);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: responsive.screenPadding,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(responsive.radiusXXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.2),
              blurRadius: responsive.spacingXL,
              offset: Offset(0, responsive.spacingL),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: responsive.paddingXL,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.softPink,
                    AppColors.palePink,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(responsive.radiusXXL),
                  topRight: Radius.circular(responsive.radiusXXL),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Track Your Cycle',
                          style: AppTextStyles.headingSmall(
                            color: AppColors.white,
                          ).copyWith(
                            fontSize: responsive.fontSize(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: responsive.spacingXS),
                        Text(
                          'When did your last period start?',
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ).copyWith(
                            fontSize: responsive.fontSize(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.white,
                      size: responsive.iconSize(24),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: responsive.paddingXL,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(responsive.radiusL),
                      ),
                      child: CalendarDatePicker(
                        initialDate: selectedDate ?? DateTime.now().subtract(const Duration(days: 5)),
                        firstDate: DateTime.now().subtract(const Duration(days: 60)),
                        lastDate: DateTime.now(),
                        onDateChanged: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: responsive.spacingXL),

                    // Cycle Length
                    Text(
                      'Average Cycle Length (days)',
                      style: AppTextStyles.headingSmall(
                        color: AppColors.primaryDark,
                      ).copyWith(
                        fontSize: responsive.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: responsive.spacingM),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            if (cycleLength > 21) {
                              setState(() {
                                cycleLength--;
                              });
                            }
                          },
                          color: AppColors.secondaryPurple,
                        ),
                        Expanded(
                          child: Container(
                            padding: responsive.paddingM,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(responsive.radiusM),
                            ),
                            child: Text(
                              '$cycleLength days',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.headingSmall(
                                color: AppColors.primaryDark,
                              ).copyWith(
                                fontSize: responsive.fontSize(18),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            if (cycleLength < 35) {
                              setState(() {
                                cycleLength++;
                              });
                            }
                          },
                          color: AppColors.secondaryPurple,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer Actions
            Container(
              padding: responsive.paddingXL,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(responsive.radiusXXL),
                  bottomRight: Radius.circular(responsive.radiusXXL),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.spacingM,
                        ),
                        side: BorderSide(color: AppColors.secondaryPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(responsive.radiusL),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.secondaryPurple,
                        ).copyWith(
                          fontSize: responsive.fontSize(14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.spacingM),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: selectedDate == null
                          ? null
                          : () async {
                              final profile = UserCycleProfile(
                                userId: provider.cycleProfile?.userId ?? '',
                                lastPeriodDate: selectedDate!,
                                averageCycleLength: cycleLength,
                              );

                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);

                              await provider.saveCycleProfile(profile);
                              await provider.loadCycleProfile(); // Reload to update phase

                              if (mounted) {
                                navigator.pop(true); // Return true to indicate save
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: const Text('Cycle tracking started!'),
                                    backgroundColor: AppColors.successColor,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryPurple,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.spacingM,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(responsive.radiusL),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Save',
                        style: AppTextStyles.buttonText(
                          color: AppColors.white,
                        ).copyWith(
                          fontSize: responsive.fontSize(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

