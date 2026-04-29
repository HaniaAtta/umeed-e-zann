import '../../domain/entities/pregnancy_profile.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/pregnancy_repository.dart';
import '../datasources/pregnancy_remote_datasource.dart';
import '../models/pregnancy_profile_model.dart';
import '../models/appointment_model.dart';

/// Concrete implementation of PregnancyRepository
class PregnancyRepositoryImpl implements PregnancyRepository {
  final PregnancyRemoteDataSource _remoteDataSource;

  PregnancyRepositoryImpl(this._remoteDataSource);

  @override
  Future<PregnancyProfile?> getPregnancyProfile(String userId) async {
    try {
      final profile = await _remoteDataSource.getPregnancyProfile(userId);
      return profile;
    } catch (e) {
      throw Exception('Failed to get pregnancy profile: $e');
    }
  }

  @override
  Future<void> savePregnancyProfile(PregnancyProfile profile) async {
    try {
      final model = PregnancyProfileModel.fromEntity(profile);
      await _remoteDataSource.savePregnancyProfile(model);
    } catch (e) {
      throw Exception('Failed to save pregnancy profile: $e');
    }
  }

  @override
  Future<List<Appointment>> getAppointments(String userId) async {
    try {
      final appointments = await _remoteDataSource.getAppointments(userId);
      return appointments;
    } catch (e) {
      throw Exception('Failed to get appointments: $e');
    }
  }

  @override
  Future<Appointment?> getAppointment(String userId, String appointmentId) async {
    try {
      final appointment = await _remoteDataSource.getAppointment(userId, appointmentId);
      return appointment;
    } catch (e) {
      throw Exception('Failed to get appointment: $e');
    }
  }

  @override
  Future<void> saveAppointment(String userId, Appointment appointment) async {
    try {
      final model = AppointmentModel.fromEntity(appointment);
      await _remoteDataSource.saveAppointment(userId, model);
    } catch (e) {
      throw Exception('Failed to save appointment: $e');
    }
  }

  @override
  Future<void> deleteAppointment(String userId, String appointmentId) async {
    try {
      await _remoteDataSource.deleteAppointment(userId, appointmentId);
    } catch (e) {
      throw Exception('Failed to delete appointment: $e');
    }
  }

  @override
  Stream<List<Appointment>> getAppointmentsStream(String userId) {
    try {
      return _remoteDataSource.getAppointmentsStream(userId)
          .map((models) => models.map<Appointment>((model) => model).toList());
    } catch (e) {
      throw Exception('Failed to get appointments stream: $e');
    }
  }
}


