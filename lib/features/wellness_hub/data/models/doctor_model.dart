import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/doctor.dart';

/// Data Transfer Object for Doctor
class DoctorModel extends Doctor {
  DoctorModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.rating,
    super.imageUrl,
    required super.isChatAvailable,
    required super.isVideoAvailable,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'imageUrl': imageUrl,
      'isChatAvailable': isChatAvailable,
      'isVideoAvailable': isVideoAvailable,
    };
  }

  /// Create from Firestore document
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String?,
      isChatAvailable: json['isChatAvailable'] as bool? ?? false,
      isVideoAvailable: json['isVideoAvailable'] as bool? ?? false,
    );
  }

  /// Create from Firestore document snapshot
  factory DoctorModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DoctorModel.fromJson({...data, 'id': doc.id});
  }

  /// Convert domain entity to model
  factory DoctorModel.fromEntity(Doctor doctor) {
    return DoctorModel(
      id: doctor.id,
      name: doctor.name,
      specialty: doctor.specialty,
      rating: doctor.rating,
      imageUrl: doctor.imageUrl,
      isChatAvailable: doctor.isChatAvailable,
      isVideoAvailable: doctor.isVideoAvailable,
    );
  }
}


