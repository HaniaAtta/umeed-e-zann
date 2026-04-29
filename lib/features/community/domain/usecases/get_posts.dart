import '../repositories/community_repository.dart';
import '../entities/post_entity.dart';

/// Use case to get posts
class GetPosts {
  final CommunityRepository repository;

  GetPosts(this.repository);

  Stream<List<PostEntity>> execute({String? category}) {
    return repository.getPosts(category: category);
  }
}

