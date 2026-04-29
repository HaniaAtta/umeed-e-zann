import '../repositories/growth_repository.dart';

/// Use case to bookmark a course
class BookmarkCourse {
  final GrowthRepository repository;

  BookmarkCourse(this.repository);

  Future<void> execute({
    required String userId,
    required String courseId,
  }) async {
    return await repository.bookmarkCourse(
      userId: userId,
      courseId: courseId,
    );
  }
}

