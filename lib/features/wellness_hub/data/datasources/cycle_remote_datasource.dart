import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cycle_log_model.dart';
import '../models/user_cycle_profile_model.dart';

/// Remote data source for cycle tracking data from Firestore
class CycleRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get cycle profile for user
  Future<UserCycleProfileModel?> getCycleProfile(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wellness')
          .doc('cycle_profile')
          .get();

      if (!doc.exists) return null;
      return UserCycleProfileModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get cycle profile: $e');
    }
  }

  /// Save cycle profile
  Future<void> saveCycleProfile(UserCycleProfileModel profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.userId)
          .collection('wellness')
          .doc('cycle_profile')
          .set(profile.toJson());
    } catch (e) {
      throw Exception('Failed to save cycle profile: $e');
    }
  }

  /// Get cycle logs for a date range
  Future<List<CycleLogModel>> getCycleLogs({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cycle_logs')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => CycleLogModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get cycle logs: $e');
    }
  }

  /// Get cycle logs stream for real-time updates
  Stream<List<CycleLogModel>> getCycleLogsStream({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('cycle_logs')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CycleLogModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to get cycle logs stream: $e');
    }
  }

  /// Save cycle log
  Future<void> saveCycleLog(String userId, CycleLogModel log) async {
    try {
      final logData = log.toJson();
      logData.remove('id'); // Remove id as Firestore generates it

      if (log.id.isEmpty) {
        // Create new log
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cycle_logs')
            .add(logData);
      } else {
        // Update existing log
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cycle_logs')
            .doc(log.id)
            .set(logData);
      }
    } catch (e) {
      throw Exception('Failed to save cycle log: $e');
    }
  }

  /// Delete cycle log
  Future<void> deleteCycleLog(String userId, String logId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cycle_logs')
          .doc(logId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete cycle log: $e');
    }
  }
}

