import '../repositories/safety_repository.dart';

/// Use case to update SOS alert status
class UpdateSosAlertStatus {
  final SafetyRepository repository;

  UpdateSosAlertStatus(this.repository);

  Future<void> execute({
    required String alertId,
    required String status,
  }) async {
    return await repository.updateSosAlertStatus(
      alertId: alertId,
      status: status,
    );
  }
}

