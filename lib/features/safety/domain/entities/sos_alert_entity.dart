/// Domain entity for SOS Alert (pure Dart, no dependencies)
class SosAlertEntity {
  final String id;
  final String userId;
  final LocationEntity location;
  final String? audioUrl;
  final String message;
  final String status; // 'active', 'resolved', 'cancelled'
  final bool responded;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SosAlertEntity({
    required this.id,
    required this.userId,
    required this.location,
    this.audioUrl,
    required this.message,
    required this.status,
    required this.responded,
    required this.createdAt,
    this.updatedAt,
  });
}

/// Domain entity for Location
class LocationEntity {
  final double lat;
  final double lng;
  final double accuracy;
  final DateTime timestamp;

  LocationEntity({
    required this.lat,
    required this.lng,
    required this.accuracy,
    required this.timestamp,
  });
}

