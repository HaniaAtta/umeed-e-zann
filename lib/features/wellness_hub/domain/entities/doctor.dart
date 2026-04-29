/// Domain entity for healthcare provider
class Doctor {
  final String id;
  final String name;
  final String specialty; // e.g., 'Gynecologist', 'Psychologist'
  final double rating; // 0.0 to 5.0
  final String? imageUrl;
  final bool isChatAvailable;
  final bool isVideoAvailable;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    this.imageUrl,
    required this.isChatAvailable,
    required this.isVideoAvailable,
  });

  Doctor copyWith({
    String? id,
    String? name,
    String? specialty,
    double? rating,
    String? imageUrl,
    bool? isChatAvailable,
    bool? isVideoAvailable,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      isChatAvailable: isChatAvailable ?? this.isChatAvailable,
      isVideoAvailable: isVideoAvailable ?? this.isVideoAvailable,
    );
  }
}


