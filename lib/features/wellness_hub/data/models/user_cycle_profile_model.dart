import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_cycle_profile.dart';

/// Data Transfer Object for UserCycleProfile
class UserCycleProfileModel extends UserCycleProfile {
  UserCycleProfileModel({
    required super.userId,
    super.lastPeriodDate,
    super.averageCycleLength,
    super.averagePeriodLength,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'lastPeriodDate': lastPeriodDate != null
          ? Timestamp.fromDate(lastPeriodDate!)
          : null,
      'averageCycleLength': averageCycleLength,
      'averagePeriodLength': averagePeriodLength,
    };
  }

  /// Create from Firestore document
  factory UserCycleProfileModel.fromJson(Map<String, dynamic> json) {
    return UserCycleProfileModel(
      userId: json['userId'] as String,
      lastPeriodDate: (json['lastPeriodDate'] as Timestamp?)?.toDate(),
      averageCycleLength: json['averageCycleLength'] as int? ?? 28,
      averagePeriodLength: json['averagePeriodLength'] as int? ?? 5,
    );
  }

  /// Create from Firestore document snapshot
  factory UserCycleProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserCycleProfileModel.fromJson({...data, 'userId': doc.id});
  }

  /// Convert domain entity to model
  factory UserCycleProfileModel.fromEntity(UserCycleProfile profile) {
    return UserCycleProfileModel(
      userId: profile.userId,
      lastPeriodDate: profile.lastPeriodDate,
      averageCycleLength: profile.averageCycleLength,
      averagePeriodLength: profile.averagePeriodLength,
    );
  }
}

