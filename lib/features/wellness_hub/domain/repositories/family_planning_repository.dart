import '../entities/quiz_result.dart';

/// Abstract repository for family planning quiz results
abstract class FamilyPlanningRepository {
  /// Get quiz results for user
  Future<List<QuizResult>> getQuizResults(String userId);
  
  /// Get latest quiz result for user
  Future<QuizResult?> getLatestQuizResult(String userId);
  
  /// Save quiz result
  Future<void> saveQuizResult(String userId, QuizResult result);
  
  /// Delete quiz result
  Future<void> deleteQuizResult(String userId, String resultId);
}


