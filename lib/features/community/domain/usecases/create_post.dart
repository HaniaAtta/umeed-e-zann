import '../repositories/community_repository.dart';
import '../entities/post_entity.dart';

/// Use case to create a post
class CreatePost {
  final CommunityRepository repository;

  CreatePost(this.repository);

  Future<String> execute(PostEntity post) async {
    return await repository.createPost(post);
  }
}

