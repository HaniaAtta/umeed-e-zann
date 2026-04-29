import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ppd_log_model.dart';

/// Remote data source for PPD log data from Firestore
class PPDRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get PPD logs for user
  Future<List<PPDLogModel>> getPPDLogs(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('ppd_logs')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PPDLogModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get PPD logs: $e');
    }
  }

  /// Get PPD log by ID
  Future<PPDLogModel?> getPPDLog(String userId, String logId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('ppd_logs')
          .doc(logId)
          .get();

      if (!doc.exists) return null;
      return PPDLogModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get PPD log: $e');
    }
  }

  /// Get PPD logs stream for real-time updates
  Stream<List<PPDLogModel>> getPPDLogsStream(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('ppd_logs')
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => PPDLogModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to get PPD logs stream: $e');
    }
  }

  /// Save PPD log (create or update)
  Future<void> savePPDLog(String userId, PPDLogModel log) async {
    try {
      final logData = log.toJson();
      logData.remove('id'); // Remove id as Firestore generates it

      if (log.id.isEmpty) {
        // Create new log
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('ppd_logs')
            .add(logData);
      } else {
        // Update existing log
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('ppd_logs')
            .doc(log.id)
            .set(logData);
      }
    } catch (e) {
      throw Exception('Failed to save PPD log: $e');
    }
  }

  /// Delete PPD log
  Future<void> deletePPDLog(String userId, String logId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('ppd_logs')
          .doc(logId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete PPD log: $e');
    }
  }
}


