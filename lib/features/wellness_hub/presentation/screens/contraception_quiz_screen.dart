import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../providers/family_planning_provider.dart';
import '../../domain/entities/quiz_answers.dart';
import '../../domain/entities/contraceptive_method.dart';

/// Contraception Quiz Screen
/// Multi-step form to find the best contraceptive method
class ContraceptionQuizScreen extends StatefulWidget {
  const ContraceptionQuizScreen({super.key});

  @override
  State<ContraceptionQuizScreen> createState() => _ContraceptionQuizScreenState();
}

class _ContraceptionQuizScreenState extends State<ContraceptionQuizScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Quiz answers
  bool? _hormonalOk;
  bool? _dailyPillOk;
  bool? _longTermOk;
  bool? _discreetOk;
  bool? _reversibleOk;
  bool _stdProtectionNeeded = false;

  ContraceptiveMethod? _result;

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _hormonalOk != null;
      case 1:
        return _dailyPillOk != null;
      case 2:
        return _longTermOk != null;
      case 3:
        return _discreetOk != null && _reversibleOk != null;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _submitQuiz();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _submitQuiz() {
    final provider = Provider.of<FamilyPlanningProvider>(context, listen: false);
    final answers = QuizAnswers(
      hormonalOk: _hormonalOk ?? false,
      dailyPillOk: _dailyPillOk ?? false,
      longTermOk: _longTermOk ?? false,
      discreetOk: _discreetOk ?? false,
      reversibleOk: _reversibleOk ?? false,
      stdProtectionNeeded: _stdProtectionNeeded,
    );

    final result = provider.matchContraceptive(answers);
    setState(() {
      _result = result;
    });
  }

  void _saveToProfile() async {
    if (_result == null) return;

    final provider = Provider.of<FamilyPlanningProvider>(context, listen: false);
    final answers = QuizAnswers(
      hormonalOk: _hormonalOk ?? false,
      dailyPillOk: _dailyPillOk ?? false,
      longTermOk: _longTermOk ?? false,
      discreetOk: _discreetOk ?? false,
      reversibleOk: _reversibleOk ?? false,
      stdProtectionNeeded: _stdProtectionNeeded,
    );

    await provider.saveQuizResult(answers, _result!);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Quiz result saved to your profile'),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    if (_result != null) {
      return _buildResultScreen(responsive);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'wellness'),
      appBar: const CustomAppBar(
        title: 'Find Your Method',
        showLogo: true,
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: responsive.paddingXL,
            color: AppColors.white,
            child: Column(
              children: [
                Row(
                  children: List.generate(_totalSteps, (index) {
                    return Expanded(
                      child: Container(
                        height: responsive.size(4),
                        margin: EdgeInsets.symmetric(
                          horizontal: responsive.spacingXS,
                        ),
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? AppColors.secondaryPurple
                              : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(responsive.radiusRound),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: responsive.spacingM),
                Text(
                  'Step ${_currentStep + 1} of $_totalSteps',
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.primaryDark.withValues(alpha: 0.7),
                  ).copyWith(
                    fontSize: responsive.fontSize(14),
                  ),
                ),
              ],
            ),
          ),

          // Question Content
          Expanded(
            child: SingleChildScrollView(
              padding: responsive.screenPadding,
              child: _buildStepContent(responsive),
            ),
          ),

          // Navigation Buttons
          Container(
            padding: responsive.paddingXL,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.05),
                  blurRadius: responsive.spacingS,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
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
                        'Previous',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.secondaryPurple,
                        ).copyWith(
                          fontSize: responsive.fontSize(14),
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 0) SizedBox(width: responsive.spacingM),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _canProceed ? _nextStep : null,
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
                      _currentStep == _totalSteps - 1 ? 'Get Results' : 'Next',
                      style: AppTextStyles.buttonText(
                        color: AppColors.white,
                      ).copyWith(
                        fontSize: responsive.fontSize(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(Responsive responsive) {
    switch (_currentStep) {
      case 0:
        return _buildQuestion(
          responsive,
          question: 'Are you comfortable with hormonal methods?',
          description: 'Hormonal methods include pills, patches, rings, implants, and injections.',
          value: _hormonalOk,
          onChanged: (value) => setState(() => _hormonalOk = value),
        );
      case 1:
        return _buildQuestion(
          responsive,
          question: 'Can you commit to taking a daily pill?',
          description: 'Birth control pills need to be taken at the same time every day.',
          value: _dailyPillOk,
          onChanged: (value) => setState(() => _dailyPillOk = value),
        );
      case 2:
        return _buildQuestion(
          responsive,
          question: 'Do you prefer a long-term solution?',
          description: 'Long-term methods like IUDs and implants last 3-10 years.',
          value: _longTermOk,
          onChanged: (value) => setState(() => _longTermOk = value),
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Do you need a discreet method?',
              style: AppTextStyles.headingSmall(
                color: AppColors.primaryDark,
              ).copyWith(
                fontSize: responsive.fontSize(20),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: responsive.spacingS),
            Text(
              'Some methods are more visible or require regular visits.',
              style: AppTextStyles.bodyMedium(
                color: AppColors.primaryDark.withValues(alpha: 0.7),
              ).copyWith(
                fontSize: responsive.fontSize(14),
              ),
            ),
            SizedBox(height: responsive.spacingXL),
            _buildYesNoButton(
              responsive,
              label: 'Yes, I need discretion',
              value: _discreetOk == true,
              onTap: () => setState(() => _discreetOk = true),
            ),
            SizedBox(height: responsive.spacingM),
            _buildYesNoButton(
              responsive,
              label: 'No, discretion is not important',
              value: _discreetOk == false,
              onTap: () => setState(() => _discreetOk = false),
            ),
            SizedBox(height: responsive.spacingXXL),
            Text(
              'Do you want a reversible method?',
              style: AppTextStyles.headingSmall(
                color: AppColors.primaryDark,
              ).copyWith(
                fontSize: responsive.fontSize(20),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: responsive.spacingS),
            Text(
              'Reversible methods allow you to conceive when you stop using them.',
              style: AppTextStyles.bodyMedium(
                color: AppColors.primaryDark.withValues(alpha: 0.7),
              ).copyWith(
                fontSize: responsive.fontSize(14),
              ),
            ),
            SizedBox(height: responsive.spacingXL),
            _buildYesNoButton(
              responsive,
              label: 'Yes, I want it reversible',
              value: _reversibleOk == true,
              onTap: () => setState(() => _reversibleOk = true),
            ),
            SizedBox(height: responsive.spacingM),
            _buildYesNoButton(
              responsive,
              label: 'No, permanence is fine',
              value: _reversibleOk == false,
              onTap: () => setState(() => _reversibleOk = false),
            ),
            SizedBox(height: responsive.spacingXL),
            CheckboxListTile(
              value: _stdProtectionNeeded,
              onChanged: (value) => setState(() => _stdProtectionNeeded = value ?? false),
              title: Text(
                'I also need protection against STIs',
                style: AppTextStyles.bodyMedium(
                  color: AppColors.primaryDark,
                ).copyWith(
                  fontSize: responsive.fontSize(14),
                ),
              ),
              activeColor: AppColors.secondaryPurple,
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildQuestion(
    Responsive responsive, {
    required String question,
    required String description,
    required bool? value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: AppTextStyles.headingSmall(
            color: AppColors.primaryDark,
          ).copyWith(
            fontSize: responsive.fontSize(20),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: responsive.spacingS),
        Text(
          description,
          style: AppTextStyles.bodyMedium(
            color: AppColors.primaryDark.withValues(alpha: 0.7),
          ).copyWith(
            fontSize: responsive.fontSize(14),
          ),
        ),
        SizedBox(height: responsive.spacingXXL),
        _buildYesNoButton(
          responsive,
          label: 'Yes',
          value: value == true,
          onTap: () => onChanged(true),
        ),
        SizedBox(height: responsive.spacingM),
        _buildYesNoButton(
          responsive,
          label: 'No',
          value: value == false,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }

  Widget _buildYesNoButton(
    Responsive responsive, {
    required String label,
    required bool value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusL),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: responsive.paddingL,
          decoration: BoxDecoration(
            color: value ? AppColors.secondaryPurple : AppColors.white,
            borderRadius: BorderRadius.circular(responsive.radiusL),
            border: Border.all(
              color: value
                  ? AppColors.secondaryPurple
                  : AppColors.lightGrey,
              width: value ? 2 : 1,
            ),
            boxShadow: value
                ? [
                    BoxShadow(
                      color: AppColors.secondaryPurple.withValues(alpha: 0.3),
                      blurRadius: responsive.spacingS,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: responsive.size(24),
                height: responsive.size(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value
                      ? AppColors.white
                      : AppColors.lightGrey,
                  border: Border.all(
                    color: value
                        ? AppColors.white
                        : AppColors.grey,
                    width: 2,
                  ),
                ),
                child: value
                    ? Icon(
                        Icons.check_rounded,
                        color: AppColors.secondaryPurple,
                        size: responsive.iconSize(16),
                      )
                    : null,
              ),
              SizedBox(width: responsive.spacingM),
              Text(
                label,
                style: AppTextStyles.bodyLarge(
                  color: value ? AppColors.white : AppColors.primaryDark,
                ).copyWith(
                  fontSize: responsive.fontSize(16),
                  fontWeight: value ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(Responsive responsive) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'wellness'),
      appBar: const CustomAppBar(
        title: 'Your Best Match',
        showLogo: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: responsive.screenPadding,
        child: Column(
          children: [
            // Result Card
            Container(
              padding: responsive.paddingXXL,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.secondaryPurple,
                    AppColors.accentPurple,
                  ],
                ),
                borderRadius: BorderRadius.circular(responsive.radiusXXL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryPurple.withValues(alpha: 0.3),
                    blurRadius: responsive.spacingXL,
                    offset: Offset(0, responsive.spacingM),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.celebration_rounded,
                    color: AppColors.white,
                    size: responsive.iconSize(60),
                  ),
                  SizedBox(height: responsive.spacingL),
                  Text(
                    'Best Match For You',
                    style: AppTextStyles.headingLarge(
                      color: AppColors.white,
                    ).copyWith(
                      fontSize: responsive.fontSize(24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.spacingXL),
                  Container(
                    padding: responsive.paddingXL,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(responsive.radiusL),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _result!.name,
                          style: AppTextStyles.displayMedium(
                            color: AppColors.white,
                          ).copyWith(
                            fontSize: responsive.fontSize(32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: responsive.spacingM),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shield_rounded,
                              color: AppColors.white,
                              size: responsive.iconSize(20),
                            ),
                            SizedBox(width: responsive.spacingS),
                            Text(
                              '${_result!.efficacyPercentage} Effective',
                              style: AppTextStyles.bodyLarge(
                                color: AppColors.white,
                              ).copyWith(
                                fontSize: responsive.fontSize(16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: responsive.spacingXXL),

            // Why It Fits
            Container(
              padding: responsive.paddingXL,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.secondaryPurple,
                        size: responsive.iconSize(24),
                      ),
                      SizedBox(width: responsive.spacingM),
                      Text(
                        'Why This Method Fits You',
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
                    _result!.whyItFits,
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.primaryDark,
                    ).copyWith(
                      fontSize: responsive.fontSize(14),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: responsive.spacingXXL),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveToProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryPurple,
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
                      Icons.save_rounded,
                      size: responsive.iconSize(20),
                    ),
                    SizedBox(width: responsive.spacingM),
                    Text(
                      'Save to Profile',
                      style: AppTextStyles.buttonText(
                        color: AppColors.white,
                      ).copyWith(
                        fontSize: responsive.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


