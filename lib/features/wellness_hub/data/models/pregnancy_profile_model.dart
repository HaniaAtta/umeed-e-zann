import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/pregnancy_profile.dart';

/// Data Transfer Object for PregnancyProfile
class PregnancyProfileModel extends PregnancyProfile {
  PregnancyProfileModel({
    required super.userId,
    required super.dueDate,
    super.conceptionDate,
    super.currentWeight,
    super.notes,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'dueDate': Timestamp.fromDate(dueDate),
      'conceptionDate': conceptionDate != null
          ? Timestamp.fromDate(conceptionDate!)
          : null,
      'currentWeight': currentWeight,
      'notes': notes,
    };
  }

  /// Create from Firestore document
  factory PregnancyProfileModel.fromJson(Map<String, dynamic> json) {
    return PregnancyProfileModel(
      userId: json['userId'] as String,
      dueDate: (json['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      conceptionDate: (json['conceptionDate'] as Timestamp?)?.toDate(),
      currentWeight: (json['currentWeight'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }

  /// Create from Firestore document snapshot
  factory PregnancyProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PregnancyProfileModel.fromJson({...data, 'userId': doc.id});
  }

  /// Convert domain entity to model
  factory PregnancyProfileModel.fromEntity(PregnancyProfile profile) {
    return PregnancyProfileModel(
      userId: profile.userId,
      dueDate: profile.dueDate,
      conceptionDate: profile.conceptionDate,
      currentWeight: profile.currentWeight,
      notes: profile.notes,
    );
  }
}

