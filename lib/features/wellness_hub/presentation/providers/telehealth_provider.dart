import 'package:flutter/foundation.dart';
import '../../../../data/services/auth_service.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/entities/appointment_booking.dart';
import '../../domain/repositories/telehealth_repository.dart';
import '../../data/repositories/telehealth_repository_impl.dart';
import '../../data/datasources/telehealth_remote_datasource.dart';

/// Provider for Tele-Health feature
class TeleHealthProvider with ChangeNotifier {
  final TeleHealthRepository _repository;
  final AuthService _authService = AuthService();

  TeleHealthProvider()
      : _repository = TeleHealthRepositoryImpl(TeleHealthRemoteDataSource());

  List<Doctor> _doctors = [];
  List<AppointmentBooking> _appointments = [];
  bool _isLoading = false;
  String? _error;

  List<Doctor> get doctors => _doctors;
  List<AppointmentBooking> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get current user ID
  String? get _userId => _authService.currentUser?.uid;

  /// Load all doctors
  Future<void> loadDoctors() async {
    _setLoading(true);
    _error = null;

    try {
      _doctors = await _repository.getDoctors();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Get doctors by specialty
  Future<void> loadDoctorsBySpecialty(String specialty) async {
    _setLoading(true);
    _error = null;

    try {
      _doctors = await _repository.getDoctorsBySpecialty(specialty);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Get doctor by ID
  Future<Doctor?> getDoctor(String doctorId) async {
    _setLoading(true);
    _error = null;

    try {
      final doctor = await _repository.getDoctor(doctorId);
      return doctor;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Book appointment with doctor
  Future<void> bookAppointment(String doctorId, DateTime dateTime, String type) async {
    if (_userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _error = null;

    try {
      final booking = AppointmentBooking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _userId!,
        doctorId: doctorId,
        dateTime: dateTime,
        type: type,
        status: 'pending',
      );

      await _repository.bookAppointment(_userId!, booking);
      await loadUserAppointments(); // Reload appointments
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load user appointments
  Future<void> loadUserAppointments() async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      _appointments = await _repository.getUserAppointments(_userId!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Get user appointments stream
  Stream<List<AppointmentBooking>> getUserAppointmentsStream() {
    if (_userId == null) return Stream.value([]);
    return _repository.getUserAppointmentsStream(_userId!);
  }

  /// Cancel appointment
  Future<void> cancelAppointment(String bookingId) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _repository.cancelAppointment(_userId!, bookingId);
      await loadUserAppointments(); // Reload
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}


