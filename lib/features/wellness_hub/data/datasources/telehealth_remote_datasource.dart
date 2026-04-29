import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/entities/appointment_booking.dart';
import '../models/doctor_model.dart';
import '../models/appointment_booking_model.dart';

/// Remote data source for telehealth (Firestore)
class TeleHealthRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String doctorsCollection = 'doctors';
  static const String appointmentsCollection = 'appointments';

  /// Get all doctors from Firestore
  Future<List<Doctor>> getDoctors() async {
    try {
      final snapshot = await _firestore.collection(doctorsCollection).get();
      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch doctors: $e');
    }
  }

  /// Get doctors by specialty
  Future<List<Doctor>> getDoctorsBySpecialty(String specialty) async {
    try {
      final snapshot = await _firestore
          .collection(doctorsCollection)
          .where('specialty', isEqualTo: specialty)
          .get();
      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch doctors by specialty: $e');
    }
  }

  /// Get doctor by ID
  Future<Doctor?> getDoctor(String doctorId) async {
    try {
      final doc = await _firestore
          .collection(doctorsCollection)
          .doc(doctorId)
          .get();
      if (!doc.exists) return null;
      return DoctorModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch doctor: $e');
    }
  }

  /// Book appointment
  Future<void> bookAppointment(String userId, AppointmentBooking booking) async {
    try {
      final bookingModel = AppointmentBookingModel.fromEntity(booking);
      await _firestore
          .collection(appointmentsCollection)
          .doc(booking.id)
          .set(bookingModel.toJson());
    } catch (e) {
      throw Exception('Failed to book appointment: $e');
    }
  }

  /// Get user appointments
  Future<List<AppointmentBooking>> getUserAppointments(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(appointmentsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('dateTime', descending: false)
          .get();
      return snapshot.docs
          .map((doc) => AppointmentBookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user appointments: $e');
    }
  }

  /// Get user appointments stream
  Stream<List<AppointmentBooking>> getUserAppointmentsStream(String userId) {
    return _firestore
        .collection(appointmentsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppointmentBookingModel.fromFirestore(doc))
            .toList());
  }

  /// Cancel appointment
  Future<void> cancelAppointment(String userId, String bookingId) async {
    try {
      await _firestore
          .collection(appointmentsCollection)
          .doc(bookingId)
          .update({'status': 'cancelled'});
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }
}


