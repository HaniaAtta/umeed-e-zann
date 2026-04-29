/// Domain entity for chat threads
/// Pure Dart class - no Firebase dependencies
class ChatThread {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final String lastSenderId;
  final DateTime updatedAt;
  final Map<String, int> unreadCounts;
  final Map<String, dynamic>? participantProfiles;

  const ChatThread({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastSenderId,
    required this.updatedAt,
    required this.unreadCounts,
    this.participantProfiles,
  });

  /// Get unread count for a specific user
  int unreadFor(String userId) => unreadCounts[userId] ?? 0;

  /// Get avatar URL for a participant
  String? avatarFor(String userId) {
    final profile = participantProfiles?[userId] as Map<String, dynamic>?;
    return profile?['avatar'] as String?;
  }

  /// Get name for a participant
  String? nameFor(String userId) {
    final profile = participantProfiles?[userId] as Map<String, dynamic>?;
    return profile?['name'] as String?;
  }
}

