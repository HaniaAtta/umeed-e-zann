/// Family Law Knowledge Base for Pakistan
/// Covers marriage, divorce, custody, maintenance, and related matters
class FamilyLawKB {
  static const Map<String, String> topics = {
    'divorce_khula': '''
**Khula - Judicial Divorce for Women**

Khula is a form of divorce initiated by the wife in Pakistan. Key points:

1. **Filing Process**: A woman can file a Khula petition in Family Court under the Family Courts Act, 1964.

2. **Grounds**: Common grounds include:
   - Incompatibility
   - Cruelty (physical or mental)
   - Desertion
   - Failure to provide maintenance
   - Any other valid reason

3. **Procedure**:
   - File petition in Family Court
   - Court attempts reconciliation (mandatory)
   - If reconciliation fails, court grants Khula
   - Wife may need to return dower (mahr) or part of it

4. **Timeframe**: Usually 3-6 months, depending on court workload

5. **Rights After Khula**:
   - Maintenance during Iddat period (3 months)
   - Right to dower if not already received
   - Custody rights for children (usually mother gets custody of young children)
''',

    'divorce_talaq': '''
**Talaq - Divorce by Husband**

Talaq is the husband's right to divorce. Types:

1. **Talaq-e-Ahsan**: Single pronouncement, followed by abstinence during Iddat. Can be revoked.

2. **Talaq-e-Hasan**: Three pronouncements over three months. Becomes final after third pronouncement.

3. **Talaq-e-Biddat (Triple Talaq)**: Three pronouncements in one sitting. Controversial but legally recognized in Pakistan.

**Important**: After divorce, husband must:
- Provide maintenance during Iddat (3 months)
- Pay dower if not already paid
- Allow wife to stay in marital home during Iddat
''',

    'divorce_talaq_e_tafweez': '''
**Talaq-e-Tafweez - Delegated Right of Divorce**

If the husband delegates the right of divorce to the wife in the marriage contract (Nikahnama), the wife can exercise this right.

**Key Points**:
- Must be specified in Nikahnama
- Wife can divorce herself without going to court
- Same legal effect as Talaq
- No need to return dower
''',

    'maintenance_nafaqa': '''
**Maintenance (Nafaqa) Rights**

Women are entitled to maintenance in several situations:

1. **During Marriage**:
   - Husband must provide food, clothing, and shelter
   - Amount based on husband's income and wife's needs
   - Can be claimed through Family Court

2. **During Iddat** (after divorce):
   - 3 months maintenance
   - Includes food, clothing, and accommodation
   - Mandatory under Islamic law

3. **For Children**:
   - Father must maintain children until they reach majority
   - Amount determined by court based on father's income

4. **Enforcement**:
   - File application in Family Court
   - Court can order payment and attach property if needed
''',

    'dower_mahr': '''
**Dower (Mahr) Rights**

Mahr is a mandatory payment from husband to wife at marriage.

**Types**:
1. **Prompt Mahr**: Paid immediately or at specified time
2. **Deferred Mahr**: Paid at divorce or husband's death

**Key Rights**:
- Wife has absolute right to her dower
- Cannot be waived except by wife's free will
- Can claim through court if not paid
- Dower is wife's exclusive property
- Not affected by divorce (unless wife agrees to return it in Khula)
''',

    'custody_hizanat': '''
**Child Custody (Hizanat) Rights**

Under Islamic law and Pakistani courts:

1. **Mother's Right**:
   - Primary custodian for boys until age 7
   - Primary custodian for girls until puberty (around 12-14)
   - Can retain custody if remarries to a close relative (mahram)

2. **Father's Right**:
   - Gets custody after mother's period ends
   - Always responsible for financial maintenance
   - Has right to visitation

3. **Best Interest Principle**:
   - Modern courts consider child's welfare
   - Can award custody to either parent based on best interest
   - Considers child's preference if old enough

4. **Enforcement**:
   - File petition in Family Court
   - Court decides based on evidence and child's welfare
''',

    'guardianship_wilayat': '''
**Guardianship (Wilayat) Rights**

Guardianship is different from custody:

1. **Father's Right**:
   - Natural guardian of children
   - Makes decisions about education, marriage, property
   - Continues even if mother has custody

2. **Mother's Rights**:
   - Can be appointed guardian if father is unfit
   - Can make day-to-day decisions during custody period

3. **Court's Power**:
   - Can appoint guardian if both parents unfit
   - Considers child's best interest
''',

    'marriage_nikah': '''
**Marriage (Nikah) Requirements**

Legal requirements for marriage in Pakistan:

1. **Consent**:
   - Both parties must consent freely
   - Forced marriage is illegal
   - Minimum age: 18 for males, 16 for females (varies by province)

2. **Witnesses**:
   - Two adult Muslim witnesses required
   - Can be male or female

3. **Registration**:
   - Must be registered with Union Council
   - Nikahnama must be signed by both parties
   - Registration is mandatory under law

4. **Dower (Mahr)**:
   - Must be specified in Nikahnama
   - Can be prompt or deferred
   - Cannot be waived at time of marriage

5. **Polygamy**:
   - Men can have up to 4 wives
   - Must treat all wives equally
   - Must inform existing wife before second marriage
   - Can be restricted in Nikahnama
''',

    'inheritance_mirath': '''
**Inheritance Rights for Women**

Under Islamic law (applied in Pakistan):

1. **Daughter's Share**:
   - If only daughter: Gets all inheritance
   - If daughters only: Share equally
   - If sons and daughters: Daughter gets half of son's share
   - Example: 1 son + 1 daughter = Son gets 2/3, Daughter gets 1/3

2. **Wife's Share**:
   - If no children: Gets 1/4 of estate
   - If has children: Gets 1/8 of estate
   - Multiple wives share the portion equally

3. **Mother's Share**:
   - If no children: Gets 1/3
   - If has children: Gets 1/6

4. **Sister's Share**:
   - Varies based on other heirs
   - Can get 1/2 if no brothers and no children of deceased

**Important**: These are fixed shares under Islamic law and cannot be changed by will for legal heirs.
''',

    'domestic_violence': '''
**Protection Against Domestic Violence**

Laws protecting women from domestic violence:

1. **Domestic Violence (Prevention and Protection) Act, 2021**:
   - Covers physical, psychological, sexual, and economic abuse
   - Protection orders available
   - Emergency protection orders (24 hours)
   - Can order removal of abuser from home

2. **Criminal Law**:
   - Physical violence is a crime under Pakistan Penal Code
   - Can file FIR at police station
   - Can seek medical examination as evidence

3. **Remedies**:
   - File complaint with police
   - Seek protection order from court
   - Can get maintenance and custody orders
   - Can file for divorce on grounds of cruelty

4. **Support Services**:
   - Women Crisis Centers
   - Helpline 1099
   - Legal aid societies
   - NGOs providing shelter
''',

    'dowry_prohibition': '''
**Dowry Prohibition**

Dowry (Jahez) is illegal in Pakistan:

1. **Dowry Prohibition Act**:
   - Giving or taking dowry is illegal
   - Can result in imprisonment and fine
   - Dowry items can be confiscated

2. **Distinction from Dower**:
   - Dower (Mahr) is legal and mandatory
   - Dowry (Jahez) is illegal
   - Dower goes to wife, dowry goes to husband/family

3. **Protection**:
   - Can report dowry demands to police
   - Can refuse to give dowry
   - Marriage cannot be conditional on dowry
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
      return 'I couldn\'t find specific information about "$query" in family law. Common topics include: divorce (Khula, Talaq), maintenance (Nafaqa), custody, dower (Mahr), inheritance, and domestic violence protection. Would you like information about any of these?';
    }

    return results.join('\n\n');
  }
}

