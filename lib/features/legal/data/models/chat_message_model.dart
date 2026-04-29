import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message_entity.dart';

/// Data model for Chat Message (Firestore DTO)
class ChatMessageModel {
  final String id;
  final String userId;
  final String message;
  final String? response;
  final bool isUser;
  final DateTime timestamp;

  ChatMessageModel({
    required this.id,
    required this.userId,
    required this.message,
    this.response,
    required this.isUser,
    required this.timestamp,
  });

  /// Convert to domain entity
  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      userId: userId,
      message: message,
      response: response,
      isUser: isUser,
      timestamp: timestamp,
    );
  }

  /// Convert from Firestore document
  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      message: data['message'] as String? ?? '',
      response: data['response'] as String?,
      isUser: data['isUser'] as bool? ?? true,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'message': message,
      if (response != null) 'response': response,
      'isUser': isUser,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  /// Convert from domain entity
  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      userId: entity.userId,
      message: entity.message,
      response: entity.response,
      isUser: entity.isUser,
      timestamp: entity.timestamp,
    );
  }
}

