import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message.dart';

/// Data Transfer Object for ChatMessage
/// Handles Firestore serialization/deserialization
class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.text,
    required super.createdAt,
    required super.status,
    super.imageUrl,
    super.replyToText,
    super.isPinned,
  });

  /// Convert to domain entity
  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      chatId: chatId,
      senderId: senderId,
      text: text,
      createdAt: createdAt,
      status: status,
      imageUrl: imageUrl,
      replyToText: replyToText,
      isPinned: isPinned,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': _statusToString(status),
      'imageUrl': imageUrl,
      'replyToText': replyToText,
      'isPinned': isPinned,
    };
  }

  /// Create from Firestore document
  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      chatId: data['chatId'] as String? ?? '',
      senderId: data['senderId'] as String? ?? '',
      text: data['text'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: _statusFromString(data['status'] as String?),
      imageUrl: data['imageUrl'] as String?,
      replyToText: data['replyToText'] as String?,
      isPinned: data['isPinned'] as bool? ?? false,
    );
  }

  /// Create from domain entity
  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      id: entity.id,
      chatId: entity.chatId,
      senderId: entity.senderId,
      text: entity.text,
      createdAt: entity.createdAt,
      status: entity.status,
      imageUrl: entity.imageUrl,
      replyToText: entity.replyToText,
      isPinned: entity.isPinned,
    );
  }

  static ChatMessageStatus _statusFromString(String? value) {
    if (value == 'delivered') return ChatMessageStatus.delivered;
    if (value == 'read') return ChatMessageStatus.read;
    if (value == 'sent') return ChatMessageStatus.sent;
    return ChatMessageStatus.sending;
  }

  static String _statusToString(ChatMessageStatus status) {
    switch (status) {
      case ChatMessageStatus.delivered:
        return 'delivered';
      case ChatMessageStatus.read:
        return 'read';
      case ChatMessageStatus.sent:
        return 'sent';
      case ChatMessageStatus.sending:
        return 'sending';
    }
  }
}

