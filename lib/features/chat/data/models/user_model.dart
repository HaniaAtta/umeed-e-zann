import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

/// Data Transfer Object for ChatUser
/// Handles Firestore serialization/deserialization
class ChatUserModel extends ChatUser {
  const ChatUserModel({
    required super.id,
    required super.email,
    super.name,
    super.phone,
    super.profileImageUrl,
  });

  /// Convert to domain entity
  ChatUser toEntity() {
    return ChatUser(
      id: id,
      email: email,
      name: name,
      phone: phone,
      profileImageUrl: profileImageUrl,
    );
  }

  /// Create from Firestore document
  factory ChatUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatUserModel(
      id: doc.id,
      email: data['email'] as String? ?? '',
      name: data['name'] as String?,
      phone: data['phone'] as String?,
      profileImageUrl: data['profileImageUrl'] as String?,
    );
  }

  /// Create from domain entity
  factory ChatUserModel.fromEntity(ChatUser entity) {
    return ChatUserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      phone: entity.phone,
      profileImageUrl: entity.profileImageUrl,
    );
  }
}

