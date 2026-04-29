import '../entities/sos_alert_entity.dart';
import '../entities/trusted_contact_entity.dart';
import '../entities/live_tracking_entity.dart';
import '../entities/shake_alert_settings_entity.dart';
import '../entities/fake_call_entity.dart';

/// Abstract repository interface for safety operations
abstract class SafetyRepository {
  // SOS Alert Methods
  Future<String> createSosAlert({
    required String userId,
    required LocationEntity location,
    String? audioUrl,
    String? message,
  });

  Stream<List<SosAlertEntity>> getSosAlerts(String userId);

  Future<void> updateSosAlertStatus({
    required String alertId,
    required String status,
  });

  // Trusted Contacts Methods
  Future<void> addTrustedContact(TrustedContactEntity contact);

  Future<void> removeTrustedContact({
    required String userId,
    required String contactId,
  });

  Stream<List<TrustedContactEntity>> getTrustedContacts(String userId);

  // Live Tracking Methods
  Future<String> startLiveTracking({
    required String userId,
    required List<String> viewerIds,
  });

  Future<void> updateLiveTrackingLocation({
    required String trackingId,
    required LocationEntity location,
  });

  Stream<LiveTrackingEntity?> getLiveTracking(String trackingId);

  Future<void> stopLiveTracking(String trackingId);

  // Shake Alert Methods
  Future<void> saveShakeAlertSettings(ShakeAlertSettingsEntity settings);

  Future<ShakeAlertSettingsEntity?> getShakeAlertSettings(String userId);

  // Fake Call Methods
  Future<void> logFakeCall(FakeCallEntity fakeCall);

  Stream<List<FakeCallEntity>> getFakeCallHistory(String userId);
}

