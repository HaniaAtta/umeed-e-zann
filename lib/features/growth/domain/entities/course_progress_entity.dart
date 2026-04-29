/// Domain entity for Course Progress (pure Dart, no dependencies)
class CourseProgressEntity {
  final String id;
  final String userId;
  final String courseId;
  final List<String> completedVideoIds;
  final Map<String, QuizResultEntity> quizResults;
  final double overallProgress; // 0.0 to 1.0
  final DateTime updatedAt;
  final DateTime? createdAt;

  CourseProgressEntity({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.completedVideoIds,
    required this.quizResults,
    required this.overallProgress,
    required this.updatedAt,
    this.createdAt,
  });
}

/// Domain entity for Quiz Result
class QuizResultEntity {
  final String quizId;
  final int score; // Percentage
  final int totalQuestions;
  final int correctAnswers;
  final bool passed;
  final DateTime completedAt;

  QuizResultEntity({
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.passed,
    required this.completedAt,
  });
}

/// Domain entity for Certificate
class CertificateEntity {
  final String id;
  final String userId;
  final String courseId;
  final String courseTitle;
  final DateTime issuedAt;
  final String certificateUrl;
  final String certificateNumber;

  CertificateEntity({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseTitle,
    required this.issuedAt,
    required this.certificateUrl,
    required this.certificateNumber,
  });
}

