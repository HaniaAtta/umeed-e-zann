import 'package:flutter/foundation.dart';

/// Service to manage bookmarked courses
class BookmarkService extends ChangeNotifier {
  static final BookmarkService _instance = BookmarkService._internal();
  factory BookmarkService() => _instance;
  BookmarkService._internal();

  final Set<String> _bookmarkedCourseIds = {};

  Set<String> get bookmarkedCourseIds => _bookmarkedCourseIds;

  bool isBookmarked(String courseId) {
    return _bookmarkedCourseIds.contains(courseId);
  }

  void toggleBookmark(String courseId) {
    if (_bookmarkedCourseIds.contains(courseId)) {
      _bookmarkedCourseIds.remove(courseId);
    } else {
      _bookmarkedCourseIds.add(courseId);
    }
    notifyListeners();
  }

  void addBookmark(String courseId) {
    if (!_bookmarkedCourseIds.contains(courseId)) {
      _bookmarkedCourseIds.add(courseId);
      notifyListeners();
    }
  }

  void removeBookmark(String courseId) {
    if (_bookmarkedCourseIds.contains(courseId)) {
      _bookmarkedCourseIds.remove(courseId);
      notifyListeners();
    }
  }

  void clearAllBookmarks() {
    _bookmarkedCourseIds.clear();
    notifyListeners();
  }
}
