/// Domain entity for Post-Partum Depression log
class PPDLog {
  final String id;
  final String userId;
  final DateTime date;
  final int score; // Total Edinburgh Scale score
  final String mood; // e.g., 'Anxious', 'Sad', 'Happy'
  final Map<String, int> answers; // Question -> Answer (0-3)
  final String? notes;

  PPDLog({
    required this.id,
    required this.userId,
    required this.date,
    required this.score,
    required this.mood,
    required this.answers,
    this.notes,
  });

  /// Check if score indicates need for professional consultation
  bool get needsConsultation => score > 13; // Edinburgh Scale threshold

  PPDLog copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? score,
    String? mood,
    Map<String, int>? answers,
    String? notes,
  }) {
    return PPDLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      score: score ?? this.score,
      mood: mood ?? this.mood,
      answers: answers ?? this.answers,
      notes: notes ?? this.notes,
    );
  }
}

