import '../entities/course_progress_entity.dart';
import '../repositories/growth_repository.dart';

/// Use case to save quiz result
class SaveQuizResult {
  final GrowthRepository repository;

  SaveQuizResult(this.repository);

  Future<void> execute({
    required String userId,
    required String courseId,
    required QuizResultEntity quizResult,
  }) async {
    return await repository.saveQuizResult(
      userId: userId,
      courseId: courseId,
      quizResult: quizResult,
    );
  }
}

