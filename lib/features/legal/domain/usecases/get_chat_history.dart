import '../entities/chat_message_entity.dart';
import '../repositories/legal_repository.dart';

/// Use case to get chat history stream
class GetChatHistory {
  final LegalRepository repository;

  GetChatHistory(this.repository);

  Stream<List<ChatMessageEntity>> execute(String userId) {
    return repository.getChatHistory(userId);
  }
}

