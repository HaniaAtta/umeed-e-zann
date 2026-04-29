// lib/modules/legal/screens/support_contacts_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';

// Combined data for NGOs and Lawyers
final List<Map<String, dynamic>> allSupportContacts = [
  // NGOs
  {
    'name': 'Aurat Foundation',
    'description': 'Women\'s rights advocacy and legal support for empowerment',
    'location': 'Islamabad, Lahore, Karachi',
    'contact': '+92-51-111-111-111',
    'email': 'info@auratfoundation.org.pk',
    'website': 'www.auratfoundation.org.pk',
    'services': ['Legal Aid', 'Counseling', 'Shelter'],
    'color': AppColors.accentPink,
    'icon': Icons.favorite_rounded,
    'type': 'NGO',
    'category': 'Organization',
  },
  {
    'name': 'Shirkat Gah',
    'description': 'Women\'s resource center providing legal and social support',
    'location': 'Lahore, Karachi',
    'contact': '+92-42-111-222-333',
    'email': 'info@shirkatgah.org',
    'website': 'www.shirkatgah.org',
    'services': ['Legal Aid', 'Education', 'Advocacy'],
    'color': AppColors.mediumPurple,
    'icon': Icons.school_rounded,
    'type': 'NGO',
    'category': 'Organization',
  },
  {
    'name': 'Women\'s Action Forum',
    'description': 'Grassroots movement for women\'s rights and empowerment',
    'location': 'Multiple Cities',
    'contact': '+92-21-333-444-555',
    'email': 'contact@waf.org.pk',
    'website': 'www.waf.org.pk',
    'services': ['Advocacy', 'Legal Support', 'Awareness'],
    'color': AppColors.accentPurple,
    'icon': Icons.group_rounded,
    'type': 'NGO',
    'category': 'Organization',
  },
  {
    'name': 'Legal Aid Society',
    'description': 'Free legal services for marginalized communities',
    'location': 'Karachi, Lahore',
    'contact': '+92-21-555-666-777',
    'email': 'info@las.org.pk',
    'website': 'www.las.org.pk',
    'services': ['Legal Aid', 'Court Representation', 'Consultation'],
    'color': AppColors.primaryDark,
    'icon': Icons.gavel_rounded,
    'type': 'NGO',
    'category': 'Legal Aid',
  },
  {
    'name': 'Rozan',
    'description': 'Mental health and psychological support services',
    'location': 'Islamabad',
    'contact': '+92-51-777-888-999',
    'email': 'info@rozan.org',
    'website': 'www.rozan.org',
    'services': ['Counseling', 'Support Groups', 'Training'],
    'color': AppColors.lightPink,
    'icon': Icons.healing_rounded,
    'type': 'NGO',
    'category': 'Support',
  },
  {
    'name': 'Bedari',
    'description': 'Rights-based organization working for women and children',
    'location': 'Islamabad, Rawalpindi',
    'contact': '+92-51-999-000-111',
    'email': 'info@bedari.org.pk',
    'website': 'www.bedari.org.pk',
    'services': ['Legal Aid', 'Shelter', 'Education'],
    'color': AppColors.lighterPink,
    'icon': Icons.home_rounded,
    'type': 'NGO',
    'category': 'Organization',
  },
  // Lawyers
  {
    'name': 'Adv. Sarah Ahmed',
    'specialization': 'Family Law & Women\'s Rights',
    'experience': '15+ years',
    'location': 'Lahore',
    'contact': '+92-300-123-4567',
    'email': 'sarah.ahmed@legal.pk',
    'languages': ['Urdu', 'English', 'Pakistani Punjabi'],
    'services': ['Divorce', 'Custody', 'Domestic Violence'],
    'proBono': true,
    'color': AppColors.accentPink,
    'icon': Icons.person_rounded,
    'rating': 4.9,
    'description': 'Dedicated to protecting women\'s rights with 15+ years of experience in family law. Specializes in divorce, custody, and domestic violence cases.',
    'type': 'Lawyer',
    'category': 'Legal Professional',
  },
  {
    'name': 'Adv. Fatima Khan',
    'specialization': 'Human Rights & Gender Equality',
    'experience': '12+ years',
    'location': 'Karachi',
    'contact': '+92-321-234-5678',
    'email': 'fatima.khan@rights.pk',
    'languages': ['Urdu', 'English', 'Sindhi'],
    'services': ['Human Rights', 'Discrimination', 'Legal Aid'],
    'proBono': true,
    'color': AppColors.mediumPurple,
    'icon': Icons.gavel_rounded,
    'rating': 4.8,
    'description': 'Passionate advocate for human rights and gender equality. Provides free legal aid to marginalized communities.',
    'type': 'Lawyer',
    'category': 'Legal Professional',
  },
  {
    'name': 'Adv. Ayesha Malik',
    'specialization': 'Property Rights & Inheritance',
    'experience': '10+ years',
    'location': 'Islamabad',
    'contact': '+92-333-345-6789',
    'email': 'ayesha.malik@property.pk',
    'languages': ['Urdu', 'English', 'Pakistani Punjabi'],
    'services': ['Property Disputes', 'Inheritance', 'Land Rights'],
    'proBono': false,
    'color': AppColors.accentPurple,
    'icon': Icons.home_work_rounded,
    'rating': 4.7,
    'description': 'Expert in property and inheritance law. Helps women secure their property rights and inheritance shares.',
    'type': 'Lawyer',
    'category': 'Legal Professional',
  },
  {
    'name': 'Adv. Zainab Hassan',
    'specialization': 'Labor Rights & Workplace Harassment',
    'experience': '8+ years',
    'location': 'Lahore',
    'contact': '+92-300-456-7890',
    'email': 'zainab.hassan@labor.pk',
    'languages': ['Urdu', 'English', 'Pakistani Punjabi'],
    'services': ['Workplace Harassment', 'Unfair Dismissal', 'Equal Pay'],
    'proBono': true,
    'color': AppColors.lightPink,
    'icon': Icons.work_rounded,
    'rating': 4.9,
    'description': 'Champion for women\'s workplace rights. Specializes in harassment cases and employment discrimination.',
    'type': 'Lawyer',
    'category': 'Legal Professional',
  },
  {
    'name': 'Adv. Mariam Sheikh',
    'specialization': 'Criminal Law & Domestic Violence',
    'experience': '14+ years',
    'location': 'Karachi',
    'contact': '+92-321-567-8901',
    'email': 'mariam.sheikh@criminal.pk',
    'languages': ['Urdu', 'English', 'Sindhi'],
    'services': ['Domestic Violence', 'Assault', 'Protection Orders'],
    'proBono': true,
    'color': AppColors.primaryDark,
    'icon': Icons.shield_rounded,
    'rating': 5.0,
    'description': 'Dedicated to protecting women from violence. Provides emergency legal support and protection orders.',
    'type': 'Lawyer',
    'category': 'Legal Professional',
  },
  {
    'name': 'Adv. Hina Raza',
    'specialization': 'Legal Aid & Pro Bono Services',
    'experience': '11+ years',
    'location': 'Islamabad',
    'contact': '+92-333-678-9012',
    'email': 'hina.raza@aid.pk',
    'languages': ['Urdu', 'English', 'Pakistani Punjabi'],
    'services': ['Free Legal Aid', 'Consultation', 'Documentation'],
    'proBono': true,
    'color': AppColors.lighterPink,
    'icon': Icons.favorite_rounded,
    'rating': 4.8,
    'description': 'Provides free legal services to women in need. Specializes in documentation and legal consultation.',
    'type': 'Lawyer',
    'category': 'Legal Professional',
  },
];

class SupportContactsScreen extends StatefulWidget {
  const SupportContactsScreen({super.key});

  @override
  State<SupportContactsScreen> createState() => _SupportContactsScreenState();
}

class _SupportContactsScreenState extends State<SupportContactsScreen>
    with TickerProviderStateMixin {
  String _selectedFilter = 'All';
  late AnimationController _fadeController;
  late AnimationController _characterController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    _characterController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _characterController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _characterController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredContacts {
    if (_selectedFilter == 'All') return allSupportContacts;
    return allSupportContacts.where((contact) => 
        contact['type'] == _selectedFilter || 
        contact['category'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'legal'),
      appBar: const CustomAppBar(
        title: 'Support & Contacts',
        showLogo: true,
        showBackButton: true,
      ),
      body: CustomScrollView(
        slivers: [

          // Hero Section
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.responsive(24)),
                child: Container(
                  margin: EdgeInsets.only(bottom: context.responsive(24)),
                  padding: EdgeInsets.all(context.responsive(24)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.accentPurple.withValues(alpha: 0.15),
                        AppColors.accentPink.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(context.responsive(24)),
                    border: Border.all(
                      color: AppColors.accentPurple.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: context.responsive(64),
                        height: context.responsive(64),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.accentPurple, AppColors.mediumPurple],
                          ),
                          borderRadius: BorderRadius.circular(context.responsive(16)),
                        ),
                        child: Icon(
                          Icons.handshake_rounded,
                          color: AppColors.white,
                          size: context.responsive(32),
                        ),
                      ),
                      SizedBox(width: context.responsive(20)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Find Support',
                              style: AppTextStyles.heading4(context).copyWith(
                                fontSize: context.responsive(20),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: context.responsive(4)),
                            Text(
                              'Connect with NGOs and lawyers dedicated to women\'s empowerment',
                              style: AppTextStyles.bodySmall1(context).copyWith(
                                fontSize: context.responsive(13),
                                color: AppColors.primaryDark.withValues(alpha: 0.7),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.responsive(24)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'NGO', 'Lawyer', 'Pro Bono'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: EdgeInsets.only(right: context.responsive(12)),
                      child: FilterChip(
                        label: FittedBox(
                          child: Text(
                            filter,
                            style: AppTextStyles.bodyMedium1(context).copyWith(
                              fontSize: context.responsive(13),
                              fontWeight: FontWeight.w600,
                              
                            ),
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        selectedColor: AppColors.accentPurple,
                        checkmarkColor: AppColors.white,
                        labelStyle: AppTextStyles.bodySmall1(context).copyWith(
                          color: isSelected ? AppColors.white : AppColors.primaryDark,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.responsive(16),
                          vertical: context.responsive(8),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: context.responsive(16))),

          // Contacts List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: context.responsive(24)),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final contact = _filteredContacts[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOut,
                    builder: (BuildContext context, double value, Widget? child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: _buildContactCard(context, contact, index == _filteredContacts.length - 1),
                        ),
                      );
                    },
                  );
                },
                childCount: _filteredContacts.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: context.responsive(32))),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, Map<String, dynamic> contact, bool isLast) {
    final isLawyer = contact['type'] == 'Lawyer';
    
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : context.responsive(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsive(24)),
        border: Border.all(
          color: (contact['color'] as Color).withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (contact['color'] as Color).withValues(alpha: 0.15),
            blurRadius: context.responsive(20),
            offset: Offset(0, context.responsive(8)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showContactDetails(context, contact);
          },
          borderRadius: BorderRadius.circular(context.responsive(24)),
          child: Padding(
            padding: EdgeInsets.all(context.responsive(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: context.responsive(64),
                      height: context.responsive(64),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            contact['color'] as Color,
                            (contact['color'] as Color).withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(context.responsive(18)),
                        boxShadow: [
                          BoxShadow(
                            color: (contact['color'] as Color).withValues(alpha: 0.3),
                            blurRadius: context.responsive(10),
                            offset: Offset(0, context.responsive(4)),
                          ),
                        ],
                      ),
                      child: Icon(
                        contact['icon'] as IconData,
                        color: AppColors.white,
                        size: context.responsive(32),
                      ),
                    ),
                    SizedBox(width: context.responsive(16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  contact['name'] as String,
                                  style: AppTextStyles.heading4(context).copyWith(
                                    fontSize: context.responsive(18),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (contact['proBono'] == true)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.responsive(8),
                                    vertical: context.responsive(4),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentPink.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(context.responsive(8)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.favorite_rounded,
                                        size: context.responsive(12),
                                        color: AppColors.accentPink,
                                      ),
                                      SizedBox(width: context.responsive(4)),
                                      FittedBox(
                                        child: Text(
                                          'Pro Bono',
                                          style: AppTextStyles.bodyMedium1(context).copyWith(
                                            fontSize: context.responsive(10),
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.accentPink,
                                            
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: context.responsive(6)),
                          if (isLawyer)
                            Text(
                              contact['specialization'] as String,
                              style: AppTextStyles.bodyMedium1(context).copyWith(
                                fontSize: context.responsive(14),
                                fontWeight: FontWeight.w500,
                                color: contact['color'] as Color,
                                
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          else
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.responsive(8),
                                vertical: context.responsive(4),
                              ),
                              decoration: BoxDecoration(
                                color: (contact['color'] as Color).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(context.responsive(8)),
                              ),
                              child: FittedBox(
                                child: Text(
                                  contact['type'] as String,
                                  style: AppTextStyles.bodyMedium1(context).copyWith(
                                    fontSize: context.responsive(11),
                                    fontWeight: FontWeight.w600,
                                    color: contact['color'] as Color,
                                    
                                  ),
                                ),
                              ),
                            ),
                          if (isLawyer && contact['rating'] != null)
                            Padding(
                              padding: EdgeInsets.only(top: context.responsive(4)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: context.responsive(14),
                                    color: AppColors.accentPurple,
                                  ),
                                  SizedBox(width: context.responsive(4)),
                                  Text(
                                    '${contact['rating']}',
                                    style: AppTextStyles.bodyMedium1(context).copyWith(
                                      fontSize: context.responsive(13),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryDark,
                                      
                                    ),
                                  ),
                                  SizedBox(width: context.responsive(8)),
                                  Text(
                                    '• ${contact['experience']}',
                                    style: AppTextStyles.bodyMedium1(context).copyWith(
                                      fontSize: context.responsive(12),
                                      color: AppColors.primaryDark.withValues(alpha: 0.6),
                                      
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.responsive(16)),
                Text(
                  contact['description'] as String,
                  style: AppTextStyles.bodyMedium1(context).copyWith(
                    fontSize: context.responsive(14),
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryDark.withValues(alpha: 0.7),
                    
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.responsive(16)),
                Wrap(
                  spacing: context.responsive(8),
                  runSpacing: context.responsive(8),
                  children: (contact['services'] as List<String>).take(3).map((service) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsive(10),
                        vertical: context.responsive(6),
                      ),
                      decoration: BoxDecoration(
                        color: (contact['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(context.responsive(8)),
                      ),
                      child: FittedBox(
                        child: Text(
                          service,
                          style: AppTextStyles.bodyMedium1(context).copyWith(
                            fontSize: context.responsive(11),
                            fontWeight: FontWeight.w500,
                            color: contact['color'] as Color,
                            
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: context.responsive(16)),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: context.responsive(16),
                      color: AppColors.primaryDark.withValues(alpha: 0.5),
                    ),
                    SizedBox(width: context.responsive(6)),
                    Expanded(
                      child: Text(
                        contact['location'] as String,
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          fontSize: context.responsive(12),
                          color: AppColors.primaryDark.withValues(alpha: 0.6),
                          
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: context.responsive(20),
                      color: (contact['color'] as Color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContactDetails(BuildContext context, Map<String, dynamic> contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: context.ph(0.85),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.responsive(30)),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: context.responsive(12)),
              width: context.responsive(40),
              height: context.responsive(4),
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(context.responsive(2)),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.responsive(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: context.responsive(64),
                          height: context.responsive(64),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                contact['color'] as Color,
                                (contact['color'] as Color).withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(context.responsive(18)),
                          ),
                          child: Icon(
                            contact['icon'] as IconData,
                            color: AppColors.white,
                            size: context.responsive(32),
                          ),
                        ),
                        SizedBox(width: context.responsive(16)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact['name'] as String,
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  fontSize: context.responsive(24),
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark,
                                  
                                ),
                              ),
                              SizedBox(height: context.responsive(4)),
                              if (contact['specialization'] != null)
                                Text(
                                  contact['specialization'] as String,
                                  style: AppTextStyles.bodyMedium1(context).copyWith(
                                    fontSize: context.responsive(14),
                                    color: contact['color'] as Color,
                                    
                                  ),
                                )
                              else
                                Text(
                                  contact['type'] as String,
                                  style: AppTextStyles.bodyMedium1(context).copyWith(
                                    fontSize: context.responsive(14),
                                    color: contact['color'] as Color,
                                    
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.responsive(24)),
                    _buildDetailRow(
                      context,
                      Icons.description_rounded,
                      'About',
                      contact['description'] as String,
                    ),
                    SizedBox(height: context.responsive(20)),
                    _buildDetailRow(
                      context,
                      Icons.location_on_rounded,
                      'Location',
                      contact['location'] as String,
                    ),
                    SizedBox(height: context.responsive(20)),
                    _buildDetailRow(
                      context,
                      Icons.phone_rounded,
                      'Contact',
                      contact['contact'] as String,
                      isClickable: true,
                    ),
                    SizedBox(height: context.responsive(20)),
                    _buildDetailRow(
                      context,
                      Icons.email_rounded,
                      'Email',
                      contact['email'] as String,
                      isClickable: true,
                    ),
                    if (contact['website'] != null) ...[
                      SizedBox(height: context.responsive(20)),
                      _buildDetailRow(
                        context,
                        Icons.language_rounded,
                        'Website',
                        contact['website'] as String,
                        isClickable: true,
                      ),
                    ],
                    if (contact['languages'] != null) ...[
                      SizedBox(height: context.responsive(20)),
                      _buildDetailRow(
                        context,
                        Icons.translate_rounded,
                        'Languages',
                        (contact['languages'] as List<String>).join(', '),
                      ),
                    ],
                    SizedBox(height: context.responsive(24)),
                    Text(
                      'Services Offered',
                                style: AppTextStyles.heading4(context).copyWith(
                                  fontSize: context.responsive(18),
                                  fontWeight: FontWeight.w700,
                                ),
                    ),
                    SizedBox(height: context.responsive(12)),
                    Wrap(
                      spacing: context.responsive(12),
                      runSpacing: context.responsive(12),
                      children: (contact['services'] as List<String>).map((service) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.responsive(16),
                            vertical: context.responsive(10),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (contact['color'] as Color).withValues(alpha: 0.2),
                                (contact['color'] as Color).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(context.responsive(12)),
                          ),
                          child: Text(
                            service,
                            style: AppTextStyles.bodyMedium1(context).copyWith(
                              fontSize: context.responsive(14),
                              fontWeight: FontWeight.w600,
                              color: contact['color'] as Color,
                              
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool isClickable = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isClickable ? () => _handleContactAction(context, label, value) : null,
        borderRadius: BorderRadius.circular(context.responsive(16)),
        child: Container(
          padding: EdgeInsets.all(context.responsive(16)),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(context.responsive(16)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: context.responsive(20),
                color: AppColors.accentPurple,
              ),
              SizedBox(width: context.responsive(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.bodyMedium1(context).copyWith(
                        fontSize: context.responsive(12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: context.responsive(4)),
                    Text(
                      value,
                      style: AppTextStyles.bodyMedium1(context).copyWith(
                        fontSize: context.responsive(15),
                        fontWeight: FontWeight.w500,
                        color: isClickable ? AppColors.accentPurple : AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              if (isClickable)
                Icon(
                  Icons.open_in_new_rounded,
                  size: context.responsive(18),
                  color: AppColors.accentPurple,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Clean phone number for tel: URI (remove spaces, dashes, parentheses)
  String _cleanPhoneNumber(String number) {
    // Remove spaces, dashes, parentheses, and other non-digit characters except +
    return number.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }

  Future<void> _handleContactAction(BuildContext context, String label, String value) async {
    try {
      if (label == 'Contact') {
        // Make phone call
        final cleanedNumber = _cleanPhoneNumber(value);
        final uri = Uri.parse('tel:$cleanedNumber');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not launch phone call: $value'),
                backgroundColor: AppColors.dangerColor,
              ),
            );
          }
        }
      } else if (label == 'Email') {
        // Send email
        final uri = Uri.parse('mailto:$value');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not launch email: $value'),
                backgroundColor: AppColors.dangerColor,
              ),
            );
          }
        }
      } else if (label == 'Website') {
        // Open website
        String url = value;
        if (!url.startsWith('http://') && !url.startsWith('https://')) {
          url = 'https://$url';
        }
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not open website: $value'),
                backgroundColor: AppColors.dangerColor,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    }
  }
}

