import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/sos_alert_entity.dart';

/// Data model for SOS Alert (Firestore DTO)
class SosAlertModel {
  final String id;
  final String userId;
  final Map<String, dynamic> locationData;
  final String? audioUrl;
  final String message;
  final String status;
  final bool responded;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SosAlertModel({
    required this.id,
    required this.userId,
    required this.locationData,
    this.audioUrl,
    required this.message,
    required this.status,
    required this.responded,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert to domain entity
  SosAlertEntity toEntity() {
    return SosAlertEntity(
      id: id,
      userId: userId,
      location: LocationEntity(
        lat: (locationData['lat'] as num?)?.toDouble() ?? 0.0,
        lng: (locationData['lng'] as num?)?.toDouble() ?? 0.0,
        accuracy: (locationData['accuracy'] as num?)?.toDouble() ?? 0.0,
        timestamp: locationData['timestamp'] is String
            ? DateTime.parse(locationData['timestamp'] as String)
            : (locationData['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ),
      audioUrl: audioUrl,
      message: message,
      status: status,
      responded: responded,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert from Firestore document
  factory SosAlertModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SosAlertModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      locationData: Map<String, dynamic>.from(data['location'] as Map? ?? {}),
      audioUrl: data['audioUrl'] as String?,
      message: data['message'] as String? ?? 'Emergency SOS Alert',
      status: data['status'] as String? ?? 'active',
      responded: data['responded'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'location': locationData,
      if (audioUrl != null) 'audioUrl': audioUrl,
      'message': message,
      'status': status,
      'responded': responded,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  /// Convert from domain entity
  factory SosAlertModel.fromEntity(SosAlertEntity entity) {
    return SosAlertModel(
      id: entity.id,
      userId: entity.userId,
      locationData: {
        'lat': entity.location.lat,
        'lng': entity.location.lng,
        'accuracy': entity.location.accuracy,
        'timestamp': entity.location.timestamp.toIso8601String(),
      },
      audioUrl: entity.audioUrl,
      message: entity.message,
      status: entity.status,
      responded: entity.responded,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

