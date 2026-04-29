import '../entities/quiz_answers.dart';
import '../entities/contraceptive_method.dart';
import '../services/contraception_matcher.dart';
import '../entities/quiz_result.dart';

/// Use case to match user quiz answers with contraceptive methods
class MatchContraceptiveUseCase {
  final ContraceptionMatcher _matcher = ContraceptionMatcher();

  /// Execute matching based on quiz answers
  /// Returns ContraceptiveMethod with name, efficacy, and why_it_fits
  ContraceptiveMethod execute(QuizAnswers answers) {
    final userAnswersMap = answers.toMap();
    final result = _matcher.matchMethod(userAnswersMap);

    // Get why it fits explanation
    final whyItFits = _getWhyItFits(result, answers);

    return ContraceptiveMethod(
      name: result.recommendedMethod,
      efficacy: _getEfficacyForMethod(result.recommendedMethod),
      whyItFits: whyItFits,
    );
  }

  /// Get efficacy for a method
  double _getEfficacyForMethod(String methodName) {
    final methods = ContraceptionMatcher.getAllMethods();
    final method = methods.firstWhere(
      (m) => m.name == methodName,
      orElse: () => methods.first,
    );
    return method.effectiveness;
  }

  /// Generate explanation of why this method fits
  String _getWhyItFits(QuizResult result, QuizAnswers answers) {
    final methodName = result.recommendedMethod;
    final reasons = <String>[];

    // Analyze why this method fits based on answers
    if (methodName == 'Birth Control Pill') {
      if (answers.hormonalOk) {
        reasons.add('You\'re comfortable with hormonal methods');
      }
      if (answers.dailyPillOk) {
        reasons.add('You can commit to taking a daily pill');
      }
      if (answers.reversibleOk) {
        reasons.add('It\'s easily reversible when you want to conceive');
      }
      reasons.add('Highly effective (${(result.matchScore * 100).toInt()}% match)');
    } else if (methodName == 'IUD (Intrauterine Device)') {
      if (answers.longTermOk) {
        reasons.add('You prefer a long-term solution (3-10 years)');
      }
      if (answers.discreetOk) {
        reasons.add('It\'s completely discreet - no one will know');
      }
      if (answers.reversibleOk) {
        reasons.add('Fully reversible when you\'re ready');
      }
      reasons.add('Highest effectiveness (${(result.matchScore * 100).toInt()}% match)');
    } else if (methodName == 'Condom') {
      if (!answers.hormonalOk) {
        reasons.add('Non-hormonal option - no side effects');
      }
      if (answers.stdProtectionNeeded) {
        reasons.add('Provides protection against STIs');
      }
      if (!answers.longTermOk) {
        reasons.add('Flexible - use only when needed');
      }
      reasons.add('Good match for your preferences (${(result.matchScore * 100).toInt()}% match)');
    } else if (methodName == 'Implant') {
      if (answers.longTermOk) {
        reasons.add('Long-lasting protection (3-5 years)');
      }
      if (answers.discreetOk) {
        reasons.add('Completely discreet');
      }
      if (answers.hormonalOk) {
        reasons.add('Hormonal method that suits you');
      }
      reasons.add('Excellent effectiveness (${(result.matchScore * 100).toInt()}% match)');
    } else if (methodName == 'Depo Shot') {
      if (answers.hormonalOk) {
        reasons.add('Hormonal method that works for you');
      }
      if (!answers.dailyPillOk) {
        reasons.add('No daily commitment - just quarterly shots');
      }
      if (answers.discreetOk) {
        reasons.add('Discreet and private');
      }
      reasons.add('Strong match (${(result.matchScore * 100).toInt()}% match)');
    } else if (methodName == 'Natural Family Planning') {
      if (!answers.hormonalOk) {
        reasons.add('Completely natural - no hormones');
      }
      if (answers.discreetOk) {
        reasons.add('Completely private');
      }
      reasons.add('Good option if you can track consistently (${(result.matchScore * 100).toInt()}% match)');
    }

    if (reasons.isEmpty) {
      return 'This method matches your preferences with a ${(result.matchScore * 100).toInt()}% compatibility score.';
    }

    return '${reasons.join('. ')}.';
  }
}


