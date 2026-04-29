/// Application-wide constants
class AppConstants {
  // App info
  static const String appName = 'امید زن';
  static const String appTagline = 'Empowering Women Together';

  // Marketplace constants
  static const int maxProductImages = 5;
  static const int maxProductTitleLength = 100;
  static const int maxProductDescriptionLength = 1000;
  static const double minProductPrice = 0.01;
  static const double maxProductPrice = 1000000.00;

  // Community constants
  static const int maxPostTitleLength = 200;
  static const int maxPostContentLength = 5000;
  static const int maxCommentLength = 1000;

  // Verification constants
  static const int maxVerificationDocuments = 3;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'pdf'];

  // Chat constants
  static const int maxMessageLength = 1000;
  static const int maxAttachmentSize = 10 * 1024 * 1024; // 10MB

  // Pagination
  static const int itemsPerPage = 20;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}

