/// Domain entity for Verification (pure Dart, no dependencies)
class VerificationEntity {
  final String id;
  final String userId;
  final String verificationType; // 'identity', 'business', 'document'
  final String status; // 'pending', 'approved', 'rejected'
  final Map<String, dynamic>? documents;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewNotes;

  VerificationEntity({
    required this.id,
    required this.userId,
    required this.verificationType,
    required this.status,
    this.documents,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewNotes,
  });
}

