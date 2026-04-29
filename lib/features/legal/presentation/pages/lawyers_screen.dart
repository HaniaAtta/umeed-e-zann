// lib/modules/legal/screens/lawyers_screen.dart
import '../../../../contents/textstyles.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../contents/colors.dart';
import '../../../../core/extensions/extensions.dart';

// Mock data for lawyers and legal professionals
final List<Map<String, dynamic>> lawyers = [
  {
    'name': 'Adv. Sarah Ahmed',
    'specialization': 'Family Law & Women\'s Rights',
    'experience': '15+ years',
    'location': 'Lahore',
    'contact': '+92-300-123-4567',
    'email': 'sarah.ahmed@legal.pk',
    'languages': ['Urdu', 'English', 'Punjabi'],
    'services': ['Divorce', 'Custody', 'Domestic Violence'],
    'proBono': true,
    'color': AppColors.accentPink,
    'icon': Icons.person_rounded,
    'rating': 4.9,
    'description': 'Dedicated to protecting women\'s rights with 15+ years of experience in family law. Specializes in divorce, custody, and domestic violence cases.',
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
  },
  {
    'name': 'Adv. Ayesha Malik',
    'specialization': 'Property Rights & Inheritance',
    'experience': '10+ years',
    'location': 'Islamabad',
    'contact': '+92-333-345-6789',
    'email': 'ayesha.malik@property.pk',
    'languages': ['Urdu', 'English', 'Punjabi'],
    'services': ['Property Disputes', 'Inheritance', 'Land Rights'],
    'proBono': false,
    'color': AppColors.accentPurple,
    'icon': Icons.home_work_rounded,
    'rating': 4.7,
    'description': 'Expert in property and inheritance law. Helps women secure their property rights and inheritance shares.',
  },
  {
    'name': 'Adv. Zainab Hassan',
    'specialization': 'Labor Rights & Workplace Harassment',
    'experience': '8+ years',
    'location': 'Lahore',
    'contact': '+92-300-456-7890',
    'email': 'zainab.hassan@labor.pk',
    'languages': ['Urdu', 'English', 'Punjabi'],
    'services': ['Workplace Harassment', 'Unfair Dismissal', 'Equal Pay'],
    'proBono': true,
    'color': AppColors.lightPink,
    'icon': Icons.work_rounded,
    'rating': 4.9,
    'description': 'Champion for women\'s workplace rights. Specializes in harassment cases and employment discrimination.',
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
  },
  {
    'name': 'Adv. Hina Raza',
    'specialization': 'Legal Aid & Pro Bono Services',
    'experience': '11+ years',
    'location': 'Islamabad',
    'contact': '+92-333-678-9012',
    'email': 'hina.raza@aid.pk',
    'languages': ['Urdu', 'English', 'Punjabi'],
    'services': ['Free Legal Aid', 'Consultation', 'Documentation'],
    'proBono': true,
    'color': AppColors.lighterPink,
    'icon': Icons.favorite_rounded,
    'rating': 4.8,
    'description': 'Provides free legal services to women in need. Specializes in documentation and legal consultation.',
  },
];

class LawyersScreen extends StatefulWidget {
  const LawyersScreen({super.key});

  @override
  State<LawyersScreen> createState() => _LawyersScreenState();
}

class _LawyersScreenState extends State<LawyersScreen>
    with TickerProviderStateMixin {
  String _selectedFilter = 'All';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final List<AnimationController> _sparkleControllers = [];

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

    // Create sparkle animations
    for (int i = 0; i < 5; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 2000 + (i * 300)),
        vsync: this,
      );
      _sparkleControllers.add(controller);
      controller.repeat();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    for (var controller in _sparkleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredLawyers {
    if (_selectedFilter == 'All') return lawyers;
    if (_selectedFilter == 'Pro Bono') {
      return lawyers.where((lawyer) => lawyer['proBono'] == true).toList();
    }
    return lawyers.where((lawyer) =>
        (lawyer['specialization'] as String).contains(_selectedFilter)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: context.ph(0.25),
            floating: false,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(context.responsive(8)),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(context.responsive(12)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.1),
                      blurRadius: context.responsive(10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.primaryDark,
                  size: context.responsive(20),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(
                left: context.responsive(24),
                bottom: context.responsive(16),
                right: context.responsive(24),
              ),
              title: Text(
                'Legal Professionals',
                style: AppTextStyles.bodyMedium1(context).copyWith(
                  color: AppColors.primaryDark,
                  fontSize: context.responsive(28),
                  fontWeight: FontWeight.w900,
                  
                  letterSpacing: -0.5,
                ),
              ),
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accentPurple.withValues(alpha: 0.2),
                          AppColors.accentPink.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                  // Sparkles animation
                  ...List.generate(5, (index) {
                    return Positioned(
                      left: (index * 20.0) % 100,
                      top: (index * 30.0) % 150,
                      child: RotationTransition(
                        turns: _sparkleControllers[index],
                        child: Icon(
                          Icons.star_rounded,
                          size: context.responsive(20),
                          color: AppColors.accentPurple.withValues(alpha: 0.3),
                        ),
                      ),
                    );
                  }),
                  Positioned(
                    top: context.responsive(40),
                    right: context.responsive(20),
                    child: Icon(
                      Icons.balance_rounded,
                      size: context.responsive(120),
                      color: AppColors.accentPurple.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),

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
                          Icons.gavel_rounded,
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
                              'Expert Legal Support',
                              style: AppTextStyles.bodyMedium1(context).copyWith(
                                fontSize: context.responsive(20),
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark,
                                
                              ),
                            ),
                            SizedBox(height: context.responsive(4)),
                            Text(
                              'Connect with lawyers dedicated to women\'s rights and humanitarian causes',
                              style: AppTextStyles.bodyMedium1(context).copyWith(
                                fontSize: context.responsive(13),
                                fontWeight: FontWeight.w400,
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
                  children: ['All', 'Pro Bono', 'Family Law', 'Human Rights', 'Property Rights'].map((filter) {
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
                        labelStyle: TextStyle(
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

          // Lawyers List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: context.responsive(24)),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final lawyer = _filteredLawyers[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOut,
                    builder: (BuildContext context, double value, Widget? child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: _buildLawyerCard(context, lawyer, index == _filteredLawyers.length - 1),
                        ),
                      );
                    },
                  );
                },
                childCount: _filteredLawyers.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: context.responsive(32))),
        ],
      ),
    );
  }

  Widget _buildLawyerCard(BuildContext context, Map<String, dynamic> lawyer, bool isLast) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : context.responsive(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsive(24)),
        border: Border.all(
          color: (lawyer['color'] as Color).withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (lawyer['color'] as Color).withValues(alpha: 0.15),
            blurRadius: context.responsive(20),
            offset: Offset(0, context.responsive(8)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showLawyerDetails(context, lawyer);
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
                            lawyer['color'] as Color,
                            (lawyer['color'] as Color).withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(context.responsive(18)),
                        boxShadow: [
                          BoxShadow(
                            color: (lawyer['color'] as Color).withValues(alpha: 0.3),
                            blurRadius: context.responsive(10),
                            offset: Offset(0, context.responsive(4)),
                          ),
                        ],
                      ),
                      child: Icon(
                        lawyer['icon'] as IconData,
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
                                  lawyer['name'] as String,
                                  style: AppTextStyles.bodyMedium1(context).copyWith(
                                    fontSize: context.responsive(18),
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryDark,
                                    
                                  ),
                                ),
                              ),
                              if (lawyer['proBono'] as bool)
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
                                      Text(
                                        'Pro Bono',
                                        style: AppTextStyles.bodyMedium1(context).copyWith(
                                          fontSize: context.responsive(10),
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.accentPink,
                                          
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: context.responsive(6)),
                          Text(
                            lawyer['specialization'] as String,
                            style: AppTextStyles.bodyMedium1(context).copyWith(
                              fontSize: context.responsive(14),
                              fontWeight: FontWeight.w500,
                              color: lawyer['color'] as Color,
                              
                            ),
                          ),
                          SizedBox(height: context.responsive(4)),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: context.responsive(14),
                                color: AppColors.accentPurple,
                              ),
                              SizedBox(width: context.responsive(4)),
                              Text(
                                '${lawyer['rating']}',
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  fontSize: context.responsive(13),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                  
                                ),
                              ),
                              SizedBox(width: context.responsive(8)),
                              Text(
                                '• ${lawyer['experience']}',
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  fontSize: context.responsive(12),
                                  color: AppColors.primaryDark.withValues(alpha: 0.6),
                                  
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.responsive(16)),
                Text(
                  lawyer['description'] as String,
                  style: AppTextStyles.bodyMedium1(context).copyWith(
                    fontSize: context.responsive(14),
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryDark.withValues(alpha: 0.7),
                    
                    height: 1.5,
                  ),
                ),
                SizedBox(height: context.responsive(16)),
                Wrap(
                  spacing: context.responsive(8),
                  runSpacing: context.responsive(8),
                  children: (lawyer['services'] as List<String>).map((service) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsive(10),
                        vertical: context.responsive(6),
                      ),
                      decoration: BoxDecoration(
                        color: (lawyer['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(context.responsive(8)),
                      ),
                      child: Text(
                        service,
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          fontSize: context.responsive(11),
                          fontWeight: FontWeight.w500,
                          color: lawyer['color'] as Color,
                          
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
                        lawyer['location'] as String,
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          fontSize: context.responsive(12),
                          color: AppColors.primaryDark.withValues(alpha: 0.6),
                          
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: context.responsive(20),
                      color: (lawyer['color'] as Color),
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

  void _showLawyerDetails(BuildContext context, Map<String, dynamic> lawyer) {
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
                                lawyer['color'] as Color,
                                (lawyer['color'] as Color).withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(context.responsive(18)),
                          ),
                          child: Icon(
                            lawyer['icon'] as IconData,
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
                                lawyer['name'] as String,
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  fontSize: context.responsive(24),
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark,
                                  
                                ),
                              ),
                              SizedBox(height: context.responsive(4)),
                              Text(
                                lawyer['specialization'] as String,
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  fontSize: context.responsive(14),
                                  color: lawyer['color'] as Color,
                                  
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
                      lawyer['description'] as String,
                    ),
                    SizedBox(height: context.responsive(20)),
                    _buildDetailRow(
                      context,
                      Icons.location_on_rounded,
                      'Location',
                      lawyer['location'] as String,
                    ),
                    SizedBox(height: context.responsive(20)),
                    _buildDetailRow(
                      context,
                      Icons.phone_rounded,
                      'Contact',
                      lawyer['contact'] as String,
                      isClickable: true,
                    ),
                    SizedBox(height: context.responsive(20)),
                    _buildDetailRow(
                      context,
                      Icons.email_rounded,
                      'Email',
                      lawyer['email'] as String,
                      isClickable: true,
                    ),
                    SizedBox(height: context.responsive(20)),
                    _buildDetailRow(
                      context,
                      Icons.language_rounded,
                      'Languages',
                      (lawyer['languages'] as List<String>).join(', '),
                    ),
                    SizedBox(height: context.responsive(24)),
                    Text(
                      'Services Offered',
                      style: AppTextStyles.bodyMedium1(context).copyWith(
                        fontSize: context.responsive(18),
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                        
                      ),
                    ),
                    SizedBox(height: context.responsive(12)),
                    Wrap(
                      spacing: context.responsive(12),
                      runSpacing: context.responsive(12),
                      children: (lawyer['services'] as List<String>).map((service) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.responsive(16),
                            vertical: context.responsive(10),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (lawyer['color'] as Color).withValues(alpha: 0.2),
                                (lawyer['color'] as Color).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(context.responsive(12)),
                          ),
                          child: Text(
                            service,
                            style: AppTextStyles.bodyMedium1(context).copyWith(
                              fontSize: context.responsive(14),
                              fontWeight: FontWeight.w600,
                              color: lawyer['color'] as Color,
                              
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
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    }
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool isClickable = false,
  }) {
    return InkWell(
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
    );
  }
}

