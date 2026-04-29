import '../../domain/repositories/telehealth_repository.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/entities/appointment_booking.dart';
import '../datasources/telehealth_remote_datasource.dart';

/// Implementation of TeleHealthRepository
class TeleHealthRepositoryImpl implements TeleHealthRepository {
  final TeleHealthRemoteDataSource _dataSource;

  TeleHealthRepositoryImpl(this._dataSource);

  @override
  Future<List<Doctor>> getDoctors() async {
    return await _dataSource.getDoctors();
  }

  @override
  Future<List<Doctor>> getDoctorsBySpecialty(String specialty) async {
    return await _dataSource.getDoctorsBySpecialty(specialty);
  }

  @override
  Future<Doctor?> getDoctor(String doctorId) async {
    return await _dataSource.getDoctor(doctorId);
  }

  @override
  Future<void> bookAppointment(String userId, AppointmentBooking booking) async {
    return await _dataSource.bookAppointment(userId, booking);
  }

  @override
  Future<List<AppointmentBooking>> getUserAppointments(String userId) async {
    return await _dataSource.getUserAppointments(userId);
  }

  @override
  Stream<List<AppointmentBooking>> getUserAppointmentsStream(String userId) {
    return _dataSource.getUserAppointmentsStream(userId);
  }

  @override
  Future<void> cancelAppointment(String userId, String bookingId) async {
    return await _dataSource.cancelAppointment(userId, bookingId);
  }
}


