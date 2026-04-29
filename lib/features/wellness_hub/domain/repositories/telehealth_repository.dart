import '../entities/doctor.dart';
import '../entities/appointment_booking.dart';

/// Abstract repository for telehealth data
abstract class TeleHealthRepository {
  /// Get all available doctors
  Future<List<Doctor>> getDoctors();
  
  /// Get doctors by specialty
  Future<List<Doctor>> getDoctorsBySpecialty(String specialty);
  
  /// Get doctor by ID
  Future<Doctor?> getDoctor(String doctorId);
  
  /// Book appointment with doctor
  Future<void> bookAppointment(String userId, AppointmentBooking booking);
  
  /// Get user's appointments
  Future<List<AppointmentBooking>> getUserAppointments(String userId);
  
  /// Get appointments stream for real-time updates
  Stream<List<AppointmentBooking>> getUserAppointmentsStream(String userId);
  
  /// Cancel appointment
  Future<void> cancelAppointment(String userId, String bookingId);
}


