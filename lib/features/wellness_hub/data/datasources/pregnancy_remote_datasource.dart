import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pregnancy_profile_model.dart';
import '../models/appointment_model.dart';

/// Remote data source for pregnancy and appointment data from Firestore
class PregnancyRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get pregnancy profile for user
  Future<PregnancyProfileModel?> getPregnancyProfile(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wellness')
          .doc('pregnancy_profile')
          .get();

      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>;
      return PregnancyProfileModel.fromJson({...data, 'userId': userId});
    } catch (e) {
      throw Exception('Failed to get pregnancy profile: $e');
    }
  }

  /// Save pregnancy profile
  Future<void> savePregnancyProfile(PregnancyProfileModel profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.userId)
          .collection('wellness')
          .doc('pregnancy_profile')
          .set(profile.toJson());
    } catch (e) {
      throw Exception('Failed to save pregnancy profile: $e');
    }
  }

  /// Get appointments for user
  Future<List<AppointmentModel>> getAppointments(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .orderBy('date', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get appointments: $e');
    }
  }

  /// Get appointment by ID
  Future<AppointmentModel?> getAppointment(String userId, String appointmentId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (!doc.exists) return null;
      return AppointmentModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get appointment: $e');
    }
  }

  /// Get appointments stream for real-time updates
  Stream<List<AppointmentModel>> getAppointmentsStream(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .orderBy('date', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => AppointmentModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to get appointments stream: $e');
    }
  }

  /// Save appointment (create or update)
  Future<void> saveAppointment(String userId, AppointmentModel appointment) async {
    try {
      final appointmentData = appointment.toJson();
      appointmentData.remove('id'); // Remove id as Firestore generates it

      if (appointment.id.isEmpty) {
        // Create new appointment
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('appointments')
            .add(appointmentData);
      } else {
        // Update existing appointment
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('appointments')
            .doc(appointment.id)
            .set(appointmentData);
      }
    } catch (e) {
      throw Exception('Failed to save appointment: $e');
    }
  }

  /// Delete appointment
  Future<void> deleteAppointment(String userId, String appointmentId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .doc(appointmentId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete appointment: $e');
    }
  }
}


