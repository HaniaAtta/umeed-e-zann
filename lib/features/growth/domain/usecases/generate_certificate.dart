import '../entities/course_progress_entity.dart';
import '../repositories/growth_repository.dart';

/// Use case to generate certificate
class GenerateCertificate {
  final GrowthRepository repository;

  GenerateCertificate(this.repository);

  Future<CertificateEntity> execute({
    required String userId,
    required String courseId,
    required String courseTitle,
  }) async {
    return await repository.generateCertificate(
      userId: userId,
      courseId: courseId,
      courseTitle: courseTitle,
    );
  }
}

