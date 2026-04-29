/// Domain entity for contraception quiz result
class QuizResult {
  final String recommendedMethod;
  final double matchScore; // 0.0 to 1.0
  final Map<String, dynamic> userAnswers;
  final DateTime completedAt;
  final List<String> alternativeMethods; // Other suitable methods

  QuizResult({
    required this.recommendedMethod,
    required this.matchScore,
    required this.userAnswers,
    required this.completedAt,
    this.alternativeMethods = const [],
  });

  QuizResult copyWith({
    String? recommendedMethod,
    double? matchScore,
    Map<String, dynamic>? userAnswers,
    DateTime? completedAt,
    List<String>? alternativeMethods,
  }) {
    return QuizResult(
      recommendedMethod: recommendedMethod ?? this.recommendedMethod,
      matchScore: matchScore ?? this.matchScore,
      userAnswers: userAnswers ?? this.userAnswers,
      completedAt: completedAt ?? this.completedAt,
      alternativeMethods: alternativeMethods ?? this.alternativeMethods,
    );
  }
}

