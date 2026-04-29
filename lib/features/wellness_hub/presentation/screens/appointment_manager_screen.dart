import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../providers/maternity_wing_provider.dart';
import '../../domain/entities/appointment.dart';

/// Appointment Manager Screen
/// Allows users to Add/Edit/Delete prenatal checkups
class AppointmentManagerScreen extends StatefulWidget {
  const AppointmentManagerScreen({super.key});

  @override
  State<AppointmentManagerScreen> createState() => _AppointmentManagerScreenState();
}

class _AppointmentManagerScreenState extends State<AppointmentManagerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MaternityWingProvider>(context, listen: false);
      provider.loadAppointments();
    });
  }

  void _showAddEditDialog({Appointment? appointment}) {
    final provider = Provider.of<MaternityWingProvider>(context, listen: false);
    final responsive = Responsive(context);
    
    final doctorNameController = TextEditingController(
      text: appointment?.doctorName ?? '',
    );
    final typeController = TextEditingController(
      text: appointment?.type ?? 'Checkup',
    );
    final notesController = TextEditingController(
      text: appointment?.notes ?? '',
    );
    DateTime selectedDate = appointment?.date ?? DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(appointment?.date ?? DateTime.now());

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.radiusXL),
          ),
          title: Text(
            appointment == null ? 'Add Appointment' : 'Edit Appointment',
            style: AppTextStyles.headingSmall(
              color: AppColors.primaryDark,
            ).copyWith(
              fontSize: responsive.fontSize(20),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: doctorNameController,
                  decoration: InputDecoration(
                    labelText: 'Doctor Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(responsive.radiusM),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
                SizedBox(height: responsive.spacingM),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    labelText: 'Appointment Type',
                    hintText: 'e.g., Checkup, Ultrasound, Lab Test',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(responsive.radiusM),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
                SizedBox(height: responsive.spacingM),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setDialogState(() {
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
                      ),
                    ),
                    SizedBox(width: responsive.spacingM),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (time != null) {
                            setDialogState(() {
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
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.spacingM),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(responsive.radiusM),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium(
                  color: AppColors.grey,
                ).copyWith(
                  fontSize: responsive.fontSize(14),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (doctorNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please enter doctor name'),
                      backgroundColor: AppColors.dangerColor,
                    ),
                  );
                  return;
                }

                final appointmentDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                final newAppointment = Appointment(
                  id: appointment?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: provider.pregnancyProfile?.userId ?? '',
                  doctorName: doctorNameController.text.trim(),
                  date: appointmentDateTime,
                  type: typeController.text.trim().isEmpty
                      ? 'Checkup'
                      : typeController.text.trim(),
                  notes: notesController.text.trim().isEmpty
                      ? null
                      : notesController.text.trim(),
                );

                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                await provider.saveAppointment(newAppointment);
                if (mounted) {
                  navigator.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        appointment == null
                            ? 'Appointment added successfully'
                            : 'Appointment updated successfully',
                      ),
                      backgroundColor: AppColors.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryPurple,
                foregroundColor: AppColors.white,
              ),
              child: Text(
                appointment == null ? 'Add' : 'Update',
                style: AppTextStyles.buttonText(
                  color: AppColors.white,
                ).copyWith(
                  fontSize: responsive.fontSize(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAppointment(Appointment appointment) {
    final provider = Provider.of<MaternityWingProvider>(context, listen: false);
    final responsive = Responsive(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.radiusXL),
        ),
        title: Text(
          'Delete Appointment?',
          style: AppTextStyles.headingSmall(
            color: AppColors.primaryDark,
          ).copyWith(
            fontSize: responsive.fontSize(18),
          ),
        ),
        content: Text(
          'Are you sure you want to delete this appointment with ${appointment.doctorName}?',
          style: AppTextStyles.bodyMedium(
            color: AppColors.primaryDark,
          ).copyWith(
            fontSize: responsive.fontSize(14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium(
                color: AppColors.grey,
              ).copyWith(
                fontSize: responsive.fontSize(14),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              await provider.deleteAppointment(appointment.id);
              if (mounted) {
                navigator.pop();
                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('Appointment deleted'),
                    backgroundColor: AppColors.successColor,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dangerColor,
              foregroundColor: AppColors.white,
            ),
            child: Text(
              'Delete',
              style: AppTextStyles.buttonText(
                color: AppColors.white,
              ).copyWith(
                fontSize: responsive.fontSize(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = Provider.of<MaternityWingProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'wellness'),
      appBar: const CustomAppBar(
        title: 'Manage Appointments',
        showLogo: true,
        showBackButton: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: AppColors.secondaryPurple,
        foregroundColor: AppColors.white,
        icon: Icon(Icons.add_rounded, size: responsive.iconSize(24)),
        label: Text(
          'Add Appointment',
          style: AppTextStyles.buttonText(
            color: AppColors.white,
          ).copyWith(
            fontSize: responsive.fontSize(14),
          ),
        ),
      ),
      body: provider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.secondaryPurple,
              ),
            )
          : provider.appointments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: responsive.iconSize(80),
                        color: AppColors.grey,
                      ),
                      SizedBox(height: responsive.spacingL),
                      Text(
                        'No appointments yet',
                        style: AppTextStyles.headingSmall(
                          color: AppColors.primaryDark,
                        ).copyWith(
                          fontSize: responsive.fontSize(20),
                        ),
                      ),
                      SizedBox(height: responsive.spacingS),
                      Text(
                        'Tap the + button to add your first appointment',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.grey,
                        ).copyWith(
                          fontSize: responsive.fontSize(14),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: responsive.screenPadding.copyWith(
                    bottom: responsive.spacingXXL * 2,
                  ),
                  itemCount: provider.appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = provider.appointments[index];
                    final isPast = appointment.date.isBefore(DateTime.now());

                    return Container(
                      margin: EdgeInsets.only(bottom: responsive.spacingL),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(responsive.radiusL),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(alpha: 0.08),
                            blurRadius: responsive.spacingM,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: responsive.paddingL,
                        leading: Container(
                          padding: responsive.paddingM,
                          decoration: BoxDecoration(
                            color: isPast
                                ? AppColors.grey.withValues(alpha: 0.2)
                                : AppColors.softPink.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(responsive.radiusM),
                          ),
                          child: Icon(
                            Icons.calendar_today_rounded,
                            color: isPast ? AppColors.grey : AppColors.softPink,
                            size: responsive.iconSize(24),
                          ),
                        ),
                        title: Text(
                          appointment.doctorName,
                          style: AppTextStyles.bodyLarge(
                            color: AppColors.primaryDark,
                          ).copyWith(
                            fontSize: responsive.fontSize(16),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: responsive.spacingXS),
                            Text(
                              appointment.type,
                              style: AppTextStyles.bodySmall(
                                color: AppColors.primaryDark.withValues(alpha: 0.7),
                              ).copyWith(
                                fontSize: responsive.fontSize(13),
                              ),
                            ),
                            SizedBox(height: responsive.spacingXS),
                            Text(
                              '${appointment.date.day}/${appointment.date.month}/${appointment.date.year} at ${TimeOfDay.fromDateTime(appointment.date).format(context)}',
                              style: AppTextStyles.bodySmall(
                                color: AppColors.primaryDark.withValues(alpha: 0.7),
                              ).copyWith(
                                fontSize: responsive.fontSize(12),
                              ),
                            ),
                            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                              SizedBox(height: responsive.spacingXS),
                              Text(
                                appointment.notes!,
                                style: AppTextStyles.bodySmall(
                                  color: AppColors.primaryDark.withValues(alpha: 0.6),
                                ).copyWith(
                                  fontSize: responsive.fontSize(12),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit_rounded,
                                color: AppColors.secondaryPurple,
                                size: responsive.iconSize(20),
                              ),
                              onPressed: () => _showAddEditDialog(appointment: appointment),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_rounded,
                                color: AppColors.dangerColor,
                                size: responsive.iconSize(20),
                              ),
                              onPressed: () => _deleteAppointment(appointment),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}


