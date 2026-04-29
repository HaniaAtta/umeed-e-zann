import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/verification_entity.dart';

/// Data model for Verification (Firestore DTO)
class VerificationModel {
  final String id;
  final String userId;
  final String verificationType;
  final String status;
  final Map<String, dynamic>? documents;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewNotes;

  VerificationModel({
    required this.id,
    required this.userId,
    required this.verificationType,
    required this.status,
    this.documents,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewNotes,
  });

  /// Convert to domain entity
  VerificationEntity toEntity() {
    return VerificationEntity(
      id: id,
      userId: userId,
      verificationType: verificationType,
      status: status,
      documents: documents,
      submittedAt: submittedAt,
      reviewedAt: reviewedAt,
      reviewNotes: reviewNotes,
    );
  }

  /// Convert from Firestore document
  factory VerificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VerificationModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      verificationType: data['verificationType'] as String? ?? 'identity',
      status: data['status'] as String? ?? 'pending',
      documents: data['documents'] as Map<String, dynamic>?,
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reviewedAt: (data['reviewedAt'] as Timestamp?)?.toDate(),
      reviewNotes: data['reviewNotes'] as String?,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'verificationType': verificationType,
      'status': status,
      if (documents != null) 'documents': documents,
      'submittedAt': Timestamp.fromDate(submittedAt),
      if (reviewedAt != null) 'reviewedAt': Timestamp.fromDate(reviewedAt!),
      if (reviewNotes != null) 'reviewNotes': reviewNotes,
    };
  }

  /// Convert from domain entity
  factory VerificationModel.fromEntity(VerificationEntity entity) {
    return VerificationModel(
      id: entity.id,
      userId: entity.userId,
      verificationType: entity.verificationType,
      status: entity.status,
      documents: entity.documents,
      submittedAt: entity.submittedAt,
      reviewedAt: entity.reviewedAt,
      reviewNotes: entity.reviewNotes,
    );
  }
}

