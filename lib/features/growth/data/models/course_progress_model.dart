import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/course_progress_entity.dart';

/// Data model for Course Progress (Firestore DTO)
class CourseProgressModel {
  final String id;
  final String userId;
  final String courseId;
  final List<String> completedVideoIds;
  final Map<String, Map<String, dynamic>> quizResultsData;
  final double overallProgress;
  final DateTime updatedAt;
  final DateTime? createdAt;

  CourseProgressModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.completedVideoIds,
    required this.quizResultsData,
    required this.overallProgress,
    required this.updatedAt,
    this.createdAt,
  });

  /// Convert to domain entity
  CourseProgressEntity toEntity() {
    final quizResults = <String, QuizResultEntity>{};
    quizResultsData.forEach((quizId, data) {
      quizResults[quizId] = QuizResultEntity(
        quizId: quizId,
        score: data['score'] as int? ?? 0,
        totalQuestions: data['totalQuestions'] as int? ?? 0,
        correctAnswers: data['correctAnswers'] as int? ?? 0,
        passed: data['passed'] as bool? ?? false,
        completedAt: (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    });

    return CourseProgressEntity(
      id: id,
      userId: userId,
      courseId: courseId,
      completedVideoIds: completedVideoIds,
      quizResults: quizResults,
      overallProgress: overallProgress,
      updatedAt: updatedAt,
      createdAt: createdAt,
    );
  }

  /// Convert from Firestore document
  factory CourseProgressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseProgressModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      courseId: data['courseId'] as String? ?? '',
      completedVideoIds: List<String>.from(data['completedVideoIds'] as List? ?? []),
      quizResultsData: Map<String, Map<String, dynamic>>.from(
        data['quizResults'] as Map? ?? {},
      ),
      overallProgress: (data['overallProgress'] as num?)?.toDouble() ?? 0.0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    final quizResultsMap = <String, Map<String, dynamic>>{};
    quizResultsData.forEach((quizId, data) {
      quizResultsMap[quizId] = data;
    });

    return {
      'userId': userId,
      'courseId': courseId,
      'completedVideoIds': completedVideoIds,
      'quizResults': quizResultsMap,
      'overallProgress': overallProgress,
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  /// Convert from domain entity
  factory CourseProgressModel.fromEntity(CourseProgressEntity entity) {
    final quizResultsData = <String, Map<String, dynamic>>{};
    entity.quizResults.forEach((quizId, quizResult) {
      quizResultsData[quizId] = {
        'quizId': quizResult.quizId,
        'score': quizResult.score,
        'totalQuestions': quizResult.totalQuestions,
        'correctAnswers': quizResult.correctAnswers,
        'passed': quizResult.passed,
        'completedAt': Timestamp.fromDate(quizResult.completedAt),
      };
    });

    return CourseProgressModel(
      id: entity.id,
      userId: entity.userId,
      courseId: entity.courseId,
      completedVideoIds: entity.completedVideoIds,
      quizResultsData: quizResultsData,
      overallProgress: entity.overallProgress,
      updatedAt: entity.updatedAt,
      createdAt: entity.createdAt,
    );
  }
}

