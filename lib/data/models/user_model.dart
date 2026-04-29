import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
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

  AppUser({
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
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String? ?? json['id'] ?? '',
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
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser.fromJson({...data, 'id': doc.id});
  }

  // Copy with method for updating
  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? gender,
    DateTime? dateOfBirth,
    String? location,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? settings,
    List<String>? trustedContacts,
    bool? isVerified,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      settings: settings ?? this.settings,
      trustedContacts: trustedContacts ?? this.trustedContacts,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

