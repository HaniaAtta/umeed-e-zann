import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/cycle_log.dart';

/// Data Transfer Object for CycleLog
class CycleLogModel extends CycleLog {
  CycleLogModel({
    required super.id,
    required super.date,
    required super.flowIntensity,
    required super.painLevel,
    required super.energyLevel,
    required super.symptoms,
    super.mood,
    super.physicalSymptoms,
    super.notes,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': Timestamp.fromDate(date),
      'flowIntensity': flowIntensity,
      'painLevel': painLevel,
      'energyLevel': energyLevel,
      'symptoms': symptoms,
      'mood': mood,
      'physicalSymptoms': physicalSymptoms,
      'notes': notes,
    };
  }

  /// Create from Firestore document
  factory CycleLogModel.fromJson(Map<String, dynamic> json) {
    return CycleLogModel(
      id: json['id'] as String? ?? json['id'] ?? '',
      date: (json['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      flowIntensity: json['flowIntensity'] as int? ?? 1,
      painLevel: json['painLevel'] as int? ?? 1,
      energyLevel: json['energyLevel'] as int? ?? 5,
      symptoms: (json['symptoms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      mood: json['mood'] as String?,
      physicalSymptoms: (json['physicalSymptoms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      notes: json['notes'] as String?,
    );
  }

  /// Create from Firestore document snapshot
  factory CycleLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CycleLogModel.fromJson({...data, 'id': doc.id});
  }

  /// Convert domain entity to model
  factory CycleLogModel.fromEntity(CycleLog log) {
    return CycleLogModel(
      id: log.id,
      date: log.date,
      flowIntensity: log.flowIntensity,
      painLevel: log.painLevel,
      energyLevel: log.energyLevel,
      symptoms: log.symptoms,
      mood: log.mood,
      physicalSymptoms: log.physicalSymptoms,
      notes: log.notes,
    );
  }
}

