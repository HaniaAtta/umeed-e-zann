import '../repositories/safety_repository.dart';

/// Use case to remove trusted contact
class RemoveTrustedContact {
  final SafetyRepository repository;

  RemoveTrustedContact(this.repository);

  Future<void> execute({
    required String userId,
    required String contactId,
  }) async {
    return await repository.removeTrustedContact(
      userId: userId,
      contactId: contactId,
    );
  }
}

