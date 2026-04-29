import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/growth/data/models/courses_data.dart';
import '../models/course_model.dart';

class GrowthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Course Progress Methods

  // Save course progress
  Future<void> saveCourseProgress({
    required String userId,
    required String courseId,
    required List<String> completedVideoIds,
    required Map<String, Map<String, dynamic>> quizResults,
    required double overallProgress,
  }) async {
    try {
      final progressData = {
        'userId': userId,
        'courseId': courseId,
        'completedVideoIds': completedVideoIds,
        'quizResults': quizResults,
        'overallProgress': overallProgress,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };
      
      await _firestore
          .collection('course_progress')
          .doc('${userId}_$courseId')
          .set(progressData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save course progress: $e');
    }
  }

  // Get course progress
  Future<Map<String, dynamic>?> getCourseProgress(String userId, String courseId) async {
    try {
      final doc = await _firestore
          .collection('course_progress')
          .doc('${userId}_$courseId')
          .get();
      
      if (!doc.exists) return null;
      return {...doc.data()!, 'id': doc.id};
    } catch (e) {
      throw Exception('Failed to get course progress: $e');
    }
  }

  // Get all course progress for user
  Stream<List<Map<String, dynamic>>> getUserCourseProgress(String userId) {
    try {
      return _firestore
          .collection('course_progress')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return {...doc.data(), 'id': doc.id};
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get user course progress: $e');
    }
  }

  // Bookmark Methods

  // Bookmark a course
  Future<void> bookmarkCourse(String userId, String courseId) async {
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

  // Unbookmark a course
  Future<void> unbookmarkCourse(String userId, String courseId) async {
    try {
      await _firestore.collection('bookmarks').doc('${userId}_$courseId').delete();
    } catch (e) {
      throw Exception('Failed to unbookmark course: $e');
    }
  }

  // Check if course is bookmarked
  Future<bool> isCourseBookmarked(String userId, String courseId) async {
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

  // Get bookmarked courses
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
      throw Exception('Failed to get bookmarked courses: $e');
    }
  }

  // Get courses from Firestore (if stored) or from local data
  Future<List<Course>> getCourses({
    String? category,
    String? searchQuery,
  }) async {
    try {
      // First try to get from Firestore
      Query query = _firestore.collection('courses').where('isActive', isEqualTo: true);
      
      if (category != null && category != 'all') {
        query = query.where('category', isEqualTo: category);
      }
      
      final snapshot = await query.get();
      
      if (snapshot.docs.isNotEmpty) {
        // Convert Firestore courses to Course model
        // For now, we'll use local data and sync to Firestore later
      }
    } catch (e) {
      // If Firestore fails, use local data
    }
    
    // Use local courses data for now
    List<Course> courses;
    if (category == null || category == 'all') {
      courses = CoursesData.getAllCourses();
    } else {
      courses = CoursesData.getCoursesByCategory(category);
    }
    
    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      courses = courses.where((course) {
        return course.title.toLowerCase().contains(query) ||
            course.description.toLowerCase().contains(query) ||
            course.instructor.toLowerCase().contains(query) ||
            course.categoryDisplayName.toLowerCase().contains(query);
      }).toList();
    }
    
    return courses;
  }

  // Save quiz result
  Future<void> saveQuizResult({
    required String userId,
    required String courseId,
    required String quizId,
    required int score,
    required int totalQuestions,
    required int correctAnswers,
    required bool passed,
  }) async {
    try {
      final quizResult = {
        'quizId': quizId,
        'score': score,
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'passed': passed,
        'completedAt': Timestamp.fromDate(DateTime.now()),
      };
      
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
      
      quizResults[quizId] = quizResult;
      
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
}

