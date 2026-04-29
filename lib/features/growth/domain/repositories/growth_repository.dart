import '../entities/course_progress_entity.dart';

/// Abstract repository interface for growth operations
abstract class GrowthRepository {
  /// Get course progress for a user
  Future<CourseProgressEntity?> getCourseProgress({
    required String userId,
    required String courseId,
  });

  /// Get all course progress for a user (stream)
  Stream<List<CourseProgressEntity>> getUserCourseProgress(String userId);

  /// Save course progress
  Future<void> saveCourseProgress(CourseProgressEntity progress);

  /// Bookmark a course
  Future<void> bookmarkCourse({
    required String userId,
    required String courseId,
  });

  /// Unbookmark a course
  Future<void> unbookmarkCourse({
    required String userId,
    required String courseId,
  });

  /// Get bookmarked course IDs (stream)
  Stream<List<String>> getBookmarkedCourseIds(String userId);

  /// Check if course is bookmarked
  Future<bool> isCourseBookmarked({
    required String userId,
    required String courseId,
  });

  /// Save quiz result
  Future<void> saveQuizResult({
    required String userId,
    required String courseId,
    required QuizResultEntity quizResult,
  });

  /// Get certificates for a user
  Future<List<CertificateEntity>> getCertificates(String userId);

  /// Generate and save certificate
  Future<CertificateEntity> generateCertificate({
    required String userId,
    required String courseId,
    required String courseTitle,
  });
}

