/// Domain entity for medical appointment
class Appointment {
  final String id;
  final String userId;
  final String doctorName;
  final DateTime date;
  final String type; // 'Checkup', 'Ultrasound', etc.
  final String? notes;
  final String? location;

  Appointment({
    required this.id,
    required this.userId,
    required this.doctorName,
    required this.date,
    required this.type,
    this.notes,
    this.location,
  });

  Appointment copyWith({
    String? id,
    String? userId,
    String? doctorName,
    DateTime? date,
    String? type,
    String? notes,
    String? location,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorName: doctorName ?? this.doctorName,
      date: date ?? this.date,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      location: location ?? this.location,
    );
  }
}

