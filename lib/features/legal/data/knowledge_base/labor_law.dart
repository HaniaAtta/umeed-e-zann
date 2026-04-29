/// Labor Law Knowledge Base for Pakistan
/// Covers employment rights, workplace protection, and related matters
class LaborLawKB {
  static const Map<String, String> topics = {
    'employment_rights_women': '''
**Employment Rights for Women**

Women have specific protections in the workplace:

1. **Equal Opportunity**:
   - Cannot be discriminated against in hiring
   - Equal pay for equal work
   - Cannot be fired for being pregnant
   - Protection against sexual harassment

2. **Maternity Benefits**:
   - 12 weeks paid maternity leave
   - 6 weeks before delivery, 6 weeks after
   - Cannot be terminated during pregnancy
   - Right to return to same position

3. **Working Hours**:
   - Maximum 8 hours per day
   - Maximum 48 hours per week
   - Overtime must be paid
   - Rest day mandatory (usually Sunday)

4. **Safety**:
   - Safe working environment
   - Protection from hazardous work
   - Proper facilities (restrooms, etc.)
''',

    'sexual_harassment': '''
**Protection Against Sexual Harassment**

Protection of Harassment of Women at Workplace Act, 2010:

1. **Definition**:
   - Unwelcome sexual advances
   - Requests for sexual favors
   - Verbal or physical conduct of sexual nature
   - Creating hostile work environment

2. **Complaint Process**:
   - File complaint with Inquiry Committee
   - Committee must be formed at workplace
   - Must have at least one woman member
   - Investigation within 30 days

3. **Remedies**:
   - Disciplinary action against harasser
   - Transfer of harasser
   - Compensation to victim
   - Protection from retaliation

4. **Protection**:
   - Cannot be fired for complaining
   - Confidentiality maintained
   - Support services available
''',

    'minimum_wage': '''
**Minimum Wage Rights**

Minimum wage protection:

1. **Provincial Minimum Wages**:
   - Set by provincial governments
   - Varies by province
   - Updated periodically
   - Check current rates with labor department

2. **Enforcement**:
   - Employers must pay at least minimum wage
   - Can file complaint with labor department
   - Can seek recovery of unpaid wages

3. **Overtime**:
   - Must be paid for work beyond 8 hours
   - Usually 1.5x regular rate
   - Cannot be forced to work overtime

4. **Payment**:
   - Must be paid on time
   - Cannot be deducted without consent
   - Must receive payslip
''',

    'termination_rights': '''
**Termination and Dismissal Rights**

Protection against unfair termination:

1. **Lawful Termination**:
   - Misconduct
   - Incompetence
   - Redundancy (with notice/compensation)
   - Must follow due process

2. **Unlawful Termination**:
   - Discrimination
   - Retaliation for complaints
   - Pregnancy-related
   - Without notice or cause

3. **Notice Period**:
   - 30 days notice or pay in lieu
   - Required for termination
   - Can be waived by agreement

4. **Severance**:
   - May be entitled to severance pay
   - Depends on length of service
   - Check employment contract

5. **Remedies**:
   - File complaint with labor court
   - Can seek reinstatement
   - Can claim compensation
''',

    'workplace_safety': '''
**Workplace Safety Rights**

Right to safe working conditions:

1. **Employer's Duty**:
   - Provide safe workplace
   - Proper safety equipment
   - Training on safety procedures
   - Regular safety inspections

2. **Worker's Rights**:
   - Refuse unsafe work
   - Report safety violations
   - Access to safety equipment
   - Training on hazards

3. **Accidents**:
   - Report workplace accidents
   - Medical treatment provided
   - Compensation for injuries
   - Investigation of accidents

4. **Protection**:
   - Cannot be fired for safety complaints
   - Right to form safety committees
   - Access to safety information
''',
  };

  static String searchKnowledge(String query) {
    final queryLower = query.toLowerCase();
    final results = <String>[];

    topics.forEach((key, value) {
      if (key.toLowerCase().contains(queryLower) || 
          value.toLowerCase().contains(queryLower)) {
        results.add(value);
      }
    });

    if (results.isEmpty) {
      return 'I couldn\'t find specific information about "$query" in labor law. Common topics include: employment rights for women, sexual harassment protection, minimum wage, termination rights, and workplace safety. Would you like information about any of these?';
    }

    return results.join('\n\n');
  }
}

