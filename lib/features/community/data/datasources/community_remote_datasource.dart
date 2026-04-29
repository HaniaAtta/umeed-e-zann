import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/post_entity.dart';
import '../models/post_model.dart';

/// Remote data source for community operations (Firebase)
abstract class CommunityRemoteDataSource {
  Future<String> createPost(PostEntity post);
  Stream<List<PostEntity>> getPosts({String? category});
  Future<PostEntity?> getPost(String postId);
  Future<void> updatePost(String postId, Map<String, dynamic> data);
  Future<void> deletePost(String postId);
  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  Future<String> createReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> getPostReplies(String postId);
  Future<void> deleteReply(String replyId);
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> createPost(PostEntity post) async {
    try {
      final postData = PostModel.fromEntity(post).toFirestore();
      postData.remove('id'); // Remove id as Firestore generates it

      final docRef = await _firestore.collection('posts').add(postData);
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating post: $e');
      throw Exception('Failed to create post: $e');
    }
  }

  @override
  Stream<List<PostEntity>> getPosts({String? category}) {
    try {
      Query query = _firestore.collection('posts').orderBy('timestamp', descending: true);
      
      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return PostModel.fromFirestore(doc).toEntity();
        }).toList();
      }).handleError((error) {
        debugPrint('Error getting posts: $error');
        return <PostEntity>[];
      });
    } catch (e) {
      debugPrint('Error in getPosts stream: $e');
      return Stream.value(<PostEntity>[]);
    }
  }

  @override
  Future<PostEntity?> getPost(String postId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();
      if (!doc.exists) return null;
      return PostModel.fromFirestore(doc).toEntity();
    } catch (e) {
      debugPrint('Error getting post: $e');
      throw Exception('Failed to get post: $e');
    }
  }

  @override
  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await _firestore.collection('posts').doc(postId).update(data);
    } catch (e) {
      debugPrint('Error updating post: $e');
      throw Exception('Failed to update post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      debugPrint('Error deleting post: $e');
      throw Exception('Failed to delete post: $e');
    }
  }

  @override
  Future<void> likePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      debugPrint('Error liking post: $e');
      throw Exception('Failed to like post: $e');
    }
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      debugPrint('Error unliking post: $e');
      throw Exception('Failed to unlike post: $e');
    }
  }

  @override
  Future<String> createReply(ReplyEntity reply) async {
    try {
      final replyData = ReplyModel.fromEntity(reply).toFirestore();
      replyData.remove('id');

      final docRef = await _firestore
          .collection('posts')
          .doc(reply.postId)
          .collection('replies')
          .add(replyData);

      // Update post reply count
      await _firestore.collection('posts').doc(reply.postId).update({
        'replies': FieldValue.increment(1),
      });

      return docRef.id;
    } catch (e) {
      debugPrint('Error creating reply: $e');
      throw Exception('Failed to create reply: $e');
    }
  }

  @override
  Stream<List<ReplyEntity>> getPostReplies(String postId) {
    try {
      return _firestore
          .collection('posts')
          .doc(postId)
          .collection('replies')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ReplyModel.fromFirestore(doc).toEntity();
        }).toList();
      }).handleError((error) {
        debugPrint('Error getting replies: $error');
        return <ReplyEntity>[];
      });
    } catch (e) {
      debugPrint('Error in getPostReplies stream: $e');
      return Stream.value(<ReplyEntity>[]);
    }
  }

  @override
  Future<void> deleteReply(String replyId) async {
    try {
      // Note: This requires knowing the postId, which should be passed
      // For now, we'll need to query or store postId in reply
      throw UnimplementedError('deleteReply requires postId');
    } catch (e) {
      debugPrint('Error deleting reply: $e');
      throw Exception('Failed to delete reply: $e');
    }
  }
}

