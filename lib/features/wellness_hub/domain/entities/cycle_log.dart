/// Domain entity for cycle log entries
class CycleLog {
  final String id;
  final DateTime date;
  final int flowIntensity; // 1-5
  final int painLevel; // 1-10
  final int energyLevel; // 1-10
  final List<String> symptoms; // e.g., 'Cramps', 'Bloating'
  final String? mood; // e.g., 'Happy', 'Anxious', 'Irritable'
  final List<String> physicalSymptoms; // e.g., 'irregular periods', 'acne', 'weight gain', 'pelvic pain', 'painful intercourse'
  final String? notes;

  CycleLog({
    required this.id,
    required this.date,
    required this.flowIntensity,
    required this.painLevel,
    required this.energyLevel,
    required this.symptoms,
    this.mood,
    this.physicalSymptoms = const [],
    this.notes,
  });

  CycleLog copyWith({
    String? id,
    DateTime? date,
    int? flowIntensity,
    int? painLevel,
    int? energyLevel,
    List<String>? symptoms,
    String? mood,
    List<String>? physicalSymptoms,
    String? notes,
  }) {
    return CycleLog(
      id: id ?? this.id,
      date: date ?? this.date,
      flowIntensity: flowIntensity ?? this.flowIntensity,
      painLevel: painLevel ?? this.painLevel,
      energyLevel: energyLevel ?? this.energyLevel,
      symptoms: symptoms ?? this.symptoms,
      mood: mood ?? this.mood,
      physicalSymptoms: physicalSymptoms ?? this.physicalSymptoms,
      notes: notes ?? this.notes,
    );
  }
}

