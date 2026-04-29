import '../../domain/entities/course_progress_entity.dart';
import '../../domain/repositories/growth_repository.dart';
import '../datasources/growth_remote_datasource.dart';
import '../models/course_progress_model.dart';

/// Repository implementation for Growth module
class GrowthRepositoryImpl implements GrowthRepository {
  final GrowthRemoteDataSource remoteDataSource;

  GrowthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CourseProgressEntity?> getCourseProgress({
    required String userId,
    required String courseId,
  }) async {
    try {
      final progress = await remoteDataSource.getCourseProgress(
        userId: userId,
        courseId: courseId,
      );
      return progress?.toEntity();
    } catch (e) {
      throw Exception('Failed to get course progress: $e');
    }
  }

  @override
  Stream<List<CourseProgressEntity>> getUserCourseProgress(String userId) {
    try {
      return remoteDataSource.getUserCourseProgress(userId).map(
        (models) => models.map((model) => model.toEntity()).toList(),
      );
    } catch (e) {
      throw Exception('Failed to get user course progress: $e');
    }
  }

  @override
  Future<void> saveCourseProgress(CourseProgressEntity progress) async {
    try {
      final model = CourseProgressModel.fromEntity(progress);
      await remoteDataSource.saveCourseProgress(model);
    } catch (e) {
      throw Exception('Failed to save course progress: $e');
    }
  }

  @override
  Future<void> bookmarkCourse({
    required String userId,
    required String courseId,
  }) async {
    try {
      await remoteDataSource.bookmarkCourse(
        userId: userId,
        courseId: courseId,
      );
    } catch (e) {
      throw Exception('Failed to bookmark course: $e');
    }
  }

  @override
  Future<void> unbookmarkCourse({
    required String userId,
    required String courseId,
  }) async {
    try {
      await remoteDataSource.unbookmarkCourse(
        userId: userId,
        courseId: courseId,
      );
    } catch (e) {
      throw Exception('Failed to unbookmark course: $e');
    }
  }

  @override
  Stream<List<String>> getBookmarkedCourseIds(String userId) {
    try {
      return remoteDataSource.getBookmarkedCourseIds(userId);
    } catch (e) {
      throw Exception('Failed to get bookmarked course IDs: $e');
    }
  }

  @override
  Future<bool> isCourseBookmarked({
    required String userId,
    required String courseId,
  }) async {
    try {
      return await remoteDataSource.isCourseBookmarked(
        userId: userId,
        courseId: courseId,
      );
    } catch (e) {
      throw Exception('Failed to check bookmark status: $e');
    }
  }

  @override
  Future<void> saveQuizResult({
    required String userId,
    required String courseId,
    required QuizResultEntity quizResult,
  }) async {
    try {
      await remoteDataSource.saveQuizResult(
        userId: userId,
        courseId: courseId,
        quizResult: quizResult,
      );
    } catch (e) {
      throw Exception('Failed to save quiz result: $e');
    }
  }

  @override
  Future<List<CertificateEntity>> getCertificates(String userId) async {
    try {
      final certificates = await remoteDataSource.getCertificates(userId);
      return certificates.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get certificates: $e');
    }
  }

  @override
  Future<CertificateEntity> generateCertificate({
    required String userId,
    required String courseId,
    required String courseTitle,
  }) async {
    try {
      final certificate = await remoteDataSource.generateCertificate(
        userId: userId,
        courseId: courseId,
        courseTitle: courseTitle,
      );
      return certificate.toEntity();
    } catch (e) {
      throw Exception('Failed to generate certificate: $e');
    }
  }
}

