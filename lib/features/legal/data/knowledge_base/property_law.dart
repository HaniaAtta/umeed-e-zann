/// Property Law Knowledge Base for Pakistan
/// Covers property rights, ownership, inheritance, and related matters
class PropertyLawKB {
  static const Map<String, String> topics = {
    'property_rights_women': '''
**Property Rights for Women in Pakistan**

Women have equal property rights under the law:

1. **Constitutional Rights**:
   - Article 25 guarantees equality before law
   - No discrimination on basis of sex
   - Equal protection of law

2. **Ownership Rights**:
   - Women can own property in their own name
   - Can buy, sell, and transfer property
   - Can inherit property
   - Can bequeath property through will

3. **Marital Property**:
   - Property acquired during marriage belongs to the person who purchased it
   - No automatic joint ownership (unlike some countries)
   - Can create joint ownership through legal documents

4. **Protection**:
   - Cannot be forced to transfer property
   - Cannot be denied property rights
   - Can seek legal remedy if rights violated
''',

    'inheritance_property': '''
**Property Inheritance Rights**

Inheritance is governed by Islamic law in Pakistan:

1. **Legal Heirs**:
   - Spouse (husband/wife)
   - Children (sons and daughters)
   - Parents
   - Siblings (in absence of children/parents)

2. **Women's Shares**:
   - Daughter: Gets share (half of son's if both exist)
   - Wife: Gets 1/4 (if no children) or 1/8 (if has children)
   - Mother: Gets 1/6 (if has children) or 1/3 (if no children)
   - Sister: Varies based on other heirs

3. **Will (Wasiyat)**:
   - Can make will for 1/3 of property
   - Cannot will away legal heirs' shares
   - Remaining 2/3 distributed according to Islamic law

4. **Enforcement**:
   - File application in Civil Court
   - Court distributes property according to law
   - Can seek partition if property is joint
''',

    'property_registration': '''
**Property Registration Process**

Important steps for property registration:

1. **Verification**:
   - Check title documents
   - Verify seller's ownership
   - Check for any encumbrances (mortgages, liens)
   - Verify property is not disputed

2. **Documents Required**:
   - Sale deed
   - Previous ownership documents
   - Identity documents (CNIC)
   - Tax clearance certificate
   - No objection certificate (NOC) if needed

3. **Registration**:
   - Must be registered with Sub-Registrar
   - Registration fee based on property value
   - Must be done within 4 months of sale
   - Both parties must be present

4. **Mutation**:
   - After registration, apply for mutation
   - Transfer ownership in revenue records
   - Required for property tax purposes

5. **Protection**:
   - Registered property is legally protected
   - Unregistered sale can be challenged
   - Registration provides legal proof of ownership
''',

    'property_disputes': '''
**Resolving Property Disputes**

Common property disputes and remedies:

1. **Types of Disputes**:
   - Ownership disputes
   - Boundary disputes
   - Inheritance disputes
   - Partition disputes
   - Fraudulent transfers

2. **Legal Remedies**:
   - File suit in Civil Court
   - Can seek injunction to prevent transfer
   - Can claim damages
   - Can seek partition of joint property

3. **Evidence Required**:
   - Title documents
   - Registration records
   - Witness testimony
   - Survey reports (for boundaries)

4. **Time Limits**:
   - Generally 12 years for ownership claims
   - 3 years for fraud cases
   - File promptly to avoid time-bar

5. **Alternative Dispute Resolution**:
   - Mediation
   - Arbitration
   - Can be faster and cheaper than court
''',

    'joint_property': '''
**Joint Property Rights**

When property is owned jointly:

1. **Types of Joint Ownership**:
   - Tenancy in common (separate shares)
   - Joint tenancy (equal shares, right of survivorship)

2. **Rights of Co-owners**:
   - Each owner has right to use property
   - Cannot exclude other owners
   - Must share expenses proportionally
   - Can seek partition

3. **Partition**:
   - Any co-owner can seek partition
   - Court can order physical division
   - Or order sale and division of proceeds
   - Based on each owner's share

4. **Sale of Joint Property**:
   - All owners must consent
   - One owner cannot sell entire property
   - Can sell only their share
   - Other owners have right of first refusal
''',

    'property_tax': '''
**Property Tax Obligations**

Property tax requirements:

1. **Who Pays**:
   - Property owner is responsible
   - Must be paid annually
   - Based on property value

2. **Calculation**:
   - Based on property value/rental value
   - Varies by location and property type
   - Commercial properties pay higher rates

3. **Payment**:
   - Pay to local municipal authority
   - Can pay online or at designated banks
   - Late payment incurs penalties

4. **Exemptions**:
   - Some properties may be exempt
   - Check with local authority
   - Residential properties may have lower rates

5. **Consequences of Non-Payment**:
   - Property can be attached
   - Can face legal action
   - May affect property transfer
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
      return 'I couldn\'t find specific information about "$query" in property law. Common topics include: property rights for women, inheritance, registration, disputes, joint property, and property tax. Would you like information about any of these?';
    }

    return results.join('\n\n');
  }
}

