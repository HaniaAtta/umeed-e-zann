import 'sos_alert_entity.dart';

/// Domain entity for Live Tracking (pure Dart, no dependencies)
class LiveTrackingEntity {
  final String id;
  final String userId;
  final List<String> viewerIds;
  final String status; // 'active', 'stopped'
  final DateTime startedAt;
  final DateTime? stoppedAt;
  final List<LocationEntity> locations;
  final DateTime lastUpdated;

  LiveTrackingEntity({
    required this.id,
    required this.userId,
    required this.viewerIds,
    required this.status,
    required this.startedAt,
    this.stoppedAt,
    required this.locations,
    required this.lastUpdated,
  });
}

