/// Domain entity for contraceptive method recommendation
class ContraceptiveMethod {
  final String name;
  final double efficacy; // 0.0 to 1.0 (e.g., 0.99 = 99%)
  final String whyItFits; // Explanation of why this method fits

  ContraceptiveMethod({
    required this.name,
    required this.efficacy,
    required this.whyItFits,
  });

  /// Get efficacy as percentage string
  String get efficacyPercentage => '${(efficacy * 100).toInt()}%';
}


