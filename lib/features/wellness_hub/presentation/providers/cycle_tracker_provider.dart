import 'package:flutter/foundation.dart';
import '../../../../data/services/auth_service.dart';
import '../../domain/entities/cycle_log.dart';
import '../../domain/entities/user_cycle_profile.dart';
import '../../domain/entities/cycle_phase.dart';
import '../../domain/repositories/cycle_repository.dart';
import '../../data/repositories/cycle_repository_impl.dart';
import '../../data/datasources/cycle_remote_datasource.dart';
import '../../domain/usecases/calculate_cycle_phase.dart';
import '../../domain/usecases/get_cycle_recommendations.dart' show GetCycleRecommendations, CycleRecommendation;
import '../../domain/usecases/generate_heatmap_data.dart';

/// Provider for Cycle Tracker feature
class CycleTrackerProvider with ChangeNotifier {
  final CycleRepository _repository;
  final CalculateCyclePhase _calculatePhase;
  final GetCycleRecommendations _getRecommendations;
  final GenerateHeatmapData _generateHeatmap;
  final AuthService _authService = AuthService();

  CycleTrackerProvider()
      : _repository = CycleRepositoryImpl(CycleRemoteDataSource()),
        _calculatePhase = CalculateCyclePhase(),
        _getRecommendations = GetCycleRecommendations(),
        _generateHeatmap = GenerateHeatmapData();

  UserCycleProfile? _cycleProfile;
  List<CycleLog> _cycleLogs = [];
  bool _isLoading = false;
  String? _error;

  UserCycleProfile? get cycleProfile => _cycleProfile;
  List<CycleLog> get cycleLogs => _cycleLogs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get current user ID
  String? get _userId => _authService.currentUser?.uid;

  /// Load cycle profile
  Future<void> loadCycleProfile() async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      _cycleProfile = await _repository.getCycleProfile(_userId!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Save cycle profile
  Future<void> saveCycleProfile(UserCycleProfile profile) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _repository.saveCycleProfile(profile);
      _cycleProfile = profile;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load cycle logs for date range
  Future<void> loadCycleLogs({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      _cycleLogs = await _repository.getCycleLogs(
        userId: _userId!,
        startDate: startDate,
        endDate: endDate,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Get cycle logs stream for real-time updates
  Stream<List<CycleLog>> getCycleLogsStream({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    if (_userId == null) return Stream.value([]);

    return _repository.getCycleLogsStream(
      userId: _userId!,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Save cycle log
  Future<void> saveCycleLog(CycleLog log) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _repository.saveCycleLog(_userId!, log);
      // Reload logs
      final now = DateTime.now();
      await loadCycleLogs(
        startDate: DateTime(now.year, now.month - 1, 1),
        endDate: DateTime(now.year, now.month + 1, 0),
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Delete cycle log
  Future<void> deleteCycleLog(String logId) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _repository.deleteCycleLog(_userId!, logId);
      _cycleLogs.removeWhere((log) => log.id == logId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Calculate current cycle phase
  CyclePhase? getCurrentPhase() {
    if (_cycleProfile?.lastPeriodDate == null) return null;
    return _calculatePhase.execute(
      currentDate: DateTime.now(),
      lastPeriodDate: _cycleProfile!.lastPeriodDate!,
      cycleLength: _cycleProfile!.averageCycleLength,
    );
  }

  /// Get cycle phase recommendations
  CycleRecommendation? getPhaseRecommendations() {
    final phase = getCurrentPhase();
    if (phase == null) return null;
    return _getRecommendations.execute(phase);
  }

  /// Generate heatmap data for pain level
  Map<DateTime, int> generatePainHeatmapData() {
    return _generateHeatmap.execute(
      logs: _cycleLogs,
      usePainLevel: true,
    );
  }

  /// Generate heatmap data for energy level
  Map<DateTime, int> generateEnergyHeatmapData() {
    return _generateHeatmap.execute(
      logs: _cycleLogs,
      usePainLevel: false,
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

