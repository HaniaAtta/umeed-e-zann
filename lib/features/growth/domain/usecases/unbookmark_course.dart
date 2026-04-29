import '../repositories/growth_repository.dart';

/// Use case to unbookmark a course
class UnbookmarkCourse {
  final GrowthRepository repository;

  UnbookmarkCourse(this.repository);

  Future<void> execute({
    required String userId,
    required String courseId,
  }) async {
    return await repository.unbookmarkCourse(
      userId: userId,
      courseId: courseId,
    );
  }
}

