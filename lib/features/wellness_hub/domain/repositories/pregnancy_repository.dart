import '../entities/pregnancy_profile.dart';
import '../entities/appointment.dart';

/// Abstract repository for pregnancy and appointment data
abstract class PregnancyRepository {
  /// Get pregnancy profile for user
  Future<PregnancyProfile?> getPregnancyProfile(String userId);
  
  /// Save pregnancy profile
  Future<void> savePregnancyProfile(PregnancyProfile profile);
  
  /// Get appointments for user
  Future<List<Appointment>> getAppointments(String userId);
  
  /// Get appointment by ID
  Future<Appointment?> getAppointment(String userId, String appointmentId);
  
  /// Save appointment (create or update)
  Future<void> saveAppointment(String userId, Appointment appointment);
  
  /// Delete appointment
  Future<void> deleteAppointment(String userId, String appointmentId);
  
  /// Get appointments stream for real-time updates
  Stream<List<Appointment>> getAppointmentsStream(String userId);
}


