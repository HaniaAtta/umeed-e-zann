/// Domain entity for Fake Call (pure Dart, no dependencies)
class FakeCallEntity {
  final String id;
  final String userId;
  final String? contactName;
  final String? contactNumber;
  final DateTime scheduledTime;
  final DateTime createdAt;
  final int duration; // seconds

  FakeCallEntity({
    required this.id,
    required this.userId,
    this.contactName,
    this.contactNumber,
    required this.scheduledTime,
    required this.createdAt,
    this.duration = 0,
  });
}

