import 'pakistan_constitution.dart';
import 'family_law.dart';
import 'property_law.dart';
import 'labor_law.dart';

/// Main Legal Knowledge Base
/// Aggregates all knowledge bases and provides unified search
class LegalKnowledgeBase {
  /// Check if query is related to legal matters
  static bool _isLegalRelated(String query) {
    final queryLower = query.toLowerCase();
    
    // Legal-related keywords
    final legalKeywords = [
      'law', 'legal', 'right', 'rights', 'court', 'lawyer', 'judge', 'case',
      'divorce', 'marriage', 'property', 'inheritance', 'custody', 'maintenance',
      'employment', 'work', 'salary', 'harassment', 'violence', 'crime',
      'constitution', 'article', 'act', 'law', 'legal aid', 'helpline',
      'document', 'contract', 'agreement', 'dispute', 'settlement',
      'women', 'child', 'family', 'spouse', 'husband', 'wife', 'parent',
      'ownership', 'land', 'house', 'tax', 'registration', 'will',
      'termination', 'dismissal', 'safety', 'workplace', 'maternity',
      'dower', 'mahr', 'nafaqa', 'khula', 'talaq', 'nikah'
    ];
    
    // Non-legal keywords (completely unrelated)
    final nonLegalKeywords = [
      'recipe', 'cooking', 'food', 'restaurant', 'movie', 'music', 'sport',
      'game', 'weather', 'temperature', 'science', 'math', 'history',
      'geography', 'animals', 'plants', 'technology', 'computer', 'phone',
      'shopping', 'fashion', 'beauty', 'travel', 'vacation', 'hotel'
    ];
    
    // Check if it's clearly non-legal
    if (nonLegalKeywords.any((kw) => queryLower.contains(kw))) {
      // But also check if it might be legal-related (e.g., "food safety law")
      if (!queryLower.contains('law') && 
          !queryLower.contains('right') && 
          !queryLower.contains('legal')) {
        return false;
      }
    }
    
    // Check if it contains legal keywords
    return legalKeywords.any((kw) => queryLower.contains(kw));
  }

  /// Get general legal guidance for loosely related questions
  static String _getGeneralLegalGuidance(String query) {
    final queryLower = query.toLowerCase();
    
    // Provide helpful general guidance based on query
    if (queryLower.contains('help') || queryLower.contains('support')) {
      return '''I understand you need help. Here are some legal support options available in Pakistan:

**Emergency Helplines:**
- Women Crisis Center: 0800-44444 (24/7)
- Domestic Violence Helpline: 1099 (24/7)
- National Police Helpline: 15

**Legal Aid Services:**
- Legal Aid Society provides free legal advice
- Many NGOs offer free legal consultation
- Family Courts handle family law matters

**Your Rights:**
- You have the right to legal representation
- You have the right to file complaints
- You have the right to seek protection orders

Would you like specific information about any legal matter?''';
    }
    
    if (queryLower.contains('problem') || queryLower.contains('issue') || queryLower.contains('trouble')) {
      return '''I understand you're facing a problem. Here's how the legal system can help:

**If it's a Family Matter:**
- Family Courts handle divorce, custody, maintenance
- You can file for protection orders
- Legal aid is available for those in need

**If it's a Property Issue:**
- Civil Courts handle property disputes
- You can seek partition of joint property
- Registration protects your ownership rights

**If it's a Workplace Issue:**
- Labor Courts handle employment disputes
- Protection against harassment is available
- You have rights to fair treatment

**General Rights:**
- Article 25 of Constitution guarantees equality
- You have right to access justice
- Legal aid services are available

Can you tell me more specifically what kind of legal issue you're facing?''';
    }
    
    // Default helpful response
    return '''I understand your question. While I may not have specific information about this exact topic, I can help you with legal matters in Pakistan.

**I can assist with:**
- Constitutional rights and fundamental rights
- Family law (divorce, marriage, custody, maintenance, inheritance)
- Property law (ownership, registration, disputes, inheritance)
- Labor law (employment rights, workplace protection, harassment)
- General legal guidance and where to seek help

**If you need immediate help:**
- Emergency: Call 15 (Police) or 1099 (Domestic Violence)
- Legal Aid: Contact Legal Aid Society or local NGOs
- Family matters: Visit Family Court in your area

Could you rephrase your question to be more specific about the legal matter you need help with?''';
  }

  /// Search across all knowledge bases
  static String search(String query) {
    // First check if it's legal-related
    if (!_isLegalRelated(query)) {
      return '''I'm sorry, but your question doesn't seem to be related to legal aid or legal matters in Pakistan.

I'm a Legal Assistant designed to help with:
- Legal rights and laws in Pakistan
- Family law, property law, labor law
- Constitutional rights
- Legal procedures and where to seek help

If you have a legal question, please feel free to ask!''';
    }
    
    final queryLower = query.toLowerCase();
    final results = <String>[];

    // Keywords mapping to specific knowledge bases
    final constitutionKeywords = [
      'constitution', 'article', 'fundamental right', 'equality', 'article 25',
      'article 34', 'article 35', 'right to', 'constitutional'
    ];

    final familyKeywords = [
      'divorce', 'khula', 'talaq', 'marriage', 'nikah', 'custody', 'maintenance',
      'nafaqa', 'dower', 'mahr', 'inheritance', 'mirath', 'domestic violence',
      'dowry', 'guardianship', 'family', 'spouse', 'wife', 'husband', 'children'
    ];

    final propertyKeywords = [
      'property', 'land', 'house', 'ownership', 'registration', 'dispute',
      'inheritance property', 'joint property', 'tax', 'sale', 'buy'
    ];

    final laborKeywords = [
      'employment', 'job', 'work', 'workplace', 'salary', 'wage', 'termination',
      'harassment', 'maternity', 'leave', 'safety', 'labor', 'worker'
    ];

    // Determine which knowledge base to search
    bool isConstitution = constitutionKeywords.any((kw) => queryLower.contains(kw));
    bool isFamily = familyKeywords.any((kw) => queryLower.contains(kw));
    bool isProperty = propertyKeywords.any((kw) => queryLower.contains(kw));
    bool isLabor = laborKeywords.any((kw) => queryLower.contains(kw));

    // Search relevant knowledge bases
    if (isConstitution || (!isFamily && !isProperty && !isLabor)) {
      final constitutionResult = PakistanConstitutionKB.searchKnowledge(query);
      if (!constitutionResult.contains("couldn't find")) {
        results.add('**CONSTITUTIONAL LAW:**\n$constitutionResult');
      }
    }

    if (isFamily || (!isConstitution && !isProperty && !isLabor)) {
      final familyResult = FamilyLawKB.searchKnowledge(query);
      if (!familyResult.contains("couldn't find")) {
        results.add('**FAMILY LAW:**\n$familyResult');
      }
    }

    if (isProperty || (!isConstitution && !isFamily && !isLabor)) {
      final propertyResult = PropertyLawKB.searchKnowledge(query);
      if (!propertyResult.contains("couldn't find")) {
        results.add('**PROPERTY LAW:**\n$propertyResult');
      }
    }

    if (isLabor || (!isConstitution && !isFamily && !isProperty)) {
      final laborResult = LaborLawKB.searchKnowledge(query);
      if (!laborResult.contains("couldn't find")) {
        results.add('**LABOR LAW:**\n$laborResult');
      }
    }

    // If no specific results, search all and provide general guidance
    if (results.isEmpty) {
      // Try searching all knowledge bases
      final allResults = <String>[];
      allResults.add(PakistanConstitutionKB.searchKnowledge(query));
      allResults.add(FamilyLawKB.searchKnowledge(query));
      allResults.add(PropertyLawKB.searchKnowledge(query));
      allResults.add(LaborLawKB.searchKnowledge(query));
      
      // Filter out "couldn't find" messages
      final filteredResults = allResults.where((r) => !r.contains("couldn't find")).toList();
      
      if (filteredResults.isNotEmpty) {
        return filteredResults.join('\n\n---\n\n');
      }
      
      // If still no results, provide general legal guidance
      return _getGeneralLegalGuidance(query);
    }

    return results.join('\n\n---\n\n');
  }

  /// Get greeting message
  static String getGreeting() {
    return '''Hello! I'm your AI Legal Assistant. I'm here to help you understand your legal rights under Pakistani law.

I can help you with:
📜 **Constitutional Rights** - Fundamental rights, equality, women's participation
👨‍👩‍👧‍👦 **Family Law** - Divorce, marriage, custody, maintenance, inheritance
🏠 **Property Law** - Property rights, ownership, inheritance, disputes
💼 **Labor Law** - Employment rights, workplace protection, harassment

**Important**: This information is for educational purposes. For specific legal advice, please consult a qualified lawyer.

How can I assist you today?''';
  }
}
