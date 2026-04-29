import '../entities/chat_message.dart';
import '../entities/chat_thread.dart';
import '../entities/user.dart';

/// Repository interface for chat operations
/// This is an abstraction - implementations are in data layer
abstract class ChatRepository {
  /// Start a chat with another user
  Future<String> startChatWith({
    required String otherUserId,
    Map<String, dynamic>? otherProfile,
  });

  /// Get stream of chat threads for current user
  Stream<List<ChatThread>> watchChatThreads();

  /// Get stream of messages for a chat
  Stream<List<ChatMessage>> watchMessages(String chatId);

  /// Send a message
  Future<void> sendMessage({
    required String chatId,
    required String text,
    String? imageUrl,
    String? replyToText,
  });

  /// Mark messages as read in a chat
  Future<void> markAsRead(String chatId);

  /// Get a chat thread by ID
  Future<ChatThread?> getChatThread(String chatId);

  /// Find user by email
  Future<ChatUser?> findUserByEmail(String email);

  /// Find user by phone number
  Future<ChatUser?> findUserByPhone(String phone);

  /// Find user by email or phone
  Future<ChatUser?> findUserByEmailOrPhone(String query);

  /// Start chat with user by email or phone
  Future<String> startChatByContact({
    required String emailOrPhone,
  });

  /// Refresh participant profile when user data changes
  Future<void> refreshParticipantProfile(String userId);
}

