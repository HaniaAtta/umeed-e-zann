/// Domain entity for User (pure Dart, no dependencies)
class UserEntity {
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

  UserEntity({
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

  UserEntity copyWith({
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
    return UserEntity(
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

