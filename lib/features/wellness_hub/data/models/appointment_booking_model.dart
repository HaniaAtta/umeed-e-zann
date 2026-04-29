import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/appointment_booking.dart';

/// Data Transfer Object for AppointmentBooking
class AppointmentBookingModel extends AppointmentBooking {
  AppointmentBookingModel({
    required super.id,
    required super.userId,
    required super.doctorId,
    required super.dateTime,
    required super.type,
    super.notes,
    super.status,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'dateTime': Timestamp.fromDate(dateTime),
      'type': type,
      'notes': notes,
      'status': status,
    };
  }

  /// Create from Firestore document
  factory AppointmentBookingModel.fromJson(Map<String, dynamic> json) {
    return AppointmentBookingModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      doctorId: json['doctorId'] as String? ?? '',
      dateTime: (json['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: json['type'] as String? ?? 'chat',
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'pending',
    );
  }

  /// Create from Firestore document snapshot
  factory AppointmentBookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentBookingModel.fromJson({...data, 'id': doc.id});
  }

  /// Convert domain entity to model
  factory AppointmentBookingModel.fromEntity(AppointmentBooking booking) {
    return AppointmentBookingModel(
      id: booking.id,
      userId: booking.userId,
      doctorId: booking.doctorId,
      dateTime: booking.dateTime,
      type: booking.type,
      notes: booking.notes,
      status: booking.status,
    );
  }
}


