import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/telehealth_provider.dart';
import '../../domain/entities/doctor.dart';


/// Doctor Booking Dialog
/// Allows users to book appointments with doctors
class DoctorBookingDialog extends StatefulWidget {
  final Doctor doctor;

  const DoctorBookingDialog({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorBookingDialog> createState() => _DoctorBookingDialogState();
}

class _DoctorBookingDialogState extends State<DoctorBookingDialog> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
  String selectedType = 'chat'; // 'chat' or 'video'

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = Provider.of<TeleHealthProvider>(context, listen: false);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: responsive.screenPadding,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                    AppColors.secondaryPurple,
                    AppColors.accentPurple,
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
                          'Book Appointment',
                          style: AppTextStyles.headingSmall(
                            color: AppColors.white,
                          ).copyWith(
                            fontSize: responsive.fontSize(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: responsive.spacingXS),
                        Text(
                          widget.doctor.name,
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
                    // Appointment Type Selection
                    Text(
                      'Appointment Type',
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
                        if (widget.doctor.isChatAvailable)
                          Expanded(
                            child: _buildTypeButton(
                              responsive,
                              label: 'Chat',
                              icon: Icons.chat_bubble_rounded,
                              isSelected: selectedType == 'chat',
                              onTap: () => setState(() => selectedType = 'chat'),
                            ),
                          ),
                        if (widget.doctor.isChatAvailable &&
                            widget.doctor.isVideoAvailable)
                          SizedBox(width: responsive.spacingM),
                        if (widget.doctor.isVideoAvailable)
                          Expanded(
                            child: _buildTypeButton(
                              responsive,
                              label: 'Video Call',
                              icon: Icons.videocam_rounded,
                              isSelected: selectedType == 'video',
                              onTap: () => setState(() => selectedType = 'video'),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: responsive.spacingXXL),

                    // Date Selection
                    Text(
                      'Select Date',
                      style: AppTextStyles.headingSmall(
                        color: AppColors.primaryDark,
                      ).copyWith(
                        fontSize: responsive.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: responsive.spacingM),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today, size: responsive.iconSize(18)),
                      label: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.primaryDark,
                        ).copyWith(
                          fontSize: responsive.fontSize(14),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: responsive.paddingM,
                        side: BorderSide(color: AppColors.secondaryPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(responsive.radiusL),
                        ),
                      ),
                    ),

                    SizedBox(height: responsive.spacingL),

                    // Time Selection
                    Text(
                      'Select Time',
                      style: AppTextStyles.headingSmall(
                        color: AppColors.primaryDark,
                      ).copyWith(
                        fontSize: responsive.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: responsive.spacingM),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (time != null) {
                          setState(() {
                            selectedTime = time;
                          });
                        }
                      },
                      icon: Icon(Icons.access_time, size: responsive.iconSize(18)),
                      label: Text(
                        selectedTime.format(context),
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.primaryDark,
                        ).copyWith(
                          fontSize: responsive.fontSize(14),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: responsive.paddingM,
                        side: BorderSide(color: AppColors.secondaryPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(responsive.radiusL),
                        ),
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
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              final appointmentDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );

                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);
                              
                              try {
                                await provider.bookAppointment(
                                  widget.doctor.id,
                                  appointmentDateTime,
                                  selectedType,
                                );
                                
                                // Reload appointments
                                await provider.loadUserAppointments();

                                if (!mounted) return;

                                final error = provider.error;
                                navigator.pop();
                                
                                if (!mounted) return;

                                if (error != null) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(error),
                                      backgroundColor: AppColors.dangerColor,
                                    ),
                                  );
                                } else {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: const Text('Appointment booked successfully!'),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: AppColors.successColor,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error booking appointment: ${e.toString()}',
                                      ),
                                      backgroundColor: AppColors.dangerColor,
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                }
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
                      child: provider.isLoading
                          ? SizedBox(
                              height: responsive.size(20),
                              width: responsive.size(20),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Book Appointment',
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
    required IconData icon,
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
                ? AppColors.secondaryPurple
                : AppColors.background,
            borderRadius: BorderRadius.circular(responsive.radiusL),
            border: Border.all(
              color: isSelected
                  ? AppColors.secondaryPurple
                  : AppColors.lightGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.secondaryPurple,
                size: responsive.iconSize(20),
              ),
              SizedBox(width: responsive.spacingS),
              Text(
                label,
                style: AppTextStyles.bodyMedium(
                  color: isSelected
                      ? AppColors.white
                      : AppColors.primaryDark,
                ).copyWith(
                  fontSize: responsive.fontSize(14),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

