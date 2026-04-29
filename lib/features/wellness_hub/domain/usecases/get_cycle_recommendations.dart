import '../entities/cycle_phase.dart';

/// Recommendation data class
class CycleRecommendation {
  final List<String> dietTips;
  final List<String> exerciseTips;
  final List<String> wellnessTips;

  CycleRecommendation({
    required this.dietTips,
    required this.exerciseTips,
    required this.wellnessTips,
  });
}

/// Use case to get recommendations based on cycle phase
class GetCycleRecommendations {
  /// Get diet and exercise recommendations based on cycle phase
  CycleRecommendation execute(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstruation:
        return CycleRecommendation(
          dietTips: [
            'Focus on iron-rich foods (spinach, lentils, lean meats)',
            'Include magnesium-rich foods (dark chocolate, nuts, seeds)',
            'Stay hydrated with warm herbal teas',
            'Reduce caffeine intake if experiencing cramps',
          ],
          exerciseTips: [
            'Gentle yoga or stretching',
            'Light walking (15-30 minutes)',
            'Avoid intense workouts - listen to your body',
            'Restorative activities are best',
          ],
          wellnessTips: [
            'Prioritize rest and self-care',
            'Use heat pads for cramps',
            'Practice mindfulness and meditation',
            'Get adequate sleep (7-9 hours)',
          ],
        );
        
      case CyclePhase.follicular:
        return CycleRecommendation(
          dietTips: [
            'Eat balanced meals with protein and complex carbs',
            'Include fresh fruits and vegetables',
            'Maintain steady energy with regular meals',
            'Incorporate omega-3 rich foods',
          ],
          exerciseTips: [
            'Build up workout intensity gradually',
            'Cardio exercises are great (running, cycling)',
            'Strength training works well during this phase',
            'Try new activities - your energy is increasing',
          ],
          wellnessTips: [
            'Great time for new goals and planning',
            'Energy levels are rising - take advantage',
            'Focus on building healthy habits',
            'Social activities feel good during this phase',
          ],
        );
        
      case CyclePhase.ovulation:
        return CycleRecommendation(
          dietTips: [
            'Maintain balanced nutrition',
            'Include anti-inflammatory foods',
            'Stay well-hydrated',
            'Eat regular meals to maintain energy',
          ],
          exerciseTips: [
            'Peak performance time - push yourself',
            'High-intensity workouts are ideal',
            'Strength training and heavy lifting',
            'Competitive sports or challenging activities',
          ],
          wellnessTips: [
            'Peak energy and confidence period',
            'Great time for important decisions',
            'Social activities and networking',
            'Take on challenging projects',
          ],
        );
        
      case CyclePhase.luteal:
        return CycleRecommendation(
          dietTips: [
            'Include complex carbs for mood stability',
            'Eat smaller, more frequent meals',
            'Limit processed foods and sugar',
            'Increase fiber intake to manage bloating',
          ],
          exerciseTips: [
            'Moderate intensity workouts',
            'Yoga and Pilates are beneficial',
            'Steady-state cardio (not too intense)',
            'Focus on consistency over intensity',
          ],
          wellnessTips: [
            'Practice stress management techniques',
            'Prioritize sleep and relaxation',
            'Plan lighter schedules if possible',
            'Self-compassion and understanding',
          ],
        );
    }
  }
}

