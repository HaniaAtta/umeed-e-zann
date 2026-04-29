import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/legal_repository.dart';
import '../datasources/legal_remote_datasource.dart';

/// Repository implementation for Legal module
class LegalRepositoryImpl implements LegalRepository {
  final LegalRemoteDataSource remoteDataSource;

  LegalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> getChatbotResponse(String userMessage) async {
    try {
      return await remoteDataSource.getChatbotResponse(userMessage);
    } catch (e) {
      throw Exception('Failed to get chatbot response: $e');
    }
  }

  @override
  Future<void> saveChatMessage(ChatMessageEntity message) async {
    try {
      await remoteDataSource.saveChatMessage(message);
    } catch (e) {
      throw Exception('Failed to save chat message: $e');
    }
  }

  @override
  Stream<List<ChatMessageEntity>> getChatHistory(String userId) {
    try {
      return remoteDataSource.getChatHistory(userId).map(
        (models) => models.map((model) => model.toEntity()).toList(),
      );
    } catch (e) {
      throw Exception('Failed to get chat history: $e');
    }
  }

  @override
  Future<void> clearChatHistory(String userId) async {
    try {
      await remoteDataSource.clearChatHistory(userId);
    } catch (e) {
      throw Exception('Failed to clear chat history: $e');
    }
  }
}

