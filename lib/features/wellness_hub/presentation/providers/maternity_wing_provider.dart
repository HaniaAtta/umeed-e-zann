import 'package:flutter/foundation.dart';
import '../../../../data/services/auth_service.dart';
import '../../domain/entities/pregnancy_profile.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/ppd_log.dart';
import '../../domain/repositories/pregnancy_repository.dart';
import '../../domain/repositories/ppd_repository.dart';
import '../../data/repositories/pregnancy_repository_impl.dart';
import '../../data/repositories/ppd_repository_impl.dart';
import '../../data/datasources/pregnancy_remote_datasource.dart';
import '../../data/datasources/ppd_remote_datasource.dart';
import '../../domain/usecases/calculate_pregnancy_week.dart';
import '../../domain/usecases/get_baby_size_reference.dart';
import '../../domain/usecases/calculate_ppd_score.dart';

/// Provider for Maternity Wing feature (Pregnancy & Post-Partum)
class MaternityWingProvider with ChangeNotifier {
  final PregnancyRepository _pregnancyRepository;
  final PPDRepository _ppdRepository;
  final CalculatePregnancyWeek _calculateWeek;
  final GetBabySizeReference _getBabySize;
  final CalculatePPDScore _calculatePPD;
  final AuthService _authService = AuthService();

  MaternityWingProvider()
      : _pregnancyRepository = PregnancyRepositoryImpl(PregnancyRemoteDataSource()),
        _ppdRepository = PPDRepositoryImpl(PPDRemoteDataSource()),
        _calculateWeek = CalculatePregnancyWeek(),
        _getBabySize = GetBabySizeReference(),
        _calculatePPD = CalculatePPDScore();

  PregnancyProfile? _pregnancyProfile;
  List<Appointment> _appointments = [];
  List<PPDLog> _ppdLogs = [];
  bool _isLoading = false;
  String? _error;

  PregnancyProfile? get pregnancyProfile => _pregnancyProfile;
  List<Appointment> get appointments => _appointments;
  List<PPDLog> get ppdLogs => _ppdLogs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get current user ID
  String? get _userId => _authService.currentUser?.uid;

  // ========== PREGNANCY PROFILE ==========

  /// Load pregnancy profile
  Future<void> loadPregnancyProfile() async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      _pregnancyProfile = await _pregnancyRepository.getPregnancyProfile(_userId!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Save pregnancy profile
  Future<void> savePregnancyProfile(PregnancyProfile profile) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _pregnancyRepository.savePregnancyProfile(profile);
      _pregnancyProfile = profile;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Calculate current pregnancy week
  int? getCurrentWeek() {
    if (_pregnancyProfile == null) return null;
    return _calculateWeek.execute(_pregnancyProfile!.dueDate);
  }

  /// Get baby size reference
  String? getBabySizeReference() {
    final week = getCurrentWeek();
    if (week == null) return null;
    return _getBabySize.execute(week);
  }

  // ========== APPOINTMENTS ==========

  /// Load appointments
  Future<void> loadAppointments() async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      _appointments = await _pregnancyRepository.getAppointments(_userId!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Get appointments stream for real-time updates
  Stream<List<Appointment>> getAppointmentsStream() {
    if (_userId == null) return Stream.value([]);
    return _pregnancyRepository.getAppointmentsStream(_userId!);
  }

  /// Save appointment (create or update)
  Future<void> saveAppointment(Appointment appointment) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _pregnancyRepository.saveAppointment(_userId!, appointment);
      await loadAppointments(); // Reload
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Delete appointment
  Future<void> deleteAppointment(String appointmentId) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _pregnancyRepository.deleteAppointment(_userId!, appointmentId);
      _appointments.removeWhere((apt) => apt.id == appointmentId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ========== PPD LOGS ==========

  /// Load PPD logs
  Future<void> loadPPDLogs() async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      _ppdLogs = await _ppdRepository.getPPDLogs(_userId!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Get PPD logs stream for real-time updates
  Stream<List<PPDLog>> getPPDLogsStream() {
    if (_userId == null) return Stream.value([]);
    return _ppdRepository.getPPDLogsStream(_userId!);
  }

  /// Calculate PPD score from answers
  int calculatePPDScore(Map<String, int> answers) {
    return _calculatePPD.execute(answers);
  }

  /// Get PPD recommendations based on score
  List<String> getPPDRecommendations(int score) {
    return _calculatePPD.getRecommendations(score);
  }

  /// Save PPD log
  Future<void> savePPDLog(PPDLog log) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _ppdRepository.savePPDLog(_userId!, log);
      await loadPPDLogs(); // Reload
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Delete PPD log
  Future<void> deletePPDLog(String logId) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _ppdRepository.deletePPDLog(_userId!, logId);
      _ppdLogs.removeWhere((log) => log.id == logId);
      notifyListeners();
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

