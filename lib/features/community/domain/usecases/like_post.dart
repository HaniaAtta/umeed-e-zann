import '../repositories/community_repository.dart';

/// Use case to like a post
class LikePost {
  final CommunityRepository repository;

  LikePost(this.repository);

  Future<void> execute(String postId, String userId) async {
    return await repository.likePost(postId, userId);
  }
}

