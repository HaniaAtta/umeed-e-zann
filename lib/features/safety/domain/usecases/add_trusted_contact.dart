import '../entities/trusted_contact_entity.dart';
import '../repositories/safety_repository.dart';

/// Use case to add trusted contact
class AddTrustedContact {
  final SafetyRepository repository;

  AddTrustedContact(this.repository);

  Future<void> execute(TrustedContactEntity contact) async {
    return await repository.addTrustedContact(contact);
  }
}

