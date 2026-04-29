import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../../../data/models/course_model.dart';
import '../../domain/repositories/growth_repository.dart';
import '../../data/repositories/growth_repository_impl.dart';
import '../../data/datasources/growth_remote_datasource.dart';
import '../../domain/usecases/get_course_progress.dart';
import '../../domain/usecases/save_course_progress.dart';
import '../../domain/usecases/bookmark_course.dart';
import '../../domain/usecases/unbookmark_course.dart';
import '../../domain/usecases/save_quiz_result.dart';
import '../../domain/usecases/get_certificates.dart';
import '../../domain/usecases/generate_certificate.dart';
import '../../domain/entities/course_progress_entity.dart';

/// Provider for Growth module (courses, progress, bookmarks)
class GrowthProvider with ChangeNotifier {
  final GrowthRepository _repository;
  
  // Use cases
  late final GetCourseProgress _getCourseProgress;
  late final SaveCourseProgress _saveCourseProgress;
  late final BookmarkCourse _bookmarkCourse;
  late final UnbookmarkCourse _unbookmarkCourse;
  late final SaveQuizResult _saveQuizResult;
  late final GetCertificates _getCertificates;
  late final GenerateCertificate _generateCertificate;

  // Courses list - populated from hardcoded data
  // List reference is never reassigned, so it can be final
  final List<Course> _courses = [];
  List<String> _bookmarkedCourseIds = [];
  final Map<String, CourseProgressEntity?> _courseProgress = {};
  List<CertificateEntity> _certificates = [];
  bool _isLoading = false;
  String? _error;

  // Stream subscriptions
  StreamSubscription<List<CourseProgressEntity>>? _progressSubscription;
  StreamSubscription<List<String>>? _bookmarksSubscription;

  List<Course> get courses => _courses;
  List<String> get bookmarkedCourseIds => _bookmarkedCourseIds;
  Map<String, CourseProgressEntity?> get courseProgress => _courseProgress;
  List<CertificateEntity> get certificates => _certificates;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  GrowthProvider()
      : _repository = GrowthRepositoryImpl(
          remoteDataSource: GrowthRemoteDataSourceImpl(),
        ) {
    _initializeUseCases();
  }

  void _initializeUseCases() {
    _getCourseProgress = GetCourseProgress(_repository);
    _saveCourseProgress = SaveCourseProgress(_repository);
    _bookmarkCourse = BookmarkCourse(_repository);
    _unbookmarkCourse = UnbookmarkCourse(_repository);
    _saveQuizResult = SaveQuizResult(_repository);
    _getCertificates = GetCertificates(_repository);
    _generateCertificate = GenerateCertificate(_repository);
  }

  @override
  void dispose() {
    _progressSubscription?.cancel();
    _bookmarksSubscription?.cancel();
    super.dispose();
  }

  /// Initialize - load bookmarks and progress streams
  Future<void> initialize() async {
    if (_userId == null) return;
    
    _setLoading(true);
    _error = null;

    try {
      // Load bookmarked courses stream
      _bookmarksSubscription = _repository
          .getBookmarkedCourseIds(_userId!)
          .listen((courseIds) {
        _bookmarkedCourseIds = courseIds;
        notifyListeners();
      });

      // Load all course progress stream
      _progressSubscription = _repository
          .getUserCourseProgress(_userId!)
          .listen((progressList) {
        _courseProgress.clear();
        for (var progress in progressList) {
          _courseProgress[progress.courseId] = progress;
        }
        notifyListeners();
      });

      // Load certificates
      await loadCertificates();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Check if course is bookmarked
  bool isBookmarked(String courseId) {
    return _bookmarkedCourseIds.contains(courseId);
  }

  /// Bookmark course
  Future<void> bookmarkCourse(String courseId) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _bookmarkCourse.execute(
        userId: _userId!,
        courseId: courseId,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Unbookmark course
  Future<void> unbookmarkCourse(String courseId) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _unbookmarkCourse.execute(
        userId: _userId!,
        courseId: courseId,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load course progress
  Future<void> loadCourseProgress(String courseId) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      final progress = await _getCourseProgress.execute(
        userId: _userId!,
        courseId: courseId,
      );
      _courseProgress[courseId] = progress;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Save course progress
  Future<void> saveCourseProgress({
    required String courseId,
    required List<String> completedVideoIds,
    required Map<String, Map<String, dynamic>> quizResults,
    required double overallProgress,
  }) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      // Convert quiz results to entities
      final quizResultEntities = <String, QuizResultEntity>{};
      quizResults.forEach((quizId, data) {
        quizResultEntities[quizId] = QuizResultEntity(
          quizId: quizId,
          score: data['score'] as int? ?? 0,
          totalQuestions: data['totalQuestions'] as int? ?? 0,
          correctAnswers: data['correctAnswers'] as int? ?? 0,
          passed: data['passed'] as bool? ?? false,
          completedAt: data['completedAt'] is DateTime
              ? data['completedAt'] as DateTime
              : DateTime.tryParse(data['completedAt'].toString()) ?? DateTime.now(),
        );
      });

      final progress = CourseProgressEntity(
        id: '${_userId!}_$courseId',
        userId: _userId!,
        courseId: courseId,
        completedVideoIds: completedVideoIds,
        quizResults: quizResultEntities,
        overallProgress: overallProgress,
        updatedAt: DateTime.now(),
      );

      await _saveCourseProgress.execute(progress);
      _courseProgress[courseId] = progress;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Save quiz result
  Future<void> saveQuizResult({
    required String courseId,
    required String quizId,
    required int score,
    required int totalQuestions,
    required int correctAnswers,
    required bool passed,
  }) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      final quizResult = QuizResultEntity(
        quizId: quizId,
        score: score,
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
        passed: passed,
        completedAt: DateTime.now(),
      );

      await _saveQuizResult.execute(
        userId: _userId!,
        courseId: courseId,
        quizResult: quizResult,
      );

      // Reload progress
      await loadCourseProgress(courseId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load certificates
  Future<void> loadCertificates() async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      _certificates = await _getCertificates.execute(_userId!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Generate certificate
  Future<CertificateEntity?> generateCertificate({
    required String courseId,
    required String courseTitle,
  }) async {
    if (_userId == null) return null;

    _setLoading(true);
    _error = null;

    try {
      final certificate = await _generateCertificate.execute(
        userId: _userId!,
        courseId: courseId,
        courseTitle: courseTitle,
      );
      await loadCertificates();
      return certificate;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Get progress for a course (helper method)
  CourseProgressEntity? getProgressForCourse(String courseId) {
    return _courseProgress[courseId];
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
