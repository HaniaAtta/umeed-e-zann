import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/course_progress_entity.dart';

/// Data model for Certificate (Firestore DTO)
class CertificateModel {
  final String id;
  final String userId;
  final String courseId;
  final String courseTitle;
  final DateTime issuedAt;
  final String certificateUrl;
  final String certificateNumber;

  CertificateModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseTitle,
    required this.issuedAt,
    required this.certificateUrl,
    required this.certificateNumber,
  });

  /// Convert to domain entity
  CertificateEntity toEntity() {
    return CertificateEntity(
      id: id,
      userId: userId,
      courseId: courseId,
      courseTitle: courseTitle,
      issuedAt: issuedAt,
      certificateUrl: certificateUrl,
      certificateNumber: certificateNumber,
    );
  }

  /// Convert from Firestore document
  factory CertificateModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CertificateModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      courseId: data['courseId'] as String? ?? '',
      courseTitle: data['courseTitle'] as String? ?? '',
      issuedAt: (data['issuedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      certificateUrl: data['certificateUrl'] as String? ?? '',
      certificateNumber: data['certificateNumber'] as String? ?? '',
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'issuedAt': Timestamp.fromDate(issuedAt),
      'certificateUrl': certificateUrl,
      'certificateNumber': certificateNumber,
    };
  }

  /// Convert from domain entity
  factory CertificateModel.fromEntity(CertificateEntity entity) {
    return CertificateModel(
      id: entity.id,
      userId: entity.userId,
      courseId: entity.courseId,
      courseTitle: entity.courseTitle,
      issuedAt: entity.issuedAt,
      certificateUrl: entity.certificateUrl,
      certificateNumber: entity.certificateNumber,
    );
  }
}

