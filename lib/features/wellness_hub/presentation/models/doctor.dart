
/// Doctor Data Model
/// Represents a healthcare provider with consultation options
class Doctor {
  final String name;
  final String specialty; // e.g., 'Gynecologist', 'Psychologist'
  final double rating; // 0.0 to 5.0
  final String imageUrl;
  final bool isChatAvailable;
  final bool isVideoAvailable;

  const Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
    required this.isChatAvailable,
    required this.isVideoAvailable,
  });

  // Get rating as formatted string
  String get ratingString => rating.toStringAsFixed(1);
}

/// Mock Data for Doctors
class DoctorsData {
  static List<Doctor> get doctors => [
    Doctor(
      name: 'Dr. Sarah Ahmed',
      specialty: 'Gynecologist',
      rating: 4.8,
      imageUrl: 'assets/images/doctor1.png',
      isChatAvailable: true,
      isVideoAvailable: true,
    ),
    Doctor(
      name: 'Dr. Fatima Khan',
      specialty: 'Psychologist',
      rating: 4.9,
      imageUrl: 'assets/images/doctor2.png',
      isChatAvailable: true,
      isVideoAvailable: false, // Chat only
    ),
    Doctor(
      name: 'Dr. Ayesha Malik',
      specialty: 'Gynecologist',
      rating: 4.7,
      imageUrl: 'assets/images/doctor3.png',
      isChatAvailable: true,
      isVideoAvailable: true,
    ),
    Doctor(
      name: 'Dr. Zainab Hassan',
      specialty: 'Psychologist',
      rating: 4.6,
      imageUrl: 'assets/images/doctor4.png',
      isChatAvailable: true,
      isVideoAvailable: false, // Chat only
    ),
    Doctor(
      name: 'Dr. Maryam Ali',
      specialty: 'Gynecologist',
      rating: 4.9,
      imageUrl: 'assets/images/doctor5.png',
      isChatAvailable: true,
      isVideoAvailable: true,
    ),
    Doctor(
      name: 'Dr. Hina Sheikh',
      specialty: 'Gynecologist',
      rating: 4.8,
      imageUrl: 'assets/images/doctor6.png',
      isChatAvailable: true,
      isVideoAvailable: false, // Chat only
    ),
  ];
}






