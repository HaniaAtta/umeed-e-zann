import '../entities/shake_alert_settings_entity.dart';
import '../repositories/safety_repository.dart';

/// Use case to get shake alert settings
class GetShakeAlertSettings {
  final SafetyRepository repository;

  GetShakeAlertSettings(this.repository);

  Future<ShakeAlertSettingsEntity?> execute(String userId) async {
    return await repository.getShakeAlertSettings(userId);
  }
}

