import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/trusted_contact_entity.dart';

/// Data model for Trusted Contact (Firestore DTO)
class TrustedContactModel {
  final String id;
  final String userId;
  final String contactId;
  final String name;
  final String phone;
  final String? email;
  final String? relation;
  final bool isActive;
  final DateTime addedAt;

  TrustedContactModel({
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

  /// Convert to domain entity
  TrustedContactEntity toEntity() {
    return TrustedContactEntity(
      id: id,
      userId: userId,
      contactId: contactId,
      name: name,
      phone: phone,
      email: email,
      relation: relation,
      isActive: isActive,
      addedAt: addedAt,
    );
  }

  /// Convert from Firestore document
  factory TrustedContactModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TrustedContactModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      contactId: data['contactId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      email: data['email'] as String?,
      relation: data['relation'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'contactId': contactId,
      'name': name,
      'phone': phone,
      if (email != null) 'email': email,
      if (relation != null) 'relation': relation,
      'isActive': isActive,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  /// Convert from domain entity
  factory TrustedContactModel.fromEntity(TrustedContactEntity entity) {
    return TrustedContactModel(
      id: entity.id,
      userId: entity.userId,
      contactId: entity.contactId,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      relation: entity.relation,
      isActive: entity.isActive,
      addedAt: entity.addedAt,
    );
  }
}

