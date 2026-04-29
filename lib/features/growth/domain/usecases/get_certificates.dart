import '../entities/course_progress_entity.dart';
import '../repositories/growth_repository.dart';

/// Use case to get certificates
class GetCertificates {
  final GrowthRepository repository;

  GetCertificates(this.repository);

  Future<List<CertificateEntity>> execute(String userId) async {
    return await repository.getCertificates(userId);
  }
}

