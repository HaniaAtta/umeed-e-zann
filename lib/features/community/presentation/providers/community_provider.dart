import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../data/services/community_service.dart';

/// Provider for Community module (forum posts and discussions)
class CommunityProvider with ChangeNotifier {
  final CommunityService _service = CommunityService();
  
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _replies = [];
  Map<String, dynamic>? _currentPost;
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get posts => _posts;
  List<Map<String, dynamic>> get replies => _replies;
  Map<String, dynamic>? get currentPost => _currentPost;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  /// Initialize - load posts stream
  void initialize({String? category}) {
    _selectedCategory = category ?? 'All';
    loadPostsStream();
  }

  /// Load posts stream for real-time updates
  void loadPostsStream({String? category}) {
    _setLoading(true);
    _error = null;
    
    if (category != null) {
      _selectedCategory = category;
    }

    _service.getAllPosts(category: _selectedCategory == 'All' ? null : _selectedCategory)
        .listen((postList) {
      _posts = postList;
      _setLoading(false);
      notifyListeners();
    }, onError: (error) {
      _error = error.toString();
      _setLoading(false);
      notifyListeners();
    });
  }

  /// Create new post
  Future<String?> createPost({
    required String title,
    required String content,
    required String category,
    String? authorName,
    bool isAnonymous = false,
  }) async {
    if (_userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return null;
    }

    _setLoading(true);
    _error = null;

    try {
      final postId = await _service.createPost(
        title: title,
        content: content,
        category: category,
        authorName: authorName,
        isAnonymous: isAnonymous,
      );
      return postId;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Get post by ID
  Future<void> loadPost(String postId) async {
    _setLoading(true);
    _error = null;

    try {
      _currentPost = await _service.getPost(postId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load replies stream for a post
  void loadRepliesStream(String postId) {
    _setLoading(true);
    _error = null;

    _service.getReplies(postId).listen((replyList) {
      _replies = replyList;
      _setLoading(false);
      notifyListeners();
    }, onError: (error) {
      _error = error.toString();
      _setLoading(false);
      notifyListeners();
    });
  }

  /// Add reply to post
  Future<String?> addReply({
    required String postId,
    required String content,
    String? authorName,
    bool isAnonymous = false,
  }) async {
    if (_userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return null;
    }

    _setLoading(true);
    _error = null;

    try {
      final replyId = await _service.addReply(
        postId: postId,
        content: content,
        authorName: authorName,
        isAnonymous: isAnonymous,
      );
      return replyId;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete post
  Future<bool> deletePost(String postId) async {
    _setLoading(true);
    _error = null;

    try {
      await _service.deletePost(postId);
      _posts.removeWhere((post) => post['id'] == postId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Search posts
  Future<void> searchPosts(String query) async {
    _setLoading(true);
    _error = null;

    try {
      _posts = await _service.searchPosts(query);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Set selected category
  void setCategory(String category) {
    _selectedCategory = category;
    loadPostsStream();
  }

  /// Clear current post
  void clearCurrentPost() {
    _currentPost = null;
    _replies = [];
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
