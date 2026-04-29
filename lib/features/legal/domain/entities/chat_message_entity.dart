/// Domain entity for Chat Message (pure Dart, no dependencies)
class ChatMessageEntity {
  final String id;
  final String userId;
  final String message;
  final String? response;
  final bool isUser;
  final DateTime timestamp;

  ChatMessageEntity({
    required this.id,
    required this.userId,
    required this.message,
    this.response,
    required this.isUser,
    required this.timestamp,
  });
}

