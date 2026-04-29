import '../entities/trusted_contact_entity.dart';
import '../repositories/safety_repository.dart';

/// Use case to get trusted contacts stream
class GetTrustedContacts {
  final SafetyRepository repository;

  GetTrustedContacts(this.repository);

  Stream<List<TrustedContactEntity>> execute(String userId) {
    return repository.getTrustedContacts(userId);
  }
}

