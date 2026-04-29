/// Domain entity for pregnancy profile
class PregnancyProfile {
  final String userId;
  final DateTime dueDate;
  final DateTime? conceptionDate;
  final double? currentWeight; // in kg
  final String? notes;

  PregnancyProfile({
    required this.userId,
    required this.dueDate,
    this.conceptionDate,
    this.currentWeight,
    this.notes,
  });

  PregnancyProfile copyWith({
    String? userId,
    DateTime? dueDate,
    DateTime? conceptionDate,
    double? currentWeight,
    String? notes,
  }) {
    return PregnancyProfile(
      userId: userId ?? this.userId,
      dueDate: dueDate ?? this.dueDate,
      conceptionDate: conceptionDate ?? this.conceptionDate,
      currentWeight: currentWeight ?? this.currentWeight,
      notes: notes ?? this.notes,
    );
  }
}

