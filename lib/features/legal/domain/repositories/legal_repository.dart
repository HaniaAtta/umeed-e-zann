import '../entities/chat_message_entity.dart';

/// Abstract repository interface for legal operations
abstract class LegalRepository {
  // Chatbot Methods
  Future<String> getChatbotResponse(String userMessage);
  
  Future<void> saveChatMessage(ChatMessageEntity message);
  
  Stream<List<ChatMessageEntity>> getChatHistory(String userId);
  
  Future<void> clearChatHistory(String userId);
}

