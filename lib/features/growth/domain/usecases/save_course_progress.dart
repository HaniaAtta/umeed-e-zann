import '../entities/course_progress_entity.dart';
import '../repositories/growth_repository.dart';

/// Use case to save course progress
class SaveCourseProgress {
  final GrowthRepository repository;

  SaveCourseProgress(this.repository);

  Future<void> execute(CourseProgressEntity progress) async {
    return await repository.saveCourseProgress(progress);
  }
}

