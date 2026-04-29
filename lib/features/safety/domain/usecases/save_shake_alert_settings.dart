import '../entities/shake_alert_settings_entity.dart';
import '../repositories/safety_repository.dart';

/// Use case to save shake alert settings
class SaveShakeAlertSettings {
  final SafetyRepository repository;

  SaveShakeAlertSettings(this.repository);

  Future<void> execute(ShakeAlertSettingsEntity settings) async {
    return await repository.saveShakeAlertSettings(settings);
  }
}

