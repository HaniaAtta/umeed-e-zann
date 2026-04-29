/// Domain entity for user cycle profile
class UserCycleProfile {
  final String userId;
  final DateTime? lastPeriodDate;
  final int averageCycleLength; // in days, default 28
  final int averagePeriodLength; // in days, default 5

  UserCycleProfile({
    required this.userId,
    this.lastPeriodDate,
    this.averageCycleLength = 28,
    this.averagePeriodLength = 5,
  });

  UserCycleProfile copyWith({
    String? userId,
    DateTime? lastPeriodDate,
    int? averageCycleLength,
    int? averagePeriodLength,
  }) {
    return UserCycleProfile(
      userId: userId ?? this.userId,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      averageCycleLength: averageCycleLength ?? this.averageCycleLength,
      averagePeriodLength: averagePeriodLength ?? this.averagePeriodLength,
    );
  }
}

