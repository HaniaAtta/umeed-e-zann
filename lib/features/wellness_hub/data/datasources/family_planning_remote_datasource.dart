import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/quiz_result.dart';

/// Remote data source for family planning quiz results from Firestore
class FamilyPlanningRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get quiz results for user
  Future<List<QuizResult>> getQuizResults(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('family_planning_results')
          .orderBy('completedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => _quizResultFromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get quiz results: $e');
    }
  }

  /// Get latest quiz result for user
  Future<QuizResult?> getLatestQuizResult(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('family_planning_results')
          .orderBy('completedAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return _quizResultFromFirestore(snapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get latest quiz result: $e');
    }
  }

  /// Save quiz result
  Future<void> saveQuizResult(String userId, QuizResult result) async {
    try {
      final resultData = {
        'recommendedMethod': result.recommendedMethod,
        'matchScore': result.matchScore,
        'userAnswers': result.userAnswers,
        'completedAt': Timestamp.fromDate(result.completedAt),
        'alternativeMethods': result.alternativeMethods,
      };

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('family_planning_results')
          .add(resultData);
    } catch (e) {
      throw Exception('Failed to save quiz result: $e');
    }
  }

  /// Delete quiz result
  Future<void> deleteQuizResult(String userId, String resultId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('family_planning_results')
          .doc(resultId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete quiz result: $e');
    }
  }

  /// Convert Firestore document to QuizResult
  QuizResult _quizResultFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizResult(
      recommendedMethod: data['recommendedMethod'] as String? ?? '',
      matchScore: (data['matchScore'] as num?)?.toDouble() ?? 0.0,
      userAnswers: Map<String, dynamic>.from(data['userAnswers'] as Map? ?? {}),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      alternativeMethods: List<String>.from(data['alternativeMethods'] as List? ?? []),
    );
  }
}


