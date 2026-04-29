import '../entities/cycle_phase.dart';

/// Use case to calculate current cycle phase
class CalculateCyclePhase {
  /// Calculate the current cycle phase based on last period date and current date
  /// 
  /// Returns CyclePhase enum based on day in cycle
  CyclePhase execute({
    required DateTime currentDate,
    required DateTime lastPeriodDate,
    int cycleLength = 28,
  }) {
    // Calculate days since last period
    final daysSinceLastPeriod = currentDate.difference(lastPeriodDate).inDays;
    
    // Handle negative days (future dates)
    if (daysSinceLastPeriod < 0) {
      return CyclePhase.luteal;
    }
    
    // Normalize to current cycle
    final dayInCycle = (daysSinceLastPeriod % cycleLength) + 1;
    
    // Determine phase based on typical cycle
    if (dayInCycle <= 5) {
      return CyclePhase.menstruation;
    } else if (dayInCycle <= 13) {
      return CyclePhase.follicular;
    } else if (dayInCycle <= 16) {
      return CyclePhase.ovulation;
    } else {
      return CyclePhase.luteal;
    }
  }
}

