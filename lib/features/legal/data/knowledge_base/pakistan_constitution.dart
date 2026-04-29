/// Pakistan Constitution Knowledge Base
/// Contains all articles and amendments relevant to women's rights and general legal matters
class PakistanConstitutionKB {
  static const Map<String, String> articles = {
    'article_25': '''
**Article 25 - Equality of Citizens**
(1) All citizens are equal before law and are entitled to equal protection of law.
(2) There shall be no discrimination on the basis of sex alone.
(3) Nothing in this Article shall prevent the State from making any special provision for the protection of women and children.

This article ensures gender equality and allows special protections for women and children.
''',

    'article_25A': '''
**Article 25A - Right to Education**
The State shall provide free and compulsory education to all children of the age of five to sixteen years in such manner as may be determined by law.

This guarantees education rights for all children, including girls.
''',

    'article_34': '''
**Article 34 - Full Participation of Women in National Life**
Steps shall be taken to ensure full participation of women in all spheres of national life.

This mandates the state to ensure women's participation in all aspects of society.
''',

    'article_35': '''
**Article 35 - Protection of Family**
The State shall protect the marriage, the family, the mother and the child.

This provides constitutional protection for family structures and mothers.
''',

    'article_37': '''
**Article 37 - Promotion of Social Justice and Eradication of Social Evils**
The State shall:
(a) Promote, with special care, the educational and economic interests of backward classes or areas;
(b) Remove illiteracy and provide free and compulsory secondary education within minimum possible period;
(c) Make technical and professional education generally available and higher education equally accessible to all on the basis of merit;
(d) Ensure inexpensive and expeditious justice;
(e) Make provision for securing just and humane conditions of work, ensuring that children and women are not employed in vocations unsuited to their age or sex, and for maternity benefits for women in employment.

This ensures protection for working women and maternity benefits.
''',

    'article_38': '''
**Article 38 - Promotion of Social and Economic Well-being of the People**
The State shall:
(a) Secure the well-being of the people, irrespective of sex, caste, creed or race, by raising their standard of living, by preventing the concentration of wealth and means of production and distribution in the hands of a few to the detriment of the general interest and by ensuring equitable adjustment of rights between employers and employees, and landlords and tenants;
(b) Provide for all citizens, within the available resources of the country, facilities for work and adequate livelihood with reasonable rest and leisure;
(c) Provide for all persons employed in the service of Pakistan or otherwise, social security by means of compulsory social insurance or otherwise;
(d) Provide basic necessities of life, such as food, clothing, housing, education and medical care, for all such citizens, irrespective of sex, caste, creed or race, as are permanently or temporarily unable to earn their livelihood on account of infirmity, sickness or unemployment;
(e) Reduce disparity in the income and earnings of individuals, including persons in the various classes of the service of Pakistan.

This ensures social and economic rights for all, including women.
''',
  };

  static const Map<String, String> fundamentalRights = {
    'right_to_life': '''
**Right to Life and Liberty (Article 9)**
No person shall be deprived of life or liberty save in accordance with law.

This fundamental right protects every person's right to life and personal liberty.
''',

    'right_to_dignity': '''
**Right to Dignity (Article 14)**
(1) The dignity of man and, subject to law, the privacy of home, shall be inviolable.
(2) No person shall be subjected to torture for the purpose of extracting evidence.

This protects human dignity and privacy, crucial for women's safety.
''',

    'right_to_freedom_of_movement': '''
**Right to Freedom of Movement (Article 15)**
Every citizen shall have the right to remain in, and, subject to any reasonable restriction imposed by law in the public interest, enter and move freely throughout Pakistan and to reside and settle in any part thereof.

Women have the right to move freely and choose their residence.
''',

    'right_to_freedom_of_association': '''
**Right to Freedom of Association (Article 17)**
Every citizen shall have the right to form associations or unions, subject to any reasonable restrictions imposed by law in the interest of sovereignty or integrity of Pakistan, public order or morality.

Women can form associations and unions for their rights.
''',

    'right_to_freedom_of_speech': '''
**Right to Freedom of Speech (Article 19)**
Every citizen shall have the right to freedom of speech and expression, and there shall be freedom of the press, subject to any reasonable restrictions imposed by law in the interest of the glory of Islam or the integrity, security or defence of Pakistan or any part thereof, friendly relations with foreign States, public order, decency or morality, or in relation to contempt of court, defamation or incitement to an offence.

Women have the right to express their views and opinions.
''',
  };

  static String searchKnowledge(String query) {
    final queryLower = query.toLowerCase();
    final results = <String>[];

    // Search in articles
    articles.forEach((key, value) {
      if (key.toLowerCase().contains(queryLower) || 
          value.toLowerCase().contains(queryLower)) {
        results.add(value);
      }
    });

    // Search in fundamental rights
    fundamentalRights.forEach((key, value) {
      if (key.toLowerCase().contains(queryLower) || 
          value.toLowerCase().contains(queryLower)) {
        results.add(value);
      }
    });

    if (results.isEmpty) {
      return 'I couldn\'t find specific information about "$query" in the Constitution. However, the Constitution of Pakistan guarantees equality for all citizens regardless of gender (Article 25), ensures women\'s participation in national life (Article 34), and protects families and mothers (Article 35). Would you like information about a specific article?';
    }

    return results.join('\n\n');
  }
}

