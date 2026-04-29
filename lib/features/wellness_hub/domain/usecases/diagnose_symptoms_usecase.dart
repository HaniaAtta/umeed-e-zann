/// Use case to diagnose symptoms using AI-like rules
/// Input: User symptoms (List of String)
/// Output: String diagnosis with recommendations
class DiagnoseSymptomsUseCase {
  /// Diagnose symptoms based on predefined medical rules
  /// 
  /// Rules:
  /// - If symptoms include 'irregular periods' + 'acne' + 'weight gain' -> Suggest 'High likelihood of PCOS'
  /// - If 'pelvic pain' + 'painful intercourse' -> Suggest 'Endometriosis check'
  /// - Otherwise, provide general guidance
  String execute(List<String> symptoms) {
    // Normalize symptoms to lowercase for comparison
    final normalizedSymptoms = symptoms.map((s) => s.toLowerCase().trim()).toList();
    
    // Check for PCOS pattern
    final hasIrregularPeriods = normalizedSymptoms.any((s) => 
      s.contains('irregular') || s.contains('irregular periods') || s.contains('irregular period'));
    final hasAcne = normalizedSymptoms.any((s) => 
      s.contains('acne') || s.contains('pimples') || s.contains('breakout'));
    final hasWeightGain = normalizedSymptoms.any((s) => 
      s.contains('weight gain') || s.contains('weight') || s.contains('gaining weight'));
    
    if (hasIrregularPeriods && hasAcne && hasWeightGain) {
      return '''High likelihood of PCOS (Polycystic Ovary Syndrome)

Based on your symptoms, you may be experiencing signs of PCOS. This condition affects hormone levels and can cause:
• Irregular menstrual cycles
• Acne and skin changes
• Weight management challenges
• Excess hair growth

Recommendation: Please consult with a gynecologist for proper diagnosis. PCOS is manageable with lifestyle changes and medical treatment.

Note: This is not a medical diagnosis. Always consult a healthcare professional.''';
    }
    
    // Check for Endometriosis pattern
    final hasPelvicPain = normalizedSymptoms.any((s) => 
      s.contains('pelvic pain') || s.contains('pelvic') || s.contains('lower abdominal pain'));
    final hasPainfulIntercourse = normalizedSymptoms.any((s) => 
      s.contains('painful intercourse') || s.contains('pain during sex') || 
      s.contains('dyspareunia') || s.contains('painful sex'));
    
    if (hasPelvicPain && hasPainfulIntercourse) {
      return '''Possible Endometriosis

Your symptoms suggest you may need an Endometriosis evaluation. This condition occurs when tissue similar to the uterine lining grows outside the uterus, causing:
• Chronic pelvic pain
• Painful intercourse
• Heavy or irregular periods
• Painful bowel movements or urination during periods

Recommendation: Schedule an appointment with a gynecologist who specializes in endometriosis. Early diagnosis and treatment can significantly improve quality of life.

Note: This is not a medical diagnosis. Always consult a healthcare professional.''';
    }
    
    // General guidance for other symptoms
    if (normalizedSymptoms.isEmpty) {
      return '''No specific symptoms provided.

Please describe your symptoms in detail for a more accurate assessment. Common symptoms to track include:
• Menstrual irregularities
• Pain levels and locations
• Mood changes
• Physical changes
• Energy levels

If you're experiencing persistent or severe symptoms, please consult with a healthcare provider.''';
    }
    
    // General response for other symptom combinations
    return '''Symptom Assessment

Thank you for sharing your symptoms. Based on what you've described:
${normalizedSymptoms.map((s) => '• ${s.capitalize()}').join('\n')}

General Recommendations:
• Keep a detailed symptom diary to track patterns
• Monitor your menstrual cycle regularly
• Maintain a healthy lifestyle with balanced nutrition and exercise
• Consider discussing these symptoms with your healthcare provider

If symptoms persist, worsen, or interfere with daily life, please consult a gynecologist or healthcare professional for a proper evaluation.

Note: This is not a medical diagnosis. Always consult a healthcare professional for medical advice.''';
  }
}

/// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}


