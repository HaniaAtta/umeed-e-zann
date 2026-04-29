import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Create forum post
  Future<String> createPost({
    required String title,
    required String content,
    required String category,
    String? authorName,
    bool isAnonymous = false,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not logged in');

      final postData = {
        'userId': userId,
        'title': title,
        'content': content,
        'category': category,
        'authorName': isAnonymous ? 'Anonymous' : (authorName ?? 'User'),
        'isAnonymous': isAnonymous,
        'replies': 0,
        'views': 0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      final docRef = await _firestore.collection('forum_posts').add(postData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Get all forum posts stream
  Stream<List<Map<String, dynamic>>> getAllPosts({
    String? category,
    int? limit,
  }) {
    try {
      Query query = _firestore
          .collection('forum_posts')
          .orderBy('createdAt', descending: true);

      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      return query.snapshots().map<List<Map<String, dynamic>>>((snapshot) {
        return snapshot.docs.map<Map<String, dynamic>>((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {...data, 'id': doc.id};
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }

  // Get post by ID
  Future<Map<String, dynamic>?> getPost(String postId) async {
    try {
      final doc = await _firestore.collection('forum_posts').doc(postId).get();
      if (!doc.exists) return null;
      
      // Increment views
      await _firestore.collection('forum_posts').doc(postId).update({
        'views': FieldValue.increment(1),
      });

      return {...doc.data()!, 'id': doc.id};
    } catch (e) {
      throw Exception('Failed to get post: $e');
    }
  }

  // Add reply to post
  Future<String> addReply({
    required String postId,
    required String content,
    String? authorName,
    bool isAnonymous = false,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not logged in');

      final replyData = {
        'userId': userId,
        'postId': postId,
        'content': content,
        'authorName': isAnonymous ? 'Anonymous' : (authorName ?? 'User'),
        'isAnonymous': isAnonymous,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      };

      final docRef = await _firestore.collection('forum_replies').add(replyData);
      
      // Increment reply count
      await _firestore.collection('forum_posts').doc(postId).update({
        'replies': FieldValue.increment(1),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add reply: $e');
    }
  }

  // Get replies for a post
  Stream<List<Map<String, dynamic>>> getReplies(String postId) {
    try {
      return _firestore
          .collection('forum_replies')
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return {...data, 'id': doc.id};
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get replies: $e');
    }
  }

  // Delete post
  Future<void> deletePost(String postId) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not logged in');

      // Check if user owns the post
      final post = await _firestore.collection('forum_posts').doc(postId).get();
      if (post.data()?['userId'] != userId) {
        throw Exception('You can only delete your own posts');
      }

      // Delete post and all replies
      final batch = _firestore.batch();
      batch.delete(_firestore.collection('forum_posts').doc(postId));
      
      // Delete all replies
      final replies = await _firestore
          .collection('forum_replies')
          .where('postId', isEqualTo: postId)
          .get();
      for (var reply in replies.docs) {
        batch.delete(reply.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  // Search posts
  Future<List<Map<String, dynamic>>> searchPosts(String query) async {
    try {
      final snapshot = await _firestore.collection('forum_posts').get();
      final allPosts = snapshot.docs.map((doc) {
        final data = doc.data();
        return {...data, 'id': doc.id};
      }).toList();

      final searchLower = query.toLowerCase();
      return allPosts.where((post) {
        final title = (post['title'] as String? ?? '').toLowerCase();
        final content = (post['content'] as String? ?? '').toLowerCase();
        final category = (post['category'] as String? ?? '').toLowerCase();
        return title.contains(searchLower) ||
            content.contains(searchLower) ||
            category.contains(searchLower);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search posts: $e');
    }
  }
}
