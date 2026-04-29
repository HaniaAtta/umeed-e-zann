/// Domain entity for chat messages
/// Pure Dart class - no Firebase dependencies
enum ChatMessageStatus {
  sending,
  sent,
  delivered,
  read,
}

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final ChatMessageStatus status;
  final String? imageUrl;
  final String? replyToText;
  final bool isPinned;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    required this.status,
    this.imageUrl,
    this.replyToText,
    this.isPinned = false,
  });

  ChatMessage copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? text,
    DateTime? createdAt,
    ChatMessageStatus? status,
    String? imageUrl,
    String? replyToText,
    bool? isPinned,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      replyToText: replyToText ?? this.replyToText,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}

