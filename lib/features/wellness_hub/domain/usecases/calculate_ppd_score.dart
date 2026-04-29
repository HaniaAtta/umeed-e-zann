/// Edinburgh Postnatal Depression Scale questions
class PPDQuestion {
  final String id;
  final String text;
  final List<String> options; // 4 options with scores 0-3

  PPDQuestion({
    required this.id,
    required this.text,
    required this.options,
  });
}

/// Use case to calculate PPD score from Edinburgh Scale answers
class CalculatePPDScore {
  /// Calculate total score from answers
  /// 
  /// Edinburgh Scale: 10 questions, each scored 0-3
  /// Total possible: 0-30
  /// Threshold for concern: >13
  int execute(Map<String, int> answers) {
    int totalScore = 0;
    
    // Sum all answer values
    for (final answer in answers.values) {
      // Ensure answer is between 0-3
      final clampedAnswer = answer.clamp(0, 3);
      totalScore += clampedAnswer;
    }
    
    return totalScore.clamp(0, 30);
  }

  /// Get recommendations based on score
  List<String> getRecommendations(int score) {
    if (score <= 9) {
      return [
        'Your score indicates low risk. Continue self-care practices.',
        'Stay connected with support network.',
        'Maintain healthy routines.',
      ];
    } else if (score <= 13) {
      return [
        'Your score suggests mild symptoms. Monitor your mood.',
        'Practice self-care and stress management.',
        'Consider talking to a healthcare provider.',
        'Try mindfulness and relaxation techniques.',
      ];
    } else {
      // Score > 13 - needs professional consultation
      return [
        '⚠️ IMPORTANT: Your score suggests you may benefit from professional support.',
        'Please consult with a healthcare provider or mental health professional.',
        'Contact your doctor or a mental health helpline.',
        'You can use the Tele-Health module to connect with professionals.',
        'Remember: Seeking help is a sign of strength, not weakness.',
      ];
    }
  }

  /// Get Edinburgh Scale questions
  static List<PPDQuestion> getQuestions() {
    return [
      PPDQuestion(
        id: 'q1',
        text: 'I have been able to laugh and see the funny side of things',
        options: [
          'As much as I always could (0)',
          'Not quite so much now (1)',
          'Definitely not so much now (2)',
          'Not at all (3)',
        ],
      ),
      PPDQuestion(
        id: 'q2',
        text: 'I have looked forward with enjoyment to things',
        options: [
          'As much as I ever did (0)',
          'Rather less than I used to (1)',
          'Definitely less than I used to (2)',
          'Hardly at all (3)',
        ],
      ),
      PPDQuestion(
        id: 'q3',
        text: 'I have blamed myself unnecessarily when things went wrong',
        options: [
          'Yes, most of the time (3)',
          'Yes, some of the time (2)',
          'Not very often (1)',
          'No, never (0)',
        ],
      ),
      PPDQuestion(
        id: 'q4',
        text: 'I have been anxious or worried for no good reason',
        options: [
          'No, not at all (0)',
          'Hardly ever (1)',
          'Yes, sometimes (2)',
          'Yes, very often (3)',
        ],
      ),
      PPDQuestion(
        id: 'q5',
        text: 'I have felt scared or panicky for no very good reason',
        options: [
          'Yes, quite a lot (3)',
          'Yes, sometimes (2)',
          'No, not much (1)',
          'No, not at all (0)',
        ],
      ),
      PPDQuestion(
        id: 'q6',
        text: 'Things have been getting on top of me',
        options: [
          'Yes, most of the time I haven\'t been able to cope at all (3)',
          'Yes, sometimes I haven\'t been coping as well as usual (2)',
          'No, most of the time I have coped quite well (1)',
          'No, I have been coping as well as ever (0)',
        ],
      ),
      PPDQuestion(
        id: 'q7',
        text: 'I have been so unhappy that I have had difficulty sleeping',
        options: [
          'Yes, most of the time (3)',
          'Yes, sometimes (2)',
          'Not very often (1)',
          'No, not at all (0)',
        ],
      ),
      PPDQuestion(
        id: 'q8',
        text: 'I have felt sad or miserable',
        options: [
          'Yes, most of the time (3)',
          'Yes, quite often (2)',
          'Not very often (1)',
          'No, not at all (0)',
        ],
      ),
      PPDQuestion(
        id: 'q9',
        text: 'I have been so unhappy that I have been crying',
        options: [
          'Yes, most of the time (3)',
          'Yes, quite often (2)',
          'Only occasionally (1)',
          'No, never (0)',
        ],
      ),
      PPDQuestion(
        id: 'q10',
        text: 'The thought of harming myself has occurred to me',
        options: [
          'Yes, quite often (3)',
          'Sometimes (2)',
          'Hardly ever (1)',
          'Never (0)',
        ],
      ),
    ];
  }
}

