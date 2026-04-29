/// Domain entity for Shake Alert Settings (pure Dart, no dependencies)
class ShakeAlertSettingsEntity {
  final String userId;
  final bool enabled;
  final int sensitivity; // 1-5
  final DateTime? lastTriggered;

  ShakeAlertSettingsEntity({
    required this.userId,
    required this.enabled,
    required this.sensitivity,
    this.lastTriggered,
  });
}

