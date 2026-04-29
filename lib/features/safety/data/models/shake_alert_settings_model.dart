import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/shake_alert_settings_entity.dart';

/// Data model for Shake Alert Settings (Firestore DTO)
class ShakeAlertSettingsModel {
  final String userId;
  final bool enabled;
  final int sensitivity;
  final DateTime? lastTriggered;

  ShakeAlertSettingsModel({
    required this.userId,
    required this.enabled,
    required this.sensitivity,
    this.lastTriggered,
  });

  /// Convert to domain entity
  ShakeAlertSettingsEntity toEntity() {
    return ShakeAlertSettingsEntity(
      userId: userId,
      enabled: enabled,
      sensitivity: sensitivity,
      lastTriggered: lastTriggered,
    );
  }

  /// Convert from Firestore document
  factory ShakeAlertSettingsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShakeAlertSettingsModel(
      userId: doc.id,
      enabled: data['enabled'] as bool? ?? false,
      sensitivity: (data['sensitivity'] as num?)?.toInt() ?? 3,
      lastTriggered: (data['lastTriggered'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'enabled': enabled,
      'sensitivity': sensitivity,
      if (lastTriggered != null) 'lastTriggered': Timestamp.fromDate(lastTriggered!),
    };
  }

  /// Convert from domain entity
  factory ShakeAlertSettingsModel.fromEntity(ShakeAlertSettingsEntity entity) {
    return ShakeAlertSettingsModel(
      userId: entity.userId,
      enabled: entity.enabled,
      sensitivity: entity.sensitivity,
      lastTriggered: entity.lastTriggered,
    );
  }
}

