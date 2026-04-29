import '../entities/verification_entity.dart';

/// Abstract repository interface for verification operations
abstract class VerificationRepository {
  Future<String> submitVerification(VerificationEntity verification);
  
  Stream<List<VerificationEntity>> getUserVerifications(String userId);
  
  Future<VerificationEntity?> getVerification(String verificationId);
  
  Future<void> updateVerificationStatus(String verificationId, String status, {String? notes});
}

