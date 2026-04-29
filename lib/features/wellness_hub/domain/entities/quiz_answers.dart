/// Domain entity for contraception quiz answers
class QuizAnswers {
  final bool hormonalOk; // Can use hormonal methods
  final bool dailyPillOk; // Can remember daily pill
  final bool longTermOk; // Prefers long-term method
  final bool discreetOk; // Needs discreet method
  final bool reversibleOk; // Wants reversible method
  final bool stdProtectionNeeded; // Needs STD protection

  QuizAnswers({
    required this.hormonalOk,
    required this.dailyPillOk,
    required this.longTermOk,
    required this.discreetOk,
    required this.reversibleOk,
    this.stdProtectionNeeded = false,
  });

  /// Convert to map for use case
  Map<String, dynamic> toMap() {
    return {
      'hormonal_ok': hormonalOk,
      'daily_pill_ok': dailyPillOk,
      'long_term': longTermOk,
      'discreet': discreetOk,
      'reversible': reversibleOk,
      'std_protection': stdProtectionNeeded,
    };
  }
}


