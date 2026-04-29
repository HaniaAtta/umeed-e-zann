import 'package:flutter/material.dart';

/// Contraception Method Data Model
/// Represents a family planning method with its properties
class ContraceptionMethod {
  final String name;
  final double efficacy; // 0.0 to 1.0 (e.g., 0.99 = 99%)
  final List<String> pros;
  final List<String> cons;
  final IconData icon;
  final String mythBuster; // Educational fact

  const ContraceptionMethod({
    required this.name,
    required this.efficacy,
    required this.pros,
    required this.cons,
    required this.icon,
    required this.mythBuster,
  });

  // Get efficacy as percentage string
  String get efficacyPercentage => '${(efficacy * 100).toInt()}%';
}

/// Mock Data for Contraception Methods
class ContraceptionMethodsData {
  static List<ContraceptionMethod> get methods => [
    ContraceptionMethod(
      name: 'The Pill',
      efficacy: 0.99,
      pros: [
        'Highly effective when taken correctly',
        'Regulates menstrual cycle',
        'Reduces menstrual cramps',
        'Can improve acne',
      ],
      cons: [
        'Must be taken daily at the same time',
        'May cause nausea initially',
        'Requires prescription',
        'Does not protect against STIs',
      ],
      icon: Icons.medication_rounded,
      mythBuster: 'The pill does not cause infertility. Fertility returns quickly after stopping.',
    ),
    ContraceptionMethod(
      name: 'IUD',
      efficacy: 0.99,
      pros: [
        'Long-lasting (3-10 years)',
        'Highly effective',
        'Low maintenance',
        'Reversible',
      ],
      cons: [
        'Requires insertion by healthcare provider',
        'May cause cramping initially',
        'Some discomfort during insertion',
        'Does not protect against STIs',
      ],
      icon: Icons.medical_services_rounded,
      mythBuster: 'IUDs are safe for women who have never been pregnant.',
    ),
    ContraceptionMethod(
      name: 'Implant',
      efficacy: 0.99,
      pros: [
        'Lasts up to 3-5 years',
        'Highly effective',
        'Set and forget',
        'Reversible',
      ],
      cons: [
        'Requires minor procedure for insertion/removal',
        'May cause irregular bleeding',
        'Visible under skin',
        'Does not protect against STIs',
      ],
      icon: Icons.healing_rounded,
      mythBuster: 'The implant does not cause weight gain in most users.',
    ),
    ContraceptionMethod(
      name: 'Calendar Method',
      efficacy: 0.76,
      pros: [
        'No hormones or devices',
        'Natural method',
        'Free',
        'No side effects',
      ],
      cons: [
        'Less effective than other methods',
        'Requires tracking and discipline',
        'Irregular cycles make it difficult',
        'Does not protect against STIs',
      ],
      icon: Icons.calendar_today_rounded,
      mythBuster: 'The calendar method requires careful tracking and is less reliable than hormonal methods.',
    ),
  ];
}






