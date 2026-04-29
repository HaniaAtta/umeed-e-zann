import '../repositories/verification_repository.dart';
import '../entities/verification_entity.dart';

/// Use case to submit verification
class SubmitVerification {
  final VerificationRepository repository;

  SubmitVerification(this.repository);

  Future<String> execute(VerificationEntity verification) async {
    return await repository.submitVerification(verification);
  }
}

