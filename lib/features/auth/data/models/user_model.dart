import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

/// Data model for User (DTO - Data Transfer Object)
class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? location;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? settings;
  final List<String>? trustedContacts;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.location,
    this.profileImageUrl,
    required this.createdAt,
    this.updatedAt,
    this.settings,
    this.trustedContacts,
    this.isVerified = false,
  });

  // Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'location': location,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'settings': settings ?? {},
      'trustedContacts': trustedContacts ?? [],
      'isVerified': isVerified,
    };
  }

  // Create from Firestore document
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      location: json['location'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
      settings: json['settings'] as Map<String, dynamic>?,
      trustedContacts: (json['trustedContacts'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  // Create from Firestore document snapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({...data, 'id': doc.id});
  }

  // Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      phone: phone,
      gender: gender,
      dateOfBirth: dateOfBirth,
      location: location,
      profileImageUrl: profileImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      settings: settings,
      trustedContacts: trustedContacts,
      isVerified: isVerified,
    );
  }

  // Create from domain entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      phone: entity.phone,
      gender: entity.gender,
      dateOfBirth: entity.dateOfBirth,
      location: entity.location,
      profileImageUrl: entity.profileImageUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      settings: entity.settings,
      trustedContacts: entity.trustedContacts,
      isVerified: entity.isVerified,
    );
  }
}

