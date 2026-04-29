import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post_entity.dart';

/// Data model for Post (Firestore DTO)
class PostModel {
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

  PostModel({
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

  /// Convert to domain entity
  PostEntity toEntity() {
    return PostEntity(
      id: id,
      authorId: authorId,
      title: title,
      content: content,
      category: category,
      timestamp: timestamp,
      likes: likes,
      replies: replies,
      isAnonymous: isAnonymous,
      likedBy: likedBy,
    );
  }

  /// Convert from Firestore document
  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      authorId: data['authorId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      category: data['category'] as String? ?? 'General',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: (data['likes'] as int?) ?? 0,
      replies: (data['replies'] as int?) ?? 0,
      isAnonymous: data['isAnonymous'] as bool? ?? false,
      likedBy: (data['likedBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'title': title,
      'content': content,
      'category': category,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'replies': replies,
      'isAnonymous': isAnonymous,
      'likedBy': likedBy,
    };
  }

  /// Convert from domain entity
  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      id: entity.id,
      authorId: entity.authorId,
      title: entity.title,
      content: entity.content,
      category: entity.category,
      timestamp: entity.timestamp,
      likes: entity.likes,
      replies: entity.replies,
      isAnonymous: entity.isAnonymous,
      likedBy: entity.likedBy,
    );
  }
}

/// Data model for Reply (Firestore DTO)
class ReplyModel {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime timestamp;
  final bool isAnonymous;

  ReplyModel({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.timestamp,
    this.isAnonymous = false,
  });

  /// Convert to domain entity
  ReplyEntity toEntity() {
    return ReplyEntity(
      id: id,
      postId: postId,
      authorId: authorId,
      content: content,
      timestamp: timestamp,
      isAnonymous: isAnonymous,
    );
  }

  /// Convert from Firestore document
  factory ReplyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReplyModel(
      id: doc.id,
      postId: data['postId'] as String? ?? '',
      authorId: data['authorId'] as String? ?? '',
      content: data['content'] as String? ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isAnonymous: data['isAnonymous'] as bool? ?? false,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'authorId': authorId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'isAnonymous': isAnonymous,
    };
  }

  /// Convert from domain entity
  factory ReplyModel.fromEntity(ReplyEntity entity) {
    return ReplyModel(
      id: entity.id,
      postId: entity.postId,
      authorId: entity.authorId,
      content: entity.content,
      timestamp: entity.timestamp,
      isAnonymous: entity.isAnonymous,
    );
  }
}

