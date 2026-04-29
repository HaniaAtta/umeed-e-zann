import '../entities/chat_message_entity.dart';
import '../repositories/legal_repository.dart';

/// Use case to save chat message
class SaveChatMessage {
  final LegalRepository repository;

  SaveChatMessage(this.repository);

  Future<void> execute(ChatMessageEntity message) async {
    return await repository.saveChatMessage(message);
  }
}

