import '../../domain/repositories/community_repository.dart';
import '../../domain/entities/post_entity.dart';
import '../datasources/community_remote_datasource.dart';

/// Implementation of CommunityRepository
class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource remoteDataSource;

  CommunityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> createPost(PostEntity post) async {
    try {
      return await remoteDataSource.createPost(post);
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  @override
  Stream<List<PostEntity>> getPosts({String? category}) {
    try {
      return remoteDataSource.getPosts(category: category);
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }

  @override
  Future<PostEntity?> getPost(String postId) async {
    try {
      return await remoteDataSource.getPost(postId);
    } catch (e) {
      throw Exception('Failed to get post: $e');
    }
  }

  @override
  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    try {
      return await remoteDataSource.updatePost(postId, data);
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      return await remoteDataSource.deletePost(postId);
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  @override
  Future<void> likePost(String postId, String userId) async {
    try {
      return await remoteDataSource.likePost(postId, userId);
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    try {
      return await remoteDataSource.unlikePost(postId, userId);
    } catch (e) {
      throw Exception('Failed to unlike post: $e');
    }
  }

  @override
  Future<String> createReply(ReplyEntity reply) async {
    try {
      return await remoteDataSource.createReply(reply);
    } catch (e) {
      throw Exception('Failed to create reply: $e');
    }
  }

  @override
  Stream<List<ReplyEntity>> getPostReplies(String postId) {
    try {
      return remoteDataSource.getPostReplies(postId);
    } catch (e) {
      throw Exception('Failed to get replies: $e');
    }
  }

  @override
  Future<void> deleteReply(String replyId) async {
    try {
      return await remoteDataSource.deleteReply(replyId);
    } catch (e) {
      throw Exception('Failed to delete reply: $e');
    }
  }
}

