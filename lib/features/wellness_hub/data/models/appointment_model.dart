import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/appointment.dart';

/// Data Transfer Object for Appointment
class AppointmentModel extends Appointment {
  AppointmentModel({
    required super.id,
    required super.userId,
    required super.doctorName,
    required super.date,
    required super.type,
    super.notes,
    super.location,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorName': doctorName,
      'date': Timestamp.fromDate(date),
      'type': type,
      'notes': notes,
      'location': location,
    };
  }

  /// Create from Firestore document
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String? ?? json['id'] ?? '',
      userId: json['userId'] as String,
      doctorName: json['doctorName'] as String,
      date: (json['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: json['type'] as String,
      notes: json['notes'] as String?,
      location: json['location'] as String?,
    );
  }

  /// Create from Firestore document snapshot
  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel.fromJson({...data, 'id': doc.id});
  }

  /// Convert domain entity to model
  factory AppointmentModel.fromEntity(Appointment appointment) {
    return AppointmentModel(
      id: appointment.id,
      userId: appointment.userId,
      doctorName: appointment.doctorName,
      date: appointment.date,
      type: appointment.type,
      notes: appointment.notes,
      location: appointment.location,
    );
  }
}

