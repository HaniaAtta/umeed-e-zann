import '../../domain/repositories/verification_repository.dart';
import '../../domain/entities/verification_entity.dart';
import '../datasources/verification_remote_datasource.dart';

/// Implementation of VerificationRepository
class VerificationRepositoryImpl implements VerificationRepository {
  final VerificationRemoteDataSource remoteDataSource;

  VerificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> submitVerification(VerificationEntity verification) async {
    try {
      return await remoteDataSource.submitVerification(verification);
    } catch (e) {
      throw Exception('Failed to submit verification: $e');
    }
  }

  @override
  Stream<List<VerificationEntity>> getUserVerifications(String userId) {
    try {
      return remoteDataSource.getUserVerifications(userId);
    } catch (e) {
      throw Exception('Failed to get user verifications: $e');
    }
  }

  @override
  Future<VerificationEntity?> getVerification(String verificationId) async {
    try {
      return await remoteDataSource.getVerification(verificationId);
    } catch (e) {
      throw Exception('Failed to get verification: $e');
    }
  }

  @override
  Future<void> updateVerificationStatus(String verificationId, String status, {String? notes}) async {
    try {
      return await remoteDataSource.updateVerificationStatus(verificationId, status, notes: notes);
    } catch (e) {
      throw Exception('Failed to update verification status: $e');
    }
  }
}

