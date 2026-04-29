/// Use case to calculate current pregnancy week
class CalculatePregnancyWeek {
  /// Calculate current week of pregnancy (1-40) from due date
  /// 
  /// Standard calculation: 40 weeks from last menstrual period (LMP)
  /// Due date is typically 40 weeks from LMP
  /// Returns current week number (1-40)
  int execute(DateTime dueDate) {
    final today = DateTime.now();
    final daysUntilDue = dueDate.difference(today).inDays;
    final weeksUntilDue = daysUntilDue ~/ 7;
    final weeksPregnant = 40 - weeksUntilDue;
    
    // Clamp between 1 and 40
    if (weeksPregnant < 1) return 1;
    if (weeksPregnant > 40) return 40;
    
    return weeksPregnant;
  }

  /// Calculate current week from last menstrual period (LMP)
  /// Alternative method if LMP is known
  int executeFromLMP(DateTime lastMenstrualPeriod) {
    final today = DateTime.now();
    final daysPregnant = today.difference(lastMenstrualPeriod).inDays;
    final weeksPregnant = (daysPregnant ~/ 7) + 1; // +1 because week 1 starts at day 0
    
    // Clamp between 1 and 40
    if (weeksPregnant < 1) return 1;
    if (weeksPregnant > 40) return 40;
    
    return weeksPregnant;
  }
}

