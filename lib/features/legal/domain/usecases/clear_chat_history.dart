import '../repositories/legal_repository.dart';

/// Use case to clear chat history
class ClearChatHistory {
  final LegalRepository repository;

  ClearChatHistory(this.repository);

  Future<void> execute(String userId) async {
    return await repository.clearChatHistory(userId);
  }
}

