import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_thread.dart';

/// Data Transfer Object for ChatThread
/// Handles Firestore serialization/deserialization
class ChatThreadModel extends ChatThread {
  const ChatThreadModel({
    required super.id,
    required super.participants,
    required super.lastMessage,
    required super.lastSenderId,
    required super.updatedAt,
    required super.unreadCounts,
    super.participantProfiles,
  });

  /// Convert to domain entity
  ChatThread toEntity() {
    return ChatThread(
      id: id,
      participants: participants,
      lastMessage: lastMessage,
      lastSenderId: lastSenderId,
      updatedAt: updatedAt,
      unreadCounts: unreadCounts,
      participantProfiles: participantProfiles,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'unreadCounts': unreadCounts,
      'participantProfiles': participantProfiles ?? {},
    };
  }

  /// Create from Firestore document
  factory ChatThreadModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatThreadModel(
      id: doc.id,
      participants: (data['participants'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      lastMessage: data['lastMessage'] as String? ?? '',
      lastSenderId: data['lastSenderId'] as String? ?? '',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCounts: (data['unreadCounts'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, (value as num).toInt())),
      participantProfiles:
          (data['participantProfiles'] as Map<String, dynamic>? ?? {}),
    );
  }

  /// Create from domain entity
  factory ChatThreadModel.fromEntity(ChatThread entity) {
    return ChatThreadModel(
      id: entity.id,
      participants: entity.participants,
      lastMessage: entity.lastMessage,
      lastSenderId: entity.lastSenderId,
      updatedAt: entity.updatedAt,
      unreadCounts: entity.unreadCounts,
      participantProfiles: entity.participantProfiles,
    );
  }
}

