import '../entities/course_progress_entity.dart';
import '../repositories/growth_repository.dart';

/// Use case to get course progress
class GetCourseProgress {
  final GrowthRepository repository;

  GetCourseProgress(this.repository);

  Future<CourseProgressEntity?> execute({
    required String userId,
    required String courseId,
  }) async {
    return await repository.getCourseProgress(
      userId: userId,
      courseId: courseId,
    );
  }
}

