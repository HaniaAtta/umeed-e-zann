import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/usecases/diagnose_symptoms_usecase.dart';

/// Symptom Check Dialog
/// AI Doctor diagnostic form for symptom analysis
class SymptomCheckDialog extends StatefulWidget {
  const SymptomCheckDialog({super.key});

  @override
  State<SymptomCheckDialog> createState() => _SymptomCheckDialogState();
}

class _SymptomCheckDialogState extends State<SymptomCheckDialog> {
  final DiagnoseSymptomsUseCase _diagnoseUseCase = DiagnoseSymptomsUseCase();
  final List<String> _selectedSymptoms = [];
  String? _diagnosisResult;
  bool _isDiagnosing = false;

  // Available physical symptoms for selection
  final List<String> _availableSymptoms = [
    'irregular periods',
    'acne',
    'weight gain',
    'pelvic pain',
    'painful intercourse',
    'heavy bleeding',
    'missed periods',
    'cramps',
    'bloating',
    'mood swings',
    'fatigue',
    'nausea',
    'breast tenderness',
    'back pain',
  ];

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  void _diagnoseSymptoms() {
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one symptom'),
          backgroundColor: AppColors.dangerColor,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isDiagnosing = true;
    });

    // Simulate a brief delay for better UX
    Future.delayed(const Duration(milliseconds: 500), () {
      final diagnosis = _diagnoseUseCase.execute(_selectedSymptoms);
      setState(() {
        _diagnosisResult = diagnosis;
        _isDiagnosing = false;
      });
    });
  }

  void _resetDialog() {
    setState(() {
      _selectedSymptoms.clear();
      _diagnosisResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: responsive.screenPadding,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
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
                  Container(
                    padding: responsive.paddingM,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.medical_services_rounded,
                      color: AppColors.white,
                      size: responsive.iconSize(24),
                    ),
                  ),
                  SizedBox(width: responsive.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Doctor - Symptom Check',
                          style: AppTextStyles.headingSmall(
                            color: AppColors.white,
                          ).copyWith(
                            fontSize: responsive.fontSize(18),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Select your symptoms for analysis',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ).copyWith(
                            fontSize: responsive.fontSize(12),
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
                child: _diagnosisResult == null
                    ? _buildSymptomSelection(responsive)
                    : _buildDiagnosisResult(responsive),
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
                  if (_diagnosisResult != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _resetDialog,
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
                          'Check Again',
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.secondaryPurple,
                          ).copyWith(
                            fontSize: responsive.fontSize(14),
                          ),
                        ),
                      ),
                    ),
                  if (_diagnosisResult != null)
                    SizedBox(width: responsive.spacingM),
                  Expanded(
                    flex: _diagnosisResult == null ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: _diagnosisResult == null
                          ? _diagnoseSymptoms
                          : () => Navigator.of(context).pop(),
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
                      child: _isDiagnosing
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
                              _diagnosisResult == null
                                  ? 'Diagnose Symptoms'
                                  : 'Close',
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

  Widget _buildSymptomSelection(Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select all symptoms that apply:',
          style: AppTextStyles.bodyLarge(
            color: AppColors.primaryDark,
          ).copyWith(
            fontSize: responsive.fontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: responsive.spacingL),
        Wrap(
          spacing: responsive.spacingM,
          runSpacing: responsive.spacingM,
          children: _availableSymptoms.map((symptom) {
            final isSelected = _selectedSymptoms.contains(symptom);
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _toggleSymptom(symptom),
                borderRadius: BorderRadius.circular(responsive.radiusRound),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.spacingL,
                    vertical: responsive.spacingM,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.softPink
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(responsive.radiusRound),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.softPink
                          : AppColors.lightGrey,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    symptom,
                    style: AppTextStyles.bodyMedium(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.primaryDark,
                    ).copyWith(
                      fontSize: responsive.fontSize(13),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDiagnosisResult(Responsive responsive) {
    return Container(
      padding: responsive.paddingXL,
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(responsive.radiusL),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: AppColors.warning,
                size: responsive.iconSize(28),
              ),
              SizedBox(width: responsive.spacingM),
              Text(
                'Diagnosis Result',
                style: AppTextStyles.headingSmall(
                  color: AppColors.primaryDark,
                ).copyWith(
                  fontSize: responsive.fontSize(18),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacingL),
          Text(
            _diagnosisResult!,
            style: AppTextStyles.bodyMedium(
              color: AppColors.primaryDark,
            ).copyWith(
              fontSize: responsive.fontSize(14),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}


