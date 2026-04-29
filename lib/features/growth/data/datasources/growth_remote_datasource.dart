import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/course_progress_model.dart';
import '../models/certificate_model.dart';
import '../../domain/entities/course_progress_entity.dart';

/// Remote data source for Growth module (Firebase operations)
abstract class GrowthRemoteDataSource {
  Future<CourseProgressModel?> getCourseProgress({
    required String userId,
    required String courseId,
  });

  Stream<List<CourseProgressModel>> getUserCourseProgress(String userId);

  Future<void> saveCourseProgress(CourseProgressModel progress);

  Future<void> bookmarkCourse({
    required String userId,
    required String courseId,
  });

  Future<void> unbookmarkCourse({
    required String userId,
    required String courseId,
  });

  Stream<List<String>> getBookmarkedCourseIds(String userId);

  Future<bool> isCourseBookmarked({
    required String userId,
    required String courseId,
  });

  Future<void> saveQuizResult({
    required String userId,
    required String courseId,
    required QuizResultEntity quizResult,
  });

  Future<List<CertificateModel>> getCertificates(String userId);

  Future<CertificateModel> generateCertificate({
    required String userId,
    required String courseId,
    required String courseTitle,
  });
}

/// Implementation of GrowthRemoteDataSource
class GrowthRemoteDataSourceImpl implements GrowthRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<CourseProgressModel?> getCourseProgress({
    required String userId,
    required String courseId,
  }) async {
    try {
      final doc = await _firestore
          .collection('course_progress')
          .doc('${userId}_$courseId')
          .get();

      if (!doc.exists) return null;
      return CourseProgressModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get course progress: $e');
    }
  }

  @override
  Stream<List<CourseProgressModel>> getUserCourseProgress(String userId) {
    try {
      return _firestore
          .collection('course_progress')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CourseProgressModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to get user course progress: $e');
    }
  }

  @override
  Future<void> saveCourseProgress(CourseProgressModel progress) async {
    try {
      await _firestore
          .collection('course_progress')
          .doc(progress.id)
          .set(progress.toFirestore(), SetOptions(merge: true));
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
      await _firestore.collection('bookmarks').doc('${userId}_$courseId').set({
        'userId': userId,
        'courseId': courseId,
        'bookmarkedAt': Timestamp.fromDate(DateTime.now()),
      });
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
      await _firestore.collection('bookmarks').doc('${userId}_$courseId').delete();
    } catch (e) {
      throw Exception('Failed to unbookmark course: $e');
    }
  }

  @override
  Stream<List<String>> getBookmarkedCourseIds(String userId) {
    try {
      return _firestore
          .collection('bookmarks')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => doc.data()['courseId'] as String)
            .toList();
      });
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
      final doc = await _firestore
          .collection('bookmarks')
          .doc('${userId}_$courseId')
          .get();
      return doc.exists;
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
      // Get current progress
      final progressDoc = await _firestore
          .collection('course_progress')
          .doc('${userId}_$courseId')
          .get();

      Map<String, dynamic> quizResults = {};
      if (progressDoc.exists) {
        quizResults = Map<String, dynamic>.from(
          progressDoc.data()?['quizResults'] ?? {},
        );
      }

      // Add new quiz result
      quizResults[quizResult.quizId] = {
        'quizId': quizResult.quizId,
        'score': quizResult.score,
        'totalQuestions': quizResult.totalQuestions,
        'correctAnswers': quizResult.correctAnswers,
        'passed': quizResult.passed,
        'completedAt': Timestamp.fromDate(quizResult.completedAt),
      };

      // Update progress
      await _firestore
          .collection('course_progress')
          .doc('${userId}_$courseId')
          .set({
        'userId': userId,
        'courseId': courseId,
        'quizResults': quizResults,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save quiz result: $e');
    }
  }

  @override
  Future<List<CertificateModel>> getCertificates(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('certificates')
          .where('userId', isEqualTo: userId)
          .orderBy('issuedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CertificateModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      // If it's an index error, return empty list instead of crashing
      if (e.toString().contains('index') || 
          e.toString().contains('FAILED_PRECONDITION')) {
        debugPrint('Firestore index required for certificates query: $e');
        return <CertificateModel>[];
      }
      throw Exception('Failed to get certificates: $e');
    }
  }

  @override
  Future<CertificateModel> generateCertificate({
    required String userId,
    required String courseId,
    required String courseTitle,
  }) async {
    try {
      // Generate certificate number
      final certificateNumber = 'CERT-${DateTime.now().millisecondsSinceEpoch}-${courseId.substring(0, 4).toUpperCase()}';
      
      // For now, we'll use a placeholder URL. In production, you'd generate an actual certificate image
      final certificateUrl = 'https://example.com/certificates/$certificateNumber';

      final certificate = CertificateModel(
        id: '${userId}_$courseId',
        userId: userId,
        courseId: courseId,
        courseTitle: courseTitle,
        issuedAt: DateTime.now(),
        certificateUrl: certificateUrl,
        certificateNumber: certificateNumber,
      );

      await _firestore
          .collection('certificates')
          .doc(certificate.id)
          .set(certificate.toFirestore());

      return certificate;
    } catch (e) {
      throw Exception('Failed to generate certificate: $e');
    }
  }
}

