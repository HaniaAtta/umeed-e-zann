import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/sos_alert_entity.dart';
import '../../domain/entities/live_tracking_entity.dart';

/// Data model for Live Tracking (Firestore DTO)
class LiveTrackingModel {
  final String id;
  final String userId;
  final List<String> viewerIds;
  final String status;
  final DateTime startedAt;
  final DateTime? stoppedAt;
  final List<Map<String, dynamic>> locationsData;
  final DateTime lastUpdated;

  LiveTrackingModel({
    required this.id,
    required this.userId,
    required this.viewerIds,
    required this.status,
    required this.startedAt,
    this.stoppedAt,
    required this.locationsData,
    required this.lastUpdated,
  });

  /// Convert to domain entity
  LiveTrackingEntity toEntity() {
    final locations = locationsData.map((data) {
      return LocationEntity(
        lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
        lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
        accuracy: (data['accuracy'] as num?)?.toDouble() ?? 0.0,
        timestamp: data['timestamp'] is String
            ? DateTime.parse(data['timestamp'] as String)
            : (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();

    return LiveTrackingEntity(
      id: id,
      userId: userId,
      viewerIds: viewerIds,
      status: status,
      startedAt: startedAt,
      stoppedAt: stoppedAt,
      locations: locations,
      lastUpdated: lastUpdated,
    );
  }

  /// Convert from Firestore document
  factory LiveTrackingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LiveTrackingModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      viewerIds: List<String>.from(data['viewerIds'] as List? ?? []),
      status: data['status'] as String? ?? 'active',
      startedAt: (data['startedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      stoppedAt: (data['stoppedAt'] as Timestamp?)?.toDate(),
      locationsData: List<Map<String, dynamic>>.from(
        data['locations'] as List? ?? [],
      ),
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'viewerIds': viewerIds,
      'status': status,
      'startedAt': Timestamp.fromDate(startedAt),
      if (stoppedAt != null) 'stoppedAt': Timestamp.fromDate(stoppedAt!),
      'locations': locationsData,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  /// Convert from domain entity
  factory LiveTrackingModel.fromEntity(LiveTrackingEntity entity) {
    final locationsData = entity.locations.map((location) {
      return {
        'lat': location.lat,
        'lng': location.lng,
        'accuracy': location.accuracy,
        'timestamp': Timestamp.fromDate(location.timestamp),
      };
    }).toList();

    return LiveTrackingModel(
      id: entity.id,
      userId: entity.userId,
      viewerIds: entity.viewerIds,
      status: entity.status,
      startedAt: entity.startedAt,
      stoppedAt: entity.stoppedAt,
      locationsData: locationsData,
      lastUpdated: entity.lastUpdated,
    );
  }
}

