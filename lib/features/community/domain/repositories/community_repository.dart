import '../entities/post_entity.dart';

/// Abstract repository interface for community operations
abstract class CommunityRepository {
  // Post Methods
  Future<String> createPost(PostEntity post);
  
  Stream<List<PostEntity>> getPosts({String? category});
  
  Future<PostEntity?> getPost(String postId);
  
  Future<void> updatePost(String postId, Map<String, dynamic> data);
  
  Future<void> deletePost(String postId);
  
  Future<void> likePost(String postId, String userId);
  
  Future<void> unlikePost(String postId, String userId);
  
  // Reply Methods
  Future<String> createReply(ReplyEntity reply);
  
  Stream<List<ReplyEntity>> getPostReplies(String postId);
  
  Future<void> deleteReply(String replyId);
}

