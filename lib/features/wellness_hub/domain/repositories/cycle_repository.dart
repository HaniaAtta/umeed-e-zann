import '../entities/cycle_log.dart';
import '../entities/user_cycle_profile.dart';

/// Abstract repository for cycle tracking data
abstract class CycleRepository {
  /// Get cycle profile for user
  Future<UserCycleProfile?> getCycleProfile(String userId);
  
  /// Save cycle profile
  Future<void> saveCycleProfile(UserCycleProfile profile);
  
  /// Get cycle logs for a date range
  Future<List<CycleLog>> getCycleLogs({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });
  
  /// Save cycle log
  Future<void> saveCycleLog(String userId, CycleLog log);
  
  /// Delete cycle log
  Future<void> deleteCycleLog(String userId, String logId);
  
  /// Get cycle logs stream for real-time updates
  Stream<List<CycleLog>> getCycleLogsStream({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });
}

