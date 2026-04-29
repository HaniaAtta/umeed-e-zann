/// Domain entity for Trusted Contact (pure Dart, no dependencies)
class TrustedContactEntity {
  final String id;
  final String userId;
  final String contactId;
  final String name;
  final String phone;
  final String? email;
  final String? relation;
  final bool isActive;
  final DateTime addedAt;

  TrustedContactEntity({
    required this.id,
    required this.userId,
    required this.contactId,
    required this.name,
    required this.phone,
    this.email,
    this.relation,
    required this.isActive,
    required this.addedAt,
  });
}

