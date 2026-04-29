import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/maternity_wing_provider.dart';
import '../../domain/entities/pregnancy_profile.dart';

/// Pregnancy Start Date Dialog
/// Asks user when they got pregnant (LMP or conception date)
class PregnancyStartDialog extends StatefulWidget {
  const PregnancyStartDialog({super.key});

  @override
  State<PregnancyStartDialog> createState() => _PregnancyStartDialogState();
}

class _PregnancyStartDialogState extends State<PregnancyStartDialog> {
  DateTime? selectedDate;
  bool useLMP = true; // Last Menstrual Period vs Conception Date

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MaternityWingProvider>(context, listen: false);
      if (provider.pregnancyProfile != null) {
        setState(() {
          selectedDate = useLMP
              ? provider.pregnancyProfile!.dueDate.subtract(const Duration(days: 280))
              : provider.pregnancyProfile!.conceptionDate;
        });
      }
    });
  }

  DateTime get _dueDate {
    if (selectedDate == null) return DateTime.now().add(const Duration(days: 280));
    if (useLMP) {
      // Due date is typically 40 weeks (280 days) from LMP
      return selectedDate!.add(const Duration(days: 280));
    } else {
      // Due date is 38 weeks (266 days) from conception
      return selectedDate!.add(const Duration(days: 266));
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = Provider.of<MaternityWingProvider>(context, listen: false);

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
                    AppColors.dustyPink,
                    AppColors.softPink,
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
                          'Track Your Pregnancy',
                          style: AppTextStyles.headingSmall(
                            color: AppColors.white,
                          ).copyWith(
                            fontSize: responsive.fontSize(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: responsive.spacingXS),
                        Text(
                          'When did your pregnancy start?',
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
                    // Date Type Selection
                    Text(
                      'Select Date Type',
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
                        Expanded(
                          child: _buildTypeButton(
                            responsive,
                            label: 'Last Period',
                            isSelected: useLMP,
                            onTap: () => setState(() => useLMP = true),
                          ),
                        ),
                        SizedBox(width: responsive.spacingM),
                        Expanded(
                          child: _buildTypeButton(
                            responsive,
                            label: 'Conception',
                            isSelected: !useLMP,
                            onTap: () => setState(() => useLMP = false),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: responsive.spacingXL),

                    // Calendar
                    Text(
                      useLMP ? 'Last Menstrual Period Date' : 'Conception Date',
                      style: AppTextStyles.headingSmall(
                        color: AppColors.primaryDark,
                      ).copyWith(
                        fontSize: responsive.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: responsive.spacingM),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(responsive.radiusL),
                      ),
                      child: CalendarDatePicker(
                        initialDate: selectedDate ?? DateTime.now().subtract(const Duration(days: 30)),
                        firstDate: DateTime.now().subtract(const Duration(days: 280)),
                        lastDate: DateTime.now(),
                        onDateChanged: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: responsive.spacingXL),

                    // Estimated Due Date
                    if (selectedDate != null)
                      Container(
                        padding: responsive.paddingL,
                        decoration: BoxDecoration(
                          color: AppColors.palePink.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(responsive.radiusL),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: AppColors.dustyPink,
                              size: responsive.iconSize(24),
                            ),
                            SizedBox(width: responsive.spacingM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimated Due Date',
                                    style: AppTextStyles.bodySmall(
                                      color: AppColors.primaryDark.withValues(alpha: 0.7),
                                    ).copyWith(
                                      fontSize: responsive.fontSize(12),
                                    ),
                                  ),
                                  Text(
                                    '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                                    style: AppTextStyles.headingSmall(
                                      color: AppColors.primaryDark,
                                    ).copyWith(
                                      fontSize: responsive.fontSize(16),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                              final profile = PregnancyProfile(
                                userId: provider.pregnancyProfile?.userId ?? '',
                                dueDate: _dueDate,
                                conceptionDate: useLMP ? null : selectedDate,
                              );

                            final messenger = ScaffoldMessenger.of(context);
                            final navigator = Navigator.of(context);

                            await provider.savePregnancyProfile(profile);
                            await provider.loadPregnancyProfile(); // Reload to update week

                            if (mounted) {
                              navigator.pop(true); // Return true to indicate save
                              messenger.showSnackBar(
                                SnackBar(
                                  content: const Text('Pregnancy tracking started!'),
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

  Widget _buildTypeButton(
    Responsive responsive, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusL),
        child: Container(
          padding: responsive.paddingM,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.dustyPink
                : AppColors.background,
            borderRadius: BorderRadius.circular(responsive.radiusL),
            border: Border.all(
              color: isSelected
                  ? AppColors.dustyPink
                  : AppColors.lightGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium(
              color: isSelected
                  ? AppColors.white
                  : AppColors.primaryDark,
            ).copyWith(
              fontSize: responsive.fontSize(14),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

