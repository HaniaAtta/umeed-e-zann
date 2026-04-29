import '../../domain/entities/cycle_log.dart';
import '../../domain/entities/user_cycle_profile.dart';
import '../../domain/repositories/cycle_repository.dart';
import '../datasources/cycle_remote_datasource.dart';
import '../models/cycle_log_model.dart';
import '../models/user_cycle_profile_model.dart';

/// Concrete implementation of CycleRepository
class CycleRepositoryImpl implements CycleRepository {
  final CycleRemoteDataSource _remoteDataSource;

  CycleRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserCycleProfile?> getCycleProfile(String userId) async {
    try {
      final profile = await _remoteDataSource.getCycleProfile(userId);
      return profile;
    } catch (e) {
      throw Exception('Failed to get cycle profile: $e');
    }
  }

  @override
  Future<void> saveCycleProfile(UserCycleProfile profile) async {
    try {
      final model = UserCycleProfileModel.fromEntity(profile);
      await _remoteDataSource.saveCycleProfile(model);
    } catch (e) {
      throw Exception('Failed to save cycle profile: $e');
    }
  }

  @override
  Future<List<CycleLog>> getCycleLogs({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final logs = await _remoteDataSource.getCycleLogs(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      return logs;
    } catch (e) {
      throw Exception('Failed to get cycle logs: $e');
    }
  }

  @override
  Stream<List<CycleLog>> getCycleLogsStream({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    try {
      return _remoteDataSource.getCycleLogsStream(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      ).map((models) => models.map<CycleLog>((model) => model).toList());
    } catch (e) {
      throw Exception('Failed to get cycle logs stream: $e');
    }
  }

  @override
  Future<void> saveCycleLog(String userId, CycleLog log) async {
    try {
      final model = CycleLogModel.fromEntity(log);
      await _remoteDataSource.saveCycleLog(userId, model);
    } catch (e) {
      throw Exception('Failed to save cycle log: $e');
    }
  }

  @override
  Future<void> deleteCycleLog(String userId, String logId) async {
    try {
      await _remoteDataSource.deleteCycleLog(userId, logId);
    } catch (e) {
      throw Exception('Failed to delete cycle log: $e');
    }
  }
}

