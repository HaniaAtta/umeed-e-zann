import '../entities/quiz_result.dart';

/// Contraception method properties
class ContraceptionMethod {
  final String name;
  final Map<String, double> properties; // e.g., {'hormonal_sensitivity': 0.0, 'long_term': 1.0}
  final String description;
  final double effectiveness; // 0.0 to 1.0

  ContraceptionMethod({
    required this.name,
    required this.properties,
    required this.description,
    required this.effectiveness,
  });
}

/// Service to match user preferences with contraception methods
class ContraceptionMatcher {
  // Static method properties database
  static final List<ContraceptionMethod> _methods = [
    ContraceptionMethod(
      name: 'Birth Control Pill',
      properties: {
        'hormonal_sensitivity': 1.0, // Highly hormonal
        'long_term': 0.5, // Daily use
        'discreet': 0.8,
        'reversible': 1.0,
        'low_maintenance': 0.6, // Daily reminder needed
      },
      description: 'Daily oral contraceptive pill',
      effectiveness: 0.91,
    ),
    ContraceptionMethod(
      name: 'IUD (Intrauterine Device)',
      properties: {
        'hormonal_sensitivity': 0.5, // Some IUDs are hormonal, some not
        'long_term': 1.0, // 3-10 years
        'discreet': 1.0,
        'reversible': 1.0,
        'low_maintenance': 1.0, // Set and forget
      },
      description: 'Long-term reversible contraception',
      effectiveness: 0.99,
    ),
    ContraceptionMethod(
      name: 'Condom',
      properties: {
        'hormonal_sensitivity': 0.0, // Non-hormonal
        'long_term': 0.0, // Per-use
        'discreet': 0.7,
        'reversible': 1.0,
        'low_maintenance': 0.8, // Use when needed
        'std_protection': 1.0, // Bonus property
      },
      description: 'Barrier method with STD protection',
      effectiveness: 0.85,
    ),
    ContraceptionMethod(
      name: 'Implant',
      properties: {
        'hormonal_sensitivity': 1.0,
        'long_term': 1.0, // 3-5 years
        'discreet': 1.0,
        'reversible': 1.0,
        'low_maintenance': 1.0,
      },
      description: 'Small rod inserted under the skin',
      effectiveness: 0.99,
    ),
    ContraceptionMethod(
      name: 'Depo Shot',
      properties: {
        'hormonal_sensitivity': 1.0,
        'long_term': 0.7, // Every 3 months
        'discreet': 0.9,
        'reversible': 1.0,
        'low_maintenance': 0.8, // Quarterly shots
      },
      description: 'Hormonal injection every 3 months',
      effectiveness: 0.94,
    ),
    ContraceptionMethod(
      name: 'Natural Family Planning',
      properties: {
        'hormonal_sensitivity': 0.0,
        'long_term': 0.5,
        'discreet': 1.0,
        'reversible': 1.0,
        'low_maintenance': 0.4, // Daily tracking needed
      },
      description: 'Tracking fertility signs',
      effectiveness: 0.76,
    ),
  ];

  /// Match user answers with contraception methods using weighted scoring
  QuizResult matchMethod(Map<String, dynamic> userAnswers) {
    final Map<String, double> scores = {};

    // Calculate weighted score for each method
    for (final method in _methods) {
      double score = 0.0;
      double totalWeight = 0.0;

      // Compare each user answer with method properties
      for (final entry in userAnswers.entries) {
        final key = entry.key;
        final userValue = entry.value;

        if (method.properties.containsKey(key)) {
          final methodValue = method.properties[key]!;
          final userBool = userValue is bool ? (userValue ? 1.0 : 0.0) : userValue;

          // Weight: how important this property is (can be customized)
          final weight = _getPropertyWeight(key);
          totalWeight += weight;

          // Calculate match: closer values = higher score
          final difference = (userBool - methodValue).abs();
          score += weight * (1.0 - difference);
        }
      }

      // Normalize score
      if (totalWeight > 0) {
        scores[method.name] = (score / totalWeight) * method.effectiveness;
      } else {
        scores[method.name] = method.effectiveness * 0.5;
      }
    }

    // Find best match
    String bestMethod = scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    double bestScore = scores[bestMethod]!;

    // Get alternative methods (top 3 excluding best)
    final sortedMethods = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final alternatives = sortedMethods
        .where((e) => e.key != bestMethod)
        .take(2)
        .map((e) => e.key)
        .toList();

    return QuizResult(
      recommendedMethod: bestMethod,
      matchScore: bestScore,
      userAnswers: userAnswers,
      completedAt: DateTime.now(),
      alternativeMethods: alternatives,
    );
  }

  /// Get weight for property (importance)
  double _getPropertyWeight(String property) {
    // More important properties get higher weights
    switch (property) {
      case 'hormonal_sensitivity':
        return 2.0;
      case 'long_term':
        return 1.5;
      case 'reversible':
        return 1.5;
      case 'low_maintenance':
        return 1.0;
      case 'discreet':
        return 0.8;
      case 'std_protection':
        return 1.2;
      default:
        return 1.0;
    }
  }

  /// Get all available methods (for UI display)
  static List<ContraceptionMethod> getAllMethods() => _methods;
}

