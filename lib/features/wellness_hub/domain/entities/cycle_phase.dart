/// Enum for menstrual cycle phases
enum CyclePhase {
  menstruation,
  follicular,
  ovulation,
  luteal,
}

extension CyclePhaseExtension on CyclePhase {
  String get displayName {
    switch (this) {
      case CyclePhase.menstruation:
        return 'Menstruation';
      case CyclePhase.follicular:
        return 'Follicular Phase';
      case CyclePhase.ovulation:
        return 'Ovulation';
      case CyclePhase.luteal:
        return 'Luteal Phase';
    }
  }

  String get description {
    switch (this) {
      case CyclePhase.menstruation:
        return 'Days 1-5: Your period phase';
      case CyclePhase.follicular:
        return 'Days 6-13: Follicular development phase';
      case CyclePhase.ovulation:
        return 'Days 14-16: Ovulation phase';
      case CyclePhase.luteal:
        return 'Days 17-28: Luteal phase before next period';
    }
  }
}

