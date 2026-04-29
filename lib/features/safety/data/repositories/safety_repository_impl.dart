import '../../domain/entities/sos_alert_entity.dart';
import '../../domain/entities/trusted_contact_entity.dart';
import '../../domain/entities/live_tracking_entity.dart';
import '../../domain/entities/shake_alert_settings_entity.dart';
import '../../domain/entities/fake_call_entity.dart';
import '../../domain/repositories/safety_repository.dart';
import '../datasources/safety_remote_datasource.dart';

/// Repository implementation for Safety module
class SafetyRepositoryImpl implements SafetyRepository {
  final SafetyRemoteDataSource remoteDataSource;

  SafetyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> createSosAlert({
    required String userId,
    required LocationEntity location,
    String? audioUrl,
    String? message,
  }) async {
    try {
      return await remoteDataSource.createSosAlert(
        userId: userId,
        location: location,
        audioUrl: audioUrl,
        message: message,
      );
    } catch (e) {
      throw Exception('Failed to create SOS alert: $e');
    }
  }

  @override
  Stream<List<SosAlertEntity>> getSosAlerts(String userId) {
    try {
      return remoteDataSource.getSosAlerts(userId).map(
        (models) => models.map((model) => model.toEntity()).toList(),
      );
    } catch (e) {
      throw Exception('Failed to get SOS alerts: $e');
    }
  }

  @override
  Future<void> updateSosAlertStatus({
    required String alertId,
    required String status,
  }) async {
    try {
      await remoteDataSource.updateSosAlertStatus(
        alertId: alertId,
        status: status,
      );
    } catch (e) {
      throw Exception('Failed to update SOS alert status: $e');
    }
  }

  @override
  Future<void> addTrustedContact(TrustedContactEntity contact) async {
    try {
      await remoteDataSource.addTrustedContact(contact);
    } catch (e) {
      throw Exception('Failed to add trusted contact: $e');
    }
  }

  @override
  Future<void> removeTrustedContact({
    required String userId,
    required String contactId,
  }) async {
    try {
      await remoteDataSource.removeTrustedContact(
        userId: userId,
        contactId: contactId,
      );
    } catch (e) {
      throw Exception('Failed to remove trusted contact: $e');
    }
  }

  @override
  Stream<List<TrustedContactEntity>> getTrustedContacts(String userId) {
    try {
      return remoteDataSource.getTrustedContacts(userId).map(
        (models) => models.map((model) => model.toEntity()).toList(),
      );
    } catch (e) {
      throw Exception('Failed to get trusted contacts: $e');
    }
  }

  @override
  Future<String> startLiveTracking({
    required String userId,
    required List<String> viewerIds,
  }) async {
    try {
      return await remoteDataSource.startLiveTracking(
        userId: userId,
        viewerIds: viewerIds,
      );
    } catch (e) {
      throw Exception('Failed to start live tracking: $e');
    }
  }

  @override
  Future<void> updateLiveTrackingLocation({
    required String trackingId,
    required LocationEntity location,
  }) async {
    try {
      await remoteDataSource.updateLiveTrackingLocation(
        trackingId: trackingId,
        location: location,
      );
    } catch (e) {
      throw Exception('Failed to update tracking location: $e');
    }
  }

  @override
  Stream<LiveTrackingEntity?> getLiveTracking(String trackingId) {
    try {
      return remoteDataSource.getLiveTracking(trackingId).map(
        (model) => model?.toEntity(),
      );
    } catch (e) {
      throw Exception('Failed to get live tracking: $e');
    }
  }

  @override
  Future<void> stopLiveTracking(String trackingId) async {
    try {
      await remoteDataSource.stopLiveTracking(trackingId);
    } catch (e) {
      throw Exception('Failed to stop live tracking: $e');
    }
  }

  @override
  Future<void> saveShakeAlertSettings(ShakeAlertSettingsEntity settings) async {
    try {
      await remoteDataSource.saveShakeAlertSettings(settings);
    } catch (e) {
      throw Exception('Failed to save shake alert settings: $e');
    }
  }

  @override
  Future<ShakeAlertSettingsEntity?> getShakeAlertSettings(String userId) async {
    try {
      final settings = await remoteDataSource.getShakeAlertSettings(userId);
      return settings?.toEntity();
    } catch (e) {
      throw Exception('Failed to get shake alert settings: $e');
    }
  }

  @override
  Future<void> logFakeCall(FakeCallEntity fakeCall) async {
    try {
      await remoteDataSource.logFakeCall(fakeCall);
    } catch (e) {
      throw Exception('Failed to log fake call: $e');
    }
  }

  @override
  Stream<List<FakeCallEntity>> getFakeCallHistory(String userId) {
    try {
      return remoteDataSource.getFakeCallHistory(userId).map(
        (models) => models.map((model) => model.toEntity()).toList(),
      );
    } catch (e) {
      throw Exception('Failed to get fake call history: $e');
    }
  }
}

