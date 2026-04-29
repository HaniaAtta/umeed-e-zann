import 'package:flutter/material.dart';

class AppColors {
  // Color Palette from Design
  static const Color darkPurple = Color(0xFF250E2C);
  static const Color mediumBluePurple = Color(0xFF837AB6);
  static const Color mediumPurple = Color(0xFF9D85B6);
  static const Color dustyRose = Color(0xFFCC8DB3);
  static const Color softPink = Color(0xFFF6A5C0);
  static const Color lightPink = Color(0xFFF7C2CA);

  // Additional Colors for UI
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF424242);
  static const Color red = Color(0xFFE53935);
  static const Color green = Color(0xFF4CAF50);
  static const Color amber = Color(0xFFFFC107);

  // Pastel Creamy Background Colors
  static const Color creamBackground = Color(0xFFFAF7F2); // Very pastel creamy
  static const Color lightCream = Color(0xFFFDFBF8);
  static const Color warmCream = Color(0xFFF8F5F0);

  // Background Colors
  static const Color primaryBackground = creamBackground; // Pastel creamy background
  static const Color secondaryBackground = lightPink;

  // Text Colors
  static const Color primaryText = darkPurple;
  static const Color secondaryText = darkGrey;
  static const Color lightText = white;

  // Accent Colors
  static const Color primaryAccent = mediumPurple;
  static const Color secondaryAccent = softPink;
  static const Color dangerColor = red;
  static const Color successColor = green;

  // Unified Primary Colors (removing duplicates)
  static const Color primaryDark = Color(0xFF250e2c);
  static const Color primaryPurple = Color(0xFF837ab6);
  static const Color primaryLightPurple = Color(0xFF9d85b6);
  static const Color primaryPink = Color(0xFFcc8db3);
  static const Color primaryLightPink = Color(0xFFf6a5c0);
  static const Color primaryVeryLightPink = Color(0xFFf7c2ca);
  
  // Aliases for compatibility
  static const Color secondaryPurple = primaryPurple;
  static const Color accentPurple = primaryLightPurple;
  static const Color accentPink = primaryPink;
  static const Color lighterPink = primaryVeryLightPink;
  static const Color dustyPink = primaryPink;
  static const Color palePink = primaryVeryLightPink;

  // Background - Clean and Professional
  static const Color background = Color(0xFFF8F9FA); // Clean light gray
  static const Color lighterBeige = Color(0xFFF8F9FA);
  static const Color screenBackground = background;
  static const Color textDark = primaryDark;
  static const Color textLight = white;

  // Intermediate shades for better gradients
  static const Color purpleMid = Color(0xFF907fb6); // Between 837ab6 and 9d85b6
  static const Color pinkMid = Color(0xFFd99fa9); // Between cc8db3 and f6a5c0
  static const Color pinkLightMid = Color(0xFFf6b3c5); // Between f6a5c0 and f7c2ca

  // Futuristic gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryDark,
      Color(0xFF4a1a5c),
      primaryPurple,
      primaryLightPurple,
      primaryPink,
      primaryLightPink,
      primaryVeryLightPink,
    ],
    stops: [0.0, 0.2, 0.4, 0.6, 0.8, 0.9, 1.0],
  );

  // Elegant card colors - Clean and modern
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorderColor = Color(0xFFE8E0F0); // Very light purple-grey
  static const Color cardAccentColor = Color(0xFFF5F0FA); // Subtle purple tint

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryPink,
      primaryLightPink,
      primaryVeryLightPink,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient appBarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryDark,
      Color(0xFF3d1a4d), // Slightly lighter dark
      Color(0xFF5a2d6b), // Mid purple
      primaryPurple,
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  static const LinearGradient neonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryPurple,
      primaryLightPurple,
      primaryPink,
      primaryLightPink,
    ],
    stops: [0.0, 0.4, 0.7, 1.0],
  );

  static const LinearGradient bottomNavGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryDark,
      Color(0xFF3a1a4a),
      Color(0xFF4d1f5a),
      primaryDark,
    ],
    stops: [0.0, 0.4, 0.7, 1.0],
  );

  // Balanced Semantic colors
  static const Color success = Color(0xFF66bb6a); // Softer green
  static const Color error = Color(0xFFef5350); // Softer red
  static const Color warning = Color(0xFFFFB74D); // Softer orange
  static const Color info = Color(0xFF42a5f5); // Softer blue

  // Neutral colors (already defined above, removing duplicates)

  // Balanced Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA); // Clean white background
  static const Color backgroundDark = Color(0xFF1E1E1E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5); // Light grey

  // Subtle Glow effects - Toned down
  static List<BoxShadow> get neonGlow => [
    BoxShadow(
      color: primaryPink.withValues(alpha: 0.25),
      blurRadius: 15,
      spreadRadius: 0,
      offset: const Offset(0, 0),
    ),
    BoxShadow(
      color: primaryPurple.withValues(alpha: 0.2),
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(0, 0),
    ),
  ];

  static List<BoxShadow> get cardGlow => [
    BoxShadow(
      color: primaryPurple.withValues(alpha: 0.12),
      blurRadius: 16,
      spreadRadius: 0,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: primaryPink.withValues(alpha: 0.08),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 3),
    ),
  ];

  static List<BoxShadow> get buttonGlow => [
    BoxShadow(
      color: primaryPink.withValues(alpha: 0.35),
      blurRadius: 15,
      spreadRadius: 1,
      offset: const Offset(0, 5),
    ),
    BoxShadow(
      color: primaryLightPink.withValues(alpha: 0.25),
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];
}

