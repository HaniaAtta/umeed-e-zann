/// Domain entity for appointment booking
class AppointmentBooking {
  final String id;
  final String userId;
  final String doctorId;
  final DateTime dateTime;
  final String type; // 'chat', 'video'
  final String? notes;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'

  AppointmentBooking({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.dateTime,
    required this.type,
    this.notes,
    this.status = 'pending',
  });

  AppointmentBooking copyWith({
    String? id,
    String? userId,
    String? doctorId,
    DateTime? dateTime,
    String? type,
    String? notes,
    String? status,
  }) {
    return AppointmentBooking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      dateTime: dateTime ?? this.dateTime,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}


