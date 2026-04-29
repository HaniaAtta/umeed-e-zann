import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';

/// PCOS Assessment Quiz
class PCOSQuizDialog extends StatefulWidget {
  const PCOSQuizDialog({super.key});

  @override
  State<PCOSQuizDialog> createState() => _PCOSQuizDialogState();
}

class _PCOSQuizDialogState extends State<PCOSQuizDialog> {
  final List<Map<String, dynamic>> questions = const [
    {
      'key': 'irregular_periods',
      'question': 'Do you have irregular or missed periods?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'excess_hair',
      'question': 'Do you experience excess facial or body hair growth?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'acne',
      'question': 'Do you have persistent acne or oily skin?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'weight_gain',
      'question': 'Have you experienced unexplained weight gain or difficulty losing weight?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'hair_loss',
      'question': 'Do you notice thinning hair or hair loss?',
      'options': ['Yes', 'No'],
    },
  ];

  Map<String, bool> answers = {};
  int currentQuestionIndex = 0;
  String? result;

  String _calculateLikelihood() {
    int positiveAnswers = 0;
    answers.forEach((key, value) {
      if (value == true) positiveAnswers++;
    });

    if (positiveAnswers >= 4) return 'high';
    if (positiveAnswers >= 2) return 'medium';
    return 'low';
  }

  String _getLikelihoodMessage(String likelihood) {
    final positiveCount = answers.values.where((v) => v == true).length;
    final symptoms = answers.entries
        .where((e) => e.value == true)
        .map((e) => '• ${e.key.replaceAll('_', ' ').split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ')}')
        .join('\n');

    switch (likelihood) {
      case 'high':
        return '''High Likelihood of PCOS ($positiveCount/5 symptoms)

Based on your responses, you have a high likelihood of having PCOS (Polycystic Ovary Syndrome).

Key indicators present:
$symptoms

Recommendation: Please consult with a gynecologist or endocrinologist for proper diagnosis. PCOS is manageable with lifestyle changes and medical treatment.

Note: This is not a medical diagnosis. Doctorbot provides likelihood assessment only. Always consult a healthcare professional.''';

      case 'medium':
        return '''Moderate Likelihood of PCOS ($positiveCount/5 symptoms)

Based on your responses, you have a moderate likelihood of having PCOS.

Some indicators present:
$symptoms

Recommendation: Consider discussing these symptoms with your healthcare provider. Early diagnosis and treatment can help manage PCOS effectively.

Note: This is not a medical diagnosis. Doctorbot provides likelihood assessment only.''';

      default:
        return '''Low Likelihood of PCOS ($positiveCount/5 symptoms)

Based on your responses, you have a low likelihood of having PCOS.

However, if you continue to experience symptoms or have concerns, please consult with a healthcare provider for proper evaluation.

Note: This is not a medical diagnosis. Doctorbot provides likelihood assessment only.''';
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    if (result != null) {
      return _buildResultScreen(responsive);
    }

    return _buildQuizDialog(responsive, 'PCOS Assessment');
  }

  Widget _buildQuizDialog(Responsive responsive, String title) {
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
            Container(
              padding: responsive.paddingXL,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondaryPurple, AppColors.accentPurple],
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
                          title,
                          style: AppTextStyles.headingSmall(color: AppColors.white).copyWith(
                            fontSize: responsive.fontSize(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: responsive.spacingXS),
                        Text(
                          'Doctorbot will assess likelihood based on your symptoms',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ).copyWith(fontSize: responsive.fontSize(12)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Container(
              padding: responsive.paddingM,
              color: AppColors.background,
              child: Row(
                children: List.generate(questions.length, (index) {
                  return Expanded(
                    child: Container(
                      height: responsive.size(4),
                      margin: EdgeInsets.symmetric(horizontal: responsive.spacingXS),
                      decoration: BoxDecoration(
                        color: index <= currentQuestionIndex
                            ? AppColors.secondaryPurple
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(responsive.radiusRound),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: responsive.paddingXL,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questions[currentQuestionIndex]['question'] as String,
                      style: AppTextStyles.headingSmall(color: AppColors.primaryDark).copyWith(
                        fontSize: responsive.fontSize(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: responsive.spacingXL),
                    ...(questions[currentQuestionIndex]['options'] as List<String>).map((option) =>
                        Padding(
                          padding: EdgeInsets.only(bottom: responsive.spacingM),
                          child: _buildOptionButton(
                            responsive,
                            option: option,
                            isSelected: answers[questions[currentQuestionIndex]['key']] ==
                                (option == 'Yes'),
                            onTap: () {
                              setState(() {
                                answers[questions[currentQuestionIndex]['key']] = option == 'Yes';
                              });
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
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
                  if (currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            currentQuestionIndex--;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: responsive.spacingM),
                          side: BorderSide(color: AppColors.secondaryPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.radiusL),
                          ),
                        ),
                        child: Text('Previous',
                            style: AppTextStyles.bodyMedium(color: AppColors.secondaryPurple)),
                      ),
                    ),
                  if (currentQuestionIndex > 0) SizedBox(width: responsive.spacingM),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: answers[questions[currentQuestionIndex]['key']] == null
                          ? null
                          : () {
                              if (currentQuestionIndex < questions.length - 1) {
                                setState(() {
                                  currentQuestionIndex++;
                                });
                              } else {
                                final likelihood = _calculateLikelihood();
                                setState(() {
                                  result = _getLikelihoodMessage(likelihood);
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryPurple,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: responsive.spacingM),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(responsive.radiusL),
                        ),
                      ),
                      child: Text(
                        currentQuestionIndex < questions.length - 1 ? 'Next' : 'Get Assessment',
                        style: AppTextStyles.buttonText(color: AppColors.white),
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

  Widget _buildOptionButton(
    Responsive responsive, {
    required String option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusL),
        child: Container(
          padding: responsive.paddingL,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondaryPurple : AppColors.white,
            borderRadius: BorderRadius.circular(responsive.radiusL),
            border: Border.all(
              color: isSelected ? AppColors.secondaryPurple : AppColors.lightGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: responsive.size(24),
                height: responsive.size(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.white : AppColors.lightGrey,
                  border: Border.all(
                    color: isSelected ? AppColors.white : AppColors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded,
                        color: AppColors.secondaryPurple, size: responsive.iconSize(16))
                    : null,
              ),
              SizedBox(width: responsive.spacingM),
              Expanded(
                child: Text(
                  option,
                  style: AppTextStyles.bodyMedium(
                    color: isSelected ? AppColors.white : AppColors.primaryDark,
                  ).copyWith(
                    fontSize: responsive.fontSize(15),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(Responsive responsive) {
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: responsive.paddingXL,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondaryPurple, AppColors.accentPurple],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(responsive.radiusXXL),
                  topRight: Radius.circular(responsive.radiusXXL),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Assessment Result',
                      style: AppTextStyles.headingSmall(color: AppColors.white).copyWith(
                        fontSize: responsive.fontSize(20),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: responsive.paddingXL,
                child: Text(
                  result!,
                  style: AppTextStyles.bodyMedium(color: AppColors.primaryDark).copyWith(
                    fontSize: responsive.fontSize(14),
                    height: 1.6,
                  ),
                ),
              ),
            ),
            Container(
              padding: responsive.paddingXL,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryPurple,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: responsive.spacingM),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(responsive.radiusL),
                  ),
                ),
                child: Text('Close', style: AppTextStyles.buttonText(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Endometriosis Assessment Quiz
class EndometriosisQuizDialog extends StatefulWidget {
  const EndometriosisQuizDialog({super.key});

  @override
  State<EndometriosisQuizDialog> createState() => _EndometriosisQuizDialogState();
}

class _EndometriosisQuizDialogState extends State<EndometriosisQuizDialog> {
  final List<Map<String, dynamic>> questions = const [
    {
      'key': 'pelvic_pain',
      'question': 'Do you experience chronic pelvic pain?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'painful_intercourse',
      'question': 'Do you experience pain during or after intercourse?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'painful_periods',
      'question': 'Do you have severe menstrual cramps?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'painful_bowel',
      'question': 'Do you experience pain during bowel movements, especially during periods?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'infertility',
      'question': 'Have you been trying to conceive for over a year without success?',
      'options': ['Yes', 'No'],
    },
  ];

  Map<String, bool> answers = {};
  int currentQuestionIndex = 0;
  String? result;

  String _calculateLikelihood() {
    int positiveAnswers = 0;
    answers.forEach((key, value) {
      if (value == true) positiveAnswers++;
    });

    if (positiveAnswers >= 4) return 'high';
    if (positiveAnswers >= 2) return 'medium';
    return 'low';
  }

  String _getLikelihoodMessage(String likelihood) {
    final positiveCount = answers.values.where((v) => v == true).length;
    final symptoms = answers.entries
        .where((e) => e.value == true)
        .map((e) => '• ${e.key.replaceAll('_', ' ').split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ')}')
        .join('\n');

    switch (likelihood) {
      case 'high':
        return '''High Likelihood of Endometriosis ($positiveCount/5 symptoms)

Based on your responses, you have a high likelihood of having Endometriosis.

Key indicators present:
$symptoms

Recommendation: Please consult with a gynecologist who specializes in endometriosis. Early diagnosis and treatment can significantly improve quality of life.

Note: This is not a medical diagnosis. Doctorbot provides likelihood assessment only. Always consult a healthcare professional.''';

      case 'medium':
        return '''Moderate Likelihood of Endometriosis ($positiveCount/5 symptoms)

Based on your responses, you have a moderate likelihood of having Endometriosis.

Some indicators present:
$symptoms

Recommendation: Consider discussing these symptoms with your healthcare provider. Endometriosis requires medical evaluation for proper diagnosis.

Note: This is not a medical diagnosis. Doctorbot provides likelihood assessment only.''';

      default:
        return '''Low Likelihood of Endometriosis ($positiveCount/5 symptoms)

Based on your responses, you have a low likelihood of having Endometriosis.

However, if you continue to experience symptoms or have concerns, please consult with a healthcare provider for proper evaluation.

Note: This is not a medical diagnosis. Doctorbot provides likelihood assessment only.''';
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    if (result != null) {
      return _buildResultScreen(responsive);
    }

    return _buildQuizDialog(responsive, 'Endometriosis Assessment');
  }

  Widget _buildQuizDialog(Responsive responsive, String title) {
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
            Container(
              padding: responsive.paddingXL,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondaryPurple, AppColors.accentPurple],
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
                          title,
                          style: AppTextStyles.headingSmall(color: AppColors.white).copyWith(
                            fontSize: responsive.fontSize(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: responsive.spacingXS),
                        Text(
                          'Doctorbot will assess likelihood based on your symptoms',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ).copyWith(fontSize: responsive.fontSize(12)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Container(
              padding: responsive.paddingM,
              color: AppColors.background,
              child: Row(
                children: List.generate(questions.length, (index) {
                  return Expanded(
                    child: Container(
                      height: responsive.size(4),
                      margin: EdgeInsets.symmetric(horizontal: responsive.spacingXS),
                      decoration: BoxDecoration(
                        color: index <= currentQuestionIndex
                            ? AppColors.secondaryPurple
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(responsive.radiusRound),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: responsive.paddingXL,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questions[currentQuestionIndex]['question'] as String,
                      style: AppTextStyles.headingSmall(color: AppColors.primaryDark).copyWith(
                        fontSize: responsive.fontSize(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: responsive.spacingXL),
                    ...(questions[currentQuestionIndex]['options'] as List<String>).map((option) =>
                        Padding(
                          padding: EdgeInsets.only(bottom: responsive.spacingM),
                          child: _buildOptionButton(
                            responsive,
                            option: option,
                            isSelected: answers[questions[currentQuestionIndex]['key']] ==
                                (option == 'Yes'),
                            onTap: () {
                              setState(() {
                                answers[questions[currentQuestionIndex]['key']] = option == 'Yes';
                              });
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
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
                  if (currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            currentQuestionIndex--;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: responsive.spacingM),
                          side: BorderSide(color: AppColors.secondaryPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.radiusL),
                          ),
                        ),
                        child: Text('Previous',
                            style: AppTextStyles.bodyMedium(color: AppColors.secondaryPurple)),
                      ),
                    ),
                  if (currentQuestionIndex > 0) SizedBox(width: responsive.spacingM),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: answers[questions[currentQuestionIndex]['key']] == null
                          ? null
                          : () {
                              if (currentQuestionIndex < questions.length - 1) {
                                setState(() {
                                  currentQuestionIndex++;
                                });
                              } else {
                                final likelihood = _calculateLikelihood();
                                setState(() {
                                  result = _getLikelihoodMessage(likelihood);
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryPurple,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: responsive.spacingM),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(responsive.radiusL),
                        ),
                      ),
                      child: Text(
                        currentQuestionIndex < questions.length - 1 ? 'Next' : 'Get Assessment',
                        style: AppTextStyles.buttonText(color: AppColors.white),
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

  Widget _buildOptionButton(
    Responsive responsive, {
    required String option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusL),
        child: Container(
          padding: responsive.paddingL,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondaryPurple : AppColors.white,
            borderRadius: BorderRadius.circular(responsive.radiusL),
            border: Border.all(
              color: isSelected ? AppColors.secondaryPurple : AppColors.lightGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: responsive.size(24),
                height: responsive.size(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.white : AppColors.lightGrey,
                  border: Border.all(
                    color: isSelected ? AppColors.white : AppColors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded,
                        color: AppColors.secondaryPurple, size: responsive.iconSize(16))
                    : null,
              ),
              SizedBox(width: responsive.spacingM),
              Expanded(
                child: Text(
                  option,
                  style: AppTextStyles.bodyMedium(
                    color: isSelected ? AppColors.white : AppColors.primaryDark,
                  ).copyWith(
                    fontSize: responsive.fontSize(15),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(Responsive responsive) {
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: responsive.paddingXL,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondaryPurple, AppColors.accentPurple],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(responsive.radiusXXL),
                  topRight: Radius.circular(responsive.radiusXXL),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Assessment Result',
                      style: AppTextStyles.headingSmall(color: AppColors.white).copyWith(
                        fontSize: responsive.fontSize(20),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: responsive.paddingXL,
                child: Text(
                  result!,
                  style: AppTextStyles.bodyMedium(color: AppColors.primaryDark).copyWith(
                    fontSize: responsive.fontSize(14),
                    height: 1.6,
                  ),
                ),
              ),
            ),
            Container(
              padding: responsive.paddingXL,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryPurple,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: responsive.spacingM),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(responsive.radiusL),
                  ),
                ),
                child: Text('Close', style: AppTextStyles.buttonText(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Breast Health Assessment Quiz
class BreastHealthQuizDialog extends StatefulWidget {
  const BreastHealthQuizDialog({super.key});

  @override
  State<BreastHealthQuizDialog> createState() => _BreastHealthQuizDialogState();
}

class _BreastHealthQuizDialogState extends State<BreastHealthQuizDialog> {
  final List<Map<String, dynamic>> questions = const [
    {
      'key': 'lump',
      'question': 'Have you noticed any lumps or thickening in your breast?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'discharge',
      'question': 'Do you experience nipple discharge (other than breast milk)?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'skin_changes',
      'question': 'Have you noticed any changes in breast skin (dimpling, redness, scaling)?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'nipple_changes',
      'question': 'Have you noticed any changes in nipple appearance or position?',
      'options': ['Yes', 'No'],
    },
    {
      'key': 'persistent_pain',
      'question': 'Do you experience persistent breast pain that doesn\'t relate to your cycle?',
      'options': ['Yes', 'No'],
    },
  ];

  Map<String, bool> answers = {};
  int currentQuestionIndex = 0;
  String? result;

  String _calculateLikelihood() {
    int positiveAnswers = 0;
    answers.forEach((key, value) {
      if (value == true) positiveAnswers++;
    });

    if (positiveAnswers >= 3) return 'high';
    if (positiveAnswers >= 1) return 'medium';
    return 'low';
  }

  String _getLikelihoodMessage(String likelihood) {
    final positiveCount = answers.values.where((v) => v == true).length;
    final symptoms = answers.entries
        .where((e) => e.value == true)
        .map((e) => '• ${e.key.replaceAll('_', ' ').split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ')}')
        .join('\n');

    switch (likelihood) {
      case 'high':
        return '''High Likelihood of Breast Health Concern ($positiveCount/5 symptoms)

Based on your responses, you have a high likelihood of a breast health concern that requires medical attention.

Key indicators present:
$symptoms

Recommendation: Please consult with a healthcare provider or breast specialist immediately. Early detection is crucial for breast health.

Note: This is not a medical diagnosis. Doctorbot provides likelihood assessment only. Always consult a healthcare professional.''';

      case 'medium':
        return '''Moderate Likelihood of Breast Health Concern ($positiveCount/5 symptoms)

Based on your responses, you have a moderate likelihood of a breast health concern.

Some indicators present:
$symptoms

Recommendation: Consider discussing these symptoms with your healthcare provider. Regular breast self-exams and mammograms are important for breast health.

Note: This is not a medical diagnosis. Doctorbot provides likelihood assessment only.''';

      default:
        return '''Low Likelihood of Breast Health Concern ($positiveCount/5 symptoms)

Based on your responses, you have a low likelihood of a breast health concern.

However, it's important to perform regular breast self-exams and maintain routine check-ups with your healthcare provider.

Note: This is not a medical diagnosis. Doctorbot provides likelihood assessment only.''';
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    if (result != null) {
      return _buildResultScreen(responsive);
    }

    return _buildQuizDialog(responsive, 'Breast Health Assessment');
  }

  Widget _buildQuizDialog(Responsive responsive, String title) {
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
            Container(
              padding: responsive.paddingXL,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondaryPurple, AppColors.accentPurple],
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
                          title,
                          style: AppTextStyles.headingSmall(color: AppColors.white).copyWith(
                            fontSize: responsive.fontSize(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: responsive.spacingXS),
                        Text(
                          'Doctorbot will assess likelihood based on your symptoms',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ).copyWith(fontSize: responsive.fontSize(12)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Container(
              padding: responsive.paddingM,
              color: AppColors.background,
              child: Row(
                children: List.generate(questions.length, (index) {
                  return Expanded(
                    child: Container(
                      height: responsive.size(4),
                      margin: EdgeInsets.symmetric(horizontal: responsive.spacingXS),
                      decoration: BoxDecoration(
                        color: index <= currentQuestionIndex
                            ? AppColors.secondaryPurple
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(responsive.radiusRound),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: responsive.paddingXL,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questions[currentQuestionIndex]['question'] as String,
                      style: AppTextStyles.headingSmall(color: AppColors.primaryDark).copyWith(
                        fontSize: responsive.fontSize(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: responsive.spacingXL),
                    ...(questions[currentQuestionIndex]['options'] as List<String>).map((option) =>
                        Padding(
                          padding: EdgeInsets.only(bottom: responsive.spacingM),
                          child: _buildOptionButton(
                            responsive,
                            option: option,
                            isSelected: answers[questions[currentQuestionIndex]['key']] ==
                                (option == 'Yes'),
                            onTap: () {
                              setState(() {
                                answers[questions[currentQuestionIndex]['key']] = option == 'Yes';
                              });
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
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
                  if (currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            currentQuestionIndex--;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: responsive.spacingM),
                          side: BorderSide(color: AppColors.secondaryPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.radiusL),
                          ),
                        ),
                        child: Text('Previous',
                            style: AppTextStyles.bodyMedium(color: AppColors.secondaryPurple)),
                      ),
                    ),
                  if (currentQuestionIndex > 0) SizedBox(width: responsive.spacingM),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: answers[questions[currentQuestionIndex]['key']] == null
                          ? null
                          : () {
                              if (currentQuestionIndex < questions.length - 1) {
                                setState(() {
                                  currentQuestionIndex++;
                                });
                              } else {
                                final likelihood = _calculateLikelihood();
                                setState(() {
                                  result = _getLikelihoodMessage(likelihood);
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryPurple,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: responsive.spacingM),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(responsive.radiusL),
                        ),
                      ),
                      child: Text(
                        currentQuestionIndex < questions.length - 1 ? 'Next' : 'Get Assessment',
                        style: AppTextStyles.buttonText(color: AppColors.white),
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

  Widget _buildOptionButton(
    Responsive responsive, {
    required String option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusL),
        child: Container(
          padding: responsive.paddingL,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondaryPurple : AppColors.white,
            borderRadius: BorderRadius.circular(responsive.radiusL),
            border: Border.all(
              color: isSelected ? AppColors.secondaryPurple : AppColors.lightGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: responsive.size(24),
                height: responsive.size(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.white : AppColors.lightGrey,
                  border: Border.all(
                    color: isSelected ? AppColors.white : AppColors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded,
                        color: AppColors.secondaryPurple, size: responsive.iconSize(16))
                    : null,
              ),
              SizedBox(width: responsive.spacingM),
              Expanded(
                child: Text(
                  option,
                  style: AppTextStyles.bodyMedium(
                    color: isSelected ? AppColors.white : AppColors.primaryDark,
                  ).copyWith(
                    fontSize: responsive.fontSize(15),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(Responsive responsive) {
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: responsive.paddingXL,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondaryPurple, AppColors.accentPurple],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(responsive.radiusXXL),
                  topRight: Radius.circular(responsive.radiusXXL),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Assessment Result',
                      style: AppTextStyles.headingSmall(color: AppColors.white).copyWith(
                        fontSize: responsive.fontSize(20),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: responsive.paddingXL,
                child: Text(
                  result!,
                  style: AppTextStyles.bodyMedium(color: AppColors.primaryDark).copyWith(
                    fontSize: responsive.fontSize(14),
                    height: 1.6,
                  ),
                ),
              ),
            ),
            Container(
              padding: responsive.paddingXL,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryPurple,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: responsive.spacingM),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(responsive.radiusL),
                  ),
                ),
                child: Text('Close', style: AppTextStyles.buttonText(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


