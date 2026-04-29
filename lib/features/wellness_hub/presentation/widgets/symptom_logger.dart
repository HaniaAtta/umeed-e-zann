import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../contents/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/cycle_tracker_provider.dart';
import '../../domain/entities/cycle_log.dart';

/// Symptom Logger Widget
/// Beautiful symptom logging interface with choice chips
/// Placed right under the cycle phase dial for easy access
class SymptomLogger extends StatefulWidget {
  const SymptomLogger({super.key});

  @override
  State<SymptomLogger> createState() => _SymptomLoggerState();
}

class _SymptomLoggerState extends State<SymptomLogger> {
  Set<String> selectedSymptoms = {};
  int painLevel = 0;
  int energyLevel = 5;

  final List<Map<String, dynamic>> symptoms = [
    {
      'name': AppStrings.cramps,
      'icon': Icons.water_drop_rounded,
      'color': AppColors.softPink,
    },
    {
      'name': AppStrings.headache,
      'icon': Icons.sick_rounded,
      'color': AppColors.dustyPink,
    },
    {
      'name': AppStrings.energetic,
      'icon': Icons.bolt_rounded,
      'color': AppColors.secondaryPurple,
    },
    {
      'name': AppStrings.bloating,
      'icon': Icons.invert_colors_rounded,
      'color': AppColors.accentPurple,
    },
    {
      'name': 'Mood Swings',
      'icon': Icons.mood_rounded,
      'color': AppColors.palePink,
    },
    {
      'name': 'Backache',
      'icon': Icons.healing_rounded,
      'color': AppColors.dustyPink,
    },
    {
      'name': 'Acne',
      'icon': Icons.face_rounded,
      'color': AppColors.softPink,
    },
    {
      'name': 'Fatigue',
      'icon': Icons.bedtime_rounded,
      'color': AppColors.accentPurple,
    },
    {
      'name': 'Nausea',
      'icon': Icons.sick_outlined,
      'color': AppColors.secondaryPurple,
    },
  ];

  void _logSymptoms() async {
    final provider = Provider.of<CycleTrackerProvider>(context, listen: false);
    
    if (selectedSymptoms.isEmpty && painLevel == 0 && energyLevel == 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please log at least one symptom or adjust pain/energy level'),
          backgroundColor: AppColors.primaryDark,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Create cycle log entry
    final log = CycleLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      flowIntensity: 1, // Default, can be updated later
      painLevel: painLevel,
      energyLevel: energyLevel,
      symptoms: selectedSymptoms.toList(),
      physicalSymptoms: [], // Can be added later
    );

    await provider.saveCycleLog(log);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Symptoms logged successfully!'),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      setState(() {
        selectedSymptoms.clear();
        painLevel = 0;
        energyLevel = 5;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacingXL),
      padding: responsive.paddingXL,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(responsive.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: responsive.spacingL,
            offset: Offset(0, responsive.spacingS),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: responsive.paddingS,
                decoration: BoxDecoration(
                  color: AppColors.softPink.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(responsive.radiusM),
                ),
                child: Icon(
                  Icons.health_and_safety_rounded,
                  color: AppColors.softPink,
                  size: responsive.iconSize(24),
                ),
              ),
              SizedBox(width: responsive.spacingM),
              Expanded(
                child: Text(
                  AppStrings.howAreYouFeeling,
                  style: AppTextStyles.headingSmall(
                    color: AppColors.primaryDark,
                  ).copyWith(
                    fontSize: responsive.fontSize(20),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: responsive.spacingL),
          
          // Symptom Chips
          Wrap(
            spacing: responsive.spacingM,
            runSpacing: responsive.spacingM,
            children: symptoms.map((symptom) {
              final name = symptom['name'] as String;
              final icon = symptom['icon'] as IconData;
              final color = symptom['color'] as Color;
              final isSelected = selectedSymptoms.contains(name);
              
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedSymptoms.remove(name);
                      } else {
                        selectedSymptoms.add(name);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(responsive.radiusRound),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.spacingL,
                      vertical: responsive.spacingM,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color
                          : color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(responsive.radiusRound),
                      border: Border.all(
                        color: isSelected
                            ? color
                            : color.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.3),
                                blurRadius: responsive.spacingS,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          color: isSelected
                              ? AppColors.white
                              : color,
                          size: responsive.iconSize(18),
                        ),
                        SizedBox(width: responsive.spacingS),
                        Text(
                          name,
                          style: AppTextStyles.bodyMedium(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.primaryDark,
                          ).copyWith(
                            fontSize: responsive.fontSize(14),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          SizedBox(height: responsive.spacingXL),
          
          // Pain Level Slider
          Text(
            'Pain Level (0-10)',
            style: AppTextStyles.bodyLarge(
              color: AppColors.primaryDark,
            ).copyWith(
              fontSize: responsive.fontSize(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: responsive.spacingS),
          Row(
            children: [
              Icon(Icons.sick_rounded, color: AppColors.dustyPink, size: responsive.iconSize(20)),
              Expanded(
                child: Slider(
                  value: painLevel.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  activeColor: AppColors.dustyPink,
                  inactiveColor: AppColors.dustyPink.withValues(alpha: 0.2),
                  label: '$painLevel',
                  onChanged: (value) {
                    setState(() {
                      painLevel = value.toInt();
                    });
                  },
                ),
              ),
              Text(
                '$painLevel',
                style: AppTextStyles.bodyLarge(
                  color: AppColors.primaryDark,
                ).copyWith(
                  fontSize: responsive.fontSize(16),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          
          SizedBox(height: responsive.spacingL),
          
          // Energy Level Slider
          Text(
            'Energy Level (0-10)',
            style: AppTextStyles.bodyLarge(
              color: AppColors.primaryDark,
            ).copyWith(
              fontSize: responsive.fontSize(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: responsive.spacingS),
          Row(
            children: [
              Icon(Icons.bolt_rounded, color: AppColors.secondaryPurple, size: responsive.iconSize(20)),
              Expanded(
                child: Slider(
                  value: energyLevel.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  activeColor: AppColors.secondaryPurple,
                  inactiveColor: AppColors.secondaryPurple.withValues(alpha: 0.2),
                  label: '$energyLevel',
                  onChanged: (value) {
                    setState(() {
                      energyLevel = value.toInt();
                    });
                  },
                ),
              ),
              Text(
                '$energyLevel',
                style: AppTextStyles.bodyLarge(
                  color: AppColors.primaryDark,
                ).copyWith(
                  fontSize: responsive.fontSize(16),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          
          SizedBox(height: responsive.spacingXL),
          
          // Log Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _logSymptoms,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(
                  vertical: responsive.spacingL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.radiusL),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: responsive.iconSize(20),
                  ),
                  SizedBox(width: responsive.spacingS),
                  Text(
                    AppStrings.logSymptoms,
                    style: AppTextStyles.buttonText(
                      color: AppColors.white,
                    ).copyWith(
                      fontSize: responsive.fontSize(16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

