import '../entities/sos_alert_entity.dart';
import '../repositories/safety_repository.dart';

/// Use case to create SOS alert
class CreateSosAlert {
  final SafetyRepository repository;

  CreateSosAlert(this.repository);

  Future<String> execute({
    required String userId,
    required LocationEntity location,
    String? audioUrl,
    String? message,
  }) async {
    return await repository.createSosAlert(
      userId: userId,
      location: location,
      audioUrl: audioUrl,
      message: message,
    );
  }
}

