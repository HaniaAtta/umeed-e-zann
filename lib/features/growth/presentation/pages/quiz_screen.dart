import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../data/models/course_model.dart';
import '../viewmodels/growth_provider.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;
  final String? courseId; // Optional courseId for saving results

  const QuizScreen({super.key, required this.quiz, this.courseId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  final Map<int, bool> _showResult = {};
  bool _quizCompleted = false;
  int _correctAnswers = 0;

  QuizQuestion get _currentQuestion =>
      widget.quiz.questions[_currentQuestionIndex];

  bool get _isLastQuestion =>
      _currentQuestionIndex == widget.quiz.questions.length - 1;

  void _selectAnswer(int answerIndex) {
    // Prevent selecting if result already shown for this question
    if (_showResult[_currentQuestionIndex] == true) return;
    
    // Prevent selecting if answer already selected for this question
    if (_selectedAnswers.containsKey(_currentQuestionIndex)) return;

    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
      _showResult[_currentQuestionIndex] = true;
    });

    // Check if answer is correct
    if (answerIndex == _currentQuestion.correctAnswerIndex) {
      _correctAnswers++;
    }
  }

  void _completeQuiz() {
    setState(() {
      _quizCompleted = true;
    });
  }

  void _goToNextQuestion() {
    if (_isLastQuestion) {
      _completeQuiz();
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  QuizResult _calculateResult() {
    final score = (_correctAnswers / widget.quiz.questions.length * 100).round();
    final passed = score >= widget.quiz.passingScore;

    return QuizResult(
      quizId: widget.quiz.id,
      score: score,
      totalQuestions: widget.quiz.questions.length,
      correctAnswers: _correctAnswers,
      completedAt: DateTime.now(),
      passed: passed,
    );
  }

  Future<void> _saveQuizResult(QuizResult result) async {
    if (widget.courseId == null) return;
    
    final provider = Provider.of<GrowthProvider>(context, listen: false);
    try {
      await provider.saveQuizResult(
        courseId: widget.courseId!,
        quizId: result.quizId,
        score: result.score,
        totalQuestions: result.totalQuestions,
        correctAnswers: result.correctAnswers,
        passed: result.passed,
      );
    } catch (e) {
      debugPrint('Error saving quiz result: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      final result = _calculateResult();
      // Save result when quiz is completed
      _saveQuizResult(result);
      
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.quizResults,
          showLogo: true,
          showBackButton: true,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Result Icon
                Container(
                  width: context.responsive(120),
                  height: context.responsive(120),
                  decoration: BoxDecoration(
                    color: result.passed
                        ? AppColors.successColor
                        : AppColors.dangerColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    result.passed ? Icons.check_circle : Icons.cancel,
                    size: context.responsive(60),
                    color: AppColors.lightText,
                  ),
                ),
                SizedBox(height: ThemeHelper.spacingXL(context)),
                // Score
                Text(
                  '${result.score}%',
                  style: AppTextStyles.heading1(context).copyWith(
                    fontSize: context.responsive(64),
                    fontWeight: FontWeight.bold,
                    color: result.passed
                        ? AppColors.successColor
                        : AppColors.dangerColor,
                  ),
                ),
                SizedBox(height: ThemeHelper.spacingM(context)),
                // Result Text
                Text(
                  result.passed 
                      ? AppLocalizations.of(context)!.congratulations
                      : AppLocalizations.of(context)!.keepLearning,
                  style: AppTextStyles.heading2(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: ThemeHelper.spacingS(context)),
                Text(
                  AppLocalizations.of(context)!.quizScoreSummary(
                    result.correctAnswers.toString(),
                    result.totalQuestions.toString(),
                  ),
                  style: AppTextStyles.bodyMedium1(context).copyWith(
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!result.passed) ...[
                  SizedBox(height: ThemeHelper.spacingM(context)),
                  Text(
                    AppLocalizations.of(context)!.passingScoreText(widget.quiz.passingScore.toString()),
                    style: AppTextStyles.bodySmall1(context).copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
                SizedBox(height: ThemeHelper.spacingXL(context)),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.mediumPurple,
                            width: 2,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: ThemeHelper.spacingM(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(ThemeHelper.radiusM),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.backToCourse,
                          style: AppTextStyles.buttonMedium(context).copyWith(
                            color: AppColors.mediumPurple,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: ThemeHelper.spacingM(context)),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(result);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mediumPurple,
                          padding: EdgeInsets.symmetric(
                            vertical: ThemeHelper.spacingM(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(ThemeHelper.radiusM),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.continueText,
                          style: AppTextStyles.buttonMedium(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: widget.quiz.title,
        showLogo: true,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
            color: AppColors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.questionProgress(
                        (_currentQuestionIndex + 1).toString(),
                        widget.quiz.questions.length.toString(),
                      ),
                      style: AppTextStyles.bodyMedium1(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      '${((_currentQuestionIndex + 1) / widget.quiz.questions.length * 100).round()}%',
                      style: AppTextStyles.bodySmall1(context).copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ThemeHelper.spacingS(context)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(ThemeHelper.radiusS),
                  child: LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) /
                        widget.quiz.questions.length,
                    backgroundColor: AppColors.lightGrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.mediumPurple,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          // Question Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentQuestion.question,
                            style: AppTextStyles.heading4(context).copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                              fontSize: context.responsive(18),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.quiz.description.isNotEmpty) ...[
                            SizedBox(height: ThemeHelper.spacingM(context)),
                            Text(
                              widget.quiz.description,
                              style: AppTextStyles.bodyMedium1(context).copyWith(
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingM(context)),
                  // Answer Options
                  ..._currentQuestion.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected =
                        _selectedAnswers[_currentQuestionIndex] == index;
                    final isCorrect =
                        index == _currentQuestion.correctAnswerIndex;
                    final showResult = _showResult[_currentQuestionIndex] == true;

                    Color? cardColor;
                    if (showResult) {
                      if (isSelected && isCorrect) {
                        cardColor = AppColors.successColor.withValues(alpha: 0.2);
                      } else if (isSelected && !isCorrect) {
                        cardColor = AppColors.dangerColor.withValues(alpha: 0.2);
                      } else if (!isSelected && isCorrect) {
                        cardColor = AppColors.successColor.withValues(alpha: 0.1);
                      }
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: ThemeHelper.spacingM(context),
                      ),
                      child: InkWell(
                        onTap: () => _selectAnswer(index),
                        borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                        child: Card(
                          elevation: isSelected ? 4 : 2,
                          color: cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(ThemeHelper.radiusM),
                            side: isSelected
                                ? BorderSide(
                                    color: AppColors.mediumPurple,
                                    width: 2,
                                  )
                                : BorderSide.none,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                            child: Row(
                              children: [
                                Container(
                                  width: context.responsive(40),
                                  height: context.responsive(40),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.mediumPurple
                                        : AppColors.lightGrey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + index), // A, B, C, D
                                      style: AppTextStyles.bodyMedium1(context)
                                          .copyWith(
                                        color: isSelected
                                            ? AppColors.lightText
                                            : AppColors.secondaryText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ThemeHelper.spacingM(context)),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: AppTextStyles.bodyMedium1(context).copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ),
                                if (showResult) ...[
                                  if (isCorrect)
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.successColor,
                                    )
                                  else if (isSelected)
                                    Icon(
                                      Icons.cancel,
                                      color: AppColors.dangerColor,
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  // Explanation (if shown)
                  if (_showResult[_currentQuestionIndex] == true &&
                      _currentQuestion.explanation != null) ...[
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    Container(
                      padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                      decoration: BoxDecoration(
                        color: AppColors.mediumPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                        border: Border.all(
                          color: AppColors.mediumPurple.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.mediumPurple,
                          ),
                          SizedBox(width: ThemeHelper.spacingS(context)),
                          Expanded(
                            child: Text(
                              _currentQuestion.explanation!,
                              style: AppTextStyles.bodySmall1(context).copyWith(
                                color: AppColors.primaryText,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: Offset(context.responsive(0), context.responsive(-2)),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _goToPreviousQuestion,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.mediumPurple, width: 2),
                        padding: EdgeInsets.symmetric(
                          vertical: ThemeHelper.spacingM(context),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.previous,
                        style: AppTextStyles.buttonMedium(context).copyWith(
                          color: AppColors.mediumPurple,
                        ),
                      ),
                    ),
                  ),
                if (_currentQuestionIndex > 0)
                  SizedBox(width: ThemeHelper.spacingM(context)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedAnswers.containsKey(_currentQuestionIndex)
                        ? _goToNextQuestion
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mediumPurple,
                      padding: EdgeInsets.symmetric(
                        vertical: ThemeHelper.spacingM(context),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                      ),
                    ),
                    child: Text(
                      _isLastQuestion 
                          ? AppLocalizations.of(context)!.finishQuiz
                          : AppLocalizations.of(context)!.nextQuestion,
                      style: AppTextStyles.buttonMedium(context),
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
}
