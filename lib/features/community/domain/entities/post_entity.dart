/// Domain entity for Post (pure Dart, no dependencies)
class PostEntity {
  final String id;
  final String authorId;
  final String title;
  final String content;
  final String category;
  final DateTime timestamp;
  final int likes;
  final int replies;
  final bool isAnonymous;
  final List<String> likedBy;

  PostEntity({
    required this.id,
    required this.authorId,
    required this.title,
    required this.content,
    required this.category,
    required this.timestamp,
    this.likes = 0,
    this.replies = 0,
    this.isAnonymous = false,
    this.likedBy = const [],
  });
}

/// Domain entity for Reply (pure Dart, no dependencies)
class ReplyEntity {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime timestamp;
  final bool isAnonymous;

  ReplyEntity({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.timestamp,
    this.isAnonymous = false,
  });
}

