import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/fake_call_entity.dart';

/// Data model for Fake Call (Firestore DTO)
class FakeCallModel {
  final String id;
  final String userId;
  final String? contactName;
  final String? contactNumber;
  final DateTime scheduledTime;
  final DateTime createdAt;
  final int duration;

  FakeCallModel({
    required this.id,
    required this.userId,
    this.contactName,
    this.contactNumber,
    required this.scheduledTime,
    required this.createdAt,
    this.duration = 0,
  });

  /// Convert to domain entity
  FakeCallEntity toEntity() {
    return FakeCallEntity(
      id: id,
      userId: userId,
      contactName: contactName,
      contactNumber: contactNumber,
      scheduledTime: scheduledTime,
      createdAt: createdAt,
      duration: duration,
    );
  }

  /// Convert from Firestore document
  factory FakeCallModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FakeCallModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      contactName: data['contactName'] as String?,
      contactNumber: data['contactNumber'] as String?,
      scheduledTime: (data['scheduledTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      duration: (data['duration'] as num?)?.toInt() ?? 0,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      if (contactName != null) 'contactName': contactName,
      if (contactNumber != null) 'contactNumber': contactNumber,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'createdAt': Timestamp.fromDate(createdAt),
      'duration': duration,
    };
  }

  /// Convert from domain entity
  factory FakeCallModel.fromEntity(FakeCallEntity entity) {
    return FakeCallModel(
      id: entity.id,
      userId: entity.userId,
      contactName: entity.contactName,
      contactNumber: entity.contactNumber,
      scheduledTime: entity.scheduledTime,
      createdAt: entity.createdAt,
      duration: entity.duration,
    );
  }
}

