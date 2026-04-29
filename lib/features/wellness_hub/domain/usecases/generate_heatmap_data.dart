import '../entities/cycle_log.dart';

/// Use case to generate heatmap data from cycle logs
class GenerateHeatmapData {
  /// Generate heatmap data mapping dates to intensity values
  /// 
  /// Returns a Map where key is DateTime and value is intensity (0-10)
  /// Can be used for pain level or energy level heatmaps
  Map<DateTime, int> execute({
    required List<CycleLog> logs,
    required bool usePainLevel, // true for pain, false for energy
  }) {
    final Map<DateTime, int> heatmapData = {};
    
    for (final log in logs) {
      // Normalize date to remove time component
      final date = DateTime(log.date.year, log.date.month, log.date.day);
      final intensity = usePainLevel ? log.painLevel : log.energyLevel;
      heatmapData[date] = intensity;
    }
    
    return heatmapData;
  }
}

