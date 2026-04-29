import '../entities/sos_alert_entity.dart';
import '../repositories/safety_repository.dart';

/// Use case to get SOS alerts stream
class GetSosAlerts {
  final SafetyRepository repository;

  GetSosAlerts(this.repository);

  Stream<List<SosAlertEntity>> execute(String userId) {
    return repository.getSosAlerts(userId);
  }
}

