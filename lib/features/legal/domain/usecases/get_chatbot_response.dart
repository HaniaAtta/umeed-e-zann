import '../repositories/legal_repository.dart';

/// Use case to get chatbot response
class GetChatbotResponse {
  final LegalRepository repository;

  GetChatbotResponse(this.repository);

  Future<String> execute(String userMessage) async {
    return await repository.getChatbotResponse(userMessage);
  }
}

