import '../../domain/entities/ppd_log.dart';
import '../../domain/repositories/ppd_repository.dart';
import '../datasources/ppd_remote_datasource.dart';
import '../models/ppd_log_model.dart';

/// Concrete implementation of PPDRepository
class PPDRepositoryImpl implements PPDRepository {
  final PPDRemoteDataSource _remoteDataSource;

  PPDRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PPDLog>> getPPDLogs(String userId) async {
    try {
      final logs = await _remoteDataSource.getPPDLogs(userId);
      return logs;
    } catch (e) {
      throw Exception('Failed to get PPD logs: $e');
    }
  }

  @override
  Future<PPDLog?> getPPDLog(String userId, String logId) async {
    try {
      final log = await _remoteDataSource.getPPDLog(userId, logId);
      return log;
    } catch (e) {
      throw Exception('Failed to get PPD log: $e');
    }
  }

  @override
  Future<void> savePPDLog(String userId, PPDLog log) async {
    try {
      final model = PPDLogModel.fromEntity(log);
      await _remoteDataSource.savePPDLog(userId, model);
    } catch (e) {
      throw Exception('Failed to save PPD log: $e');
    }
  }

  @override
  Future<void> deletePPDLog(String userId, String logId) async {
    try {
      await _remoteDataSource.deletePPDLog(userId, logId);
    } catch (e) {
      throw Exception('Failed to delete PPD log: $e');
    }
  }

  @override
  Stream<List<PPDLog>> getPPDLogsStream(String userId) {
    try {
      return _remoteDataSource.getPPDLogsStream(userId)
          .map((models) => models.map<PPDLog>((model) => model).toList());
    } catch (e) {
      throw Exception('Failed to get PPD logs stream: $e');
    }
  }
}


