import '../entities/ppd_log.dart';

/// Abstract repository for PPD log data
abstract class PPDRepository {
  /// Get PPD logs for user
  Future<List<PPDLog>> getPPDLogs(String userId);
  
  /// Get PPD log by ID
  Future<PPDLog?> getPPDLog(String userId, String logId);
  
  /// Save PPD log (create or update)
  Future<void> savePPDLog(String userId, PPDLog log);
  
  /// Delete PPD log
  Future<void> deletePPDLog(String userId, String logId);
  
  /// Get PPD logs stream for real-time updates
  Stream<List<PPDLog>> getPPDLogsStream(String userId);
}


