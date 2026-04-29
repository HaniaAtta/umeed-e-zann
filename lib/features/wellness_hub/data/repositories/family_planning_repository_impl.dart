import '../../domain/entities/quiz_result.dart';
import '../../domain/repositories/family_planning_repository.dart';
import '../datasources/family_planning_remote_datasource.dart';

/// Concrete implementation of FamilyPlanningRepository
class FamilyPlanningRepositoryImpl implements FamilyPlanningRepository {
  final FamilyPlanningRemoteDataSource _remoteDataSource;

  FamilyPlanningRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<QuizResult>> getQuizResults(String userId) async {
    try {
      final results = await _remoteDataSource.getQuizResults(userId);
      return results;
    } catch (e) {
      throw Exception('Failed to get quiz results: $e');
    }
  }

  @override
  Future<QuizResult?> getLatestQuizResult(String userId) async {
    try {
      final result = await _remoteDataSource.getLatestQuizResult(userId);
      return result;
    } catch (e) {
      throw Exception('Failed to get latest quiz result: $e');
    }
  }

  @override
  Future<void> saveQuizResult(String userId, QuizResult result) async {
    try {
      await _remoteDataSource.saveQuizResult(userId, result);
    } catch (e) {
      throw Exception('Failed to save quiz result: $e');
    }
  }

  @override
  Future<void> deleteQuizResult(String userId, String resultId) async {
    try {
      await _remoteDataSource.deleteQuizResult(userId, resultId);
    } catch (e) {
      throw Exception('Failed to delete quiz result: $e');
    }
  }
}


