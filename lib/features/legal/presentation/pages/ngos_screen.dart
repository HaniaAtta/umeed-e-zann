// lib/modules/legal/screens/ngos_screen.dart
import '../../../../contents/textstyles.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../contents/colors.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/cute_animations.dart';
import '../../../../core/widgets/cartoon_character.dart';

// Mock data for NGOs and Organizations
final List<Map<String, dynamic>> ngos = [
  {
    'name': 'Aurat Foundation',
    'description': 'Women\'s rights advocacy and legal support',
    'location': 'Islamabad, Lahore, Karachi',
    'contact': '+92-51-111-111-111',
    'email': 'info@auratfoundation.org.pk',
    'website': 'www.auratfoundation.org.pk',
    'services': ['Legal Aid', 'Counseling', 'Shelter'],
    'color': AppColors.accentPink,
    'icon': Icons.favorite_rounded,
    'type': 'NGO',
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
  },
  {
    'name': 'Women\'s Action Forum',
    'description': 'Grassroots movement for women\'s rights',
    'location': 'Multiple Cities',
    'contact': '+92-21-333-444-555',
    'email': 'contact@waf.org.pk',
    'website': 'www.waf.org.pk',
    'services': ['Advocacy', 'Legal Support', 'Awareness'],
    'color': AppColors.accentPurple,
    'icon': Icons.group_rounded,
    'type': 'Organization',
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
    'type': 'Legal Aid',
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
    'type': 'Support',
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
  },
];

class NGOsScreen extends StatefulWidget {
  const NGOsScreen({super.key});

  @override
  State<NGOsScreen> createState() => _NGOsScreenState();
}

class _NGOsScreenState extends State<NGOsScreen> with TickerProviderStateMixin {
  String _selectedFilter = 'All';
  late AnimationController _fadeController;
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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredNGOs {
    if (_selectedFilter == 'All') return ngos;
    return ngos.where((ngo) => ngo['type'] == _selectedFilter).toList();
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
                'NGOs & Organizations',
                style: AppTextStyles.bodyMedium1(context).copyWith(
                  color: AppColors.primaryDark,
                  fontSize: context.responsive(28),
                  fontWeight: FontWeight.w900,
                  
                  letterSpacing: -0.5,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.mediumPurple.withValues(alpha: 0.2),
                      AppColors.accentPink.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Sparkle animations
                    SparkleAnimation(
                      count: 6,
                      size: context.responsive(18),
                      color: AppColors.mediumPurple,
                    ),
                    // Cartoon character
                    Positioned(
                      bottom: context.responsive(20),
                      right: context.responsive(30),
                      child: CartoonCharacter(
                        size: context.responsive(80),
                        backgroundColor: AppColors.accentPink,
                        icon: Icons.handshake_rounded,
                      ),
                    ),
                    Positioned(
                      top: context.responsive(40),
                      right: context.responsive(20),
                      child: Icon(
                        Icons.handshake_rounded,
                        size: context.responsive(120),
                        color: AppColors.mediumPurple.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
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
                        AppColors.mediumPurple.withValues(alpha: 0.15),
                        AppColors.accentPink.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(context.responsive(24)),
                    border: Border.all(
                      color: AppColors.mediumPurple.withValues(alpha: 0.3),
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
                            colors: [AppColors.mediumPurple, AppColors.accentPurple],
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
                              style: AppTextStyles.bodyMedium1(context).copyWith(
                                fontSize: context.responsive(20),
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark,
                                
                              ),
                            ),
                            SizedBox(height: context.responsive(4)),
                            Text(
                              'Connect with organizations providing legal and social support',
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
                  children: ['All', 'NGO', 'Organization', 'Legal Aid', 'Support'].map((filter) {
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

          // NGOs List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: context.responsive(24)),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ngo = _filteredNGOs[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: _buildNGOCard(context, ngo, index == _filteredNGOs.length - 1),
                        ),
                      );
                    },
                  );
                },
                childCount: _filteredNGOs.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: context.responsive(32))),
        ],
      ),
    );
  }

  Widget _buildNGOCard(BuildContext context, Map<String, dynamic> ngo, bool isLast) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : context.responsive(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsive(24)),
        border: Border.all(
          color: (ngo['color'] as Color).withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (ngo['color'] as Color).withValues(alpha: 0.15),
            blurRadius: context.responsive(20),
            offset: Offset(0, context.responsive(8)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showNGODetails(context, ngo);
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
                            ngo['color'] as Color,
                            (ngo['color'] as Color).withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(context.responsive(18)),
                        boxShadow: [
                          BoxShadow(
                            color: (ngo['color'] as Color).withValues(alpha: 0.3),
                            blurRadius: context.responsive(10),
                            offset: Offset(0, context.responsive(4)),
                          ),
                        ],
                      ),
                      child: Icon(
                        ngo['icon'] as IconData,
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
                            ngo['name'] as String,
                            style: AppTextStyles.bodyMedium1(context).copyWith(
                              fontSize: context.responsive(18),
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                              
                            ),
                          ),
                          SizedBox(height: context.responsive(4)),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.responsive(8),
                              vertical: context.responsive(4),
                            ),
                            decoration: BoxDecoration(
                              color: (ngo['color'] as Color).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(context.responsive(8)),
                            ),
                            child: Text(
                              ngo['type'] as String,
                              style: AppTextStyles.bodyMedium1(context).copyWith(
                                fontSize: context.responsive(11),
                                fontWeight: FontWeight.w600,
                                color: ngo['color'] as Color,
                                
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.responsive(16)),
                Text(
                  ngo['description'] as String,
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
                  children: (ngo['services'] as List<String>).map((service) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsive(10),
                        vertical: context.responsive(6),
                      ),
                      decoration: BoxDecoration(
                        color: (ngo['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(context.responsive(8)),
                      ),
                      child: Text(
                        service,
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          fontSize: context.responsive(11),
                          fontWeight: FontWeight.w500,
                          color: ngo['color'] as Color,
                          
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
                        ngo['location'] as String,
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          fontSize: context.responsive(12),
                          color: AppColors.primaryDark.withValues(alpha: 0.6),
                          
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: context.responsive(20),
                      color: (ngo['color'] as Color),
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

  void _showNGODetails(BuildContext context, Map<String, dynamic> ngo) {
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
                                ngo['color'] as Color,
                                (ngo['color'] as Color).withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(context.responsive(18)),
                          ),
                          child: Icon(
                            ngo['icon'] as IconData,
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
                                ngo['name'] as String,
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  fontSize: context.responsive(24),
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark,
                                  
                                ),
                              ),
                              SizedBox(height: context.responsive(4)),
                              Text(
                                ngo['type'] as String,
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  fontSize: context.responsive(14),
                                  color: ngo['color'] as Color,
                                  
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
                      'Description',
                      ngo['description'] as String,
                    ),
                    SizedBox(height: context.responsive(20)),
                    _buildDetailRow(
                      context,
                      Icons.location_on_rounded,
                      'Location',
                      ngo['location'] as String,
                    ),
                    SizedBox(height: context.responsive(20)),
                    _buildDetailRow(
                      context,
                      Icons.phone_rounded,
                      'Contact',
                      ngo['contact'] as String,
                      isClickable: true,
                    ),
                    SizedBox(height: context.responsive(20)),
                    _buildDetailRow(
                      context,
                      Icons.email_rounded,
                      'Email',
                      ngo['email'] as String,
                      isClickable: true,
                    ),
                    SizedBox(height: context.responsive(20)),
                    _buildDetailRow(
                      context,
                      Icons.language_rounded,
                      'Website',
                      ngo['website'] as String,
                      isClickable: true,
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
                      children: (ngo['services'] as List<String>).map((service) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.responsive(16),
                            vertical: context.responsive(10),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (ngo['color'] as Color).withValues(alpha: 0.2),
                                (ngo['color'] as Color).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(context.responsive(12)),
                          ),
                          child: Text(
                            service,
                            style: AppTextStyles.bodyMedium1(context).copyWith(
                              fontSize: context.responsive(14),
                              fontWeight: FontWeight.w600,
                              color: ngo['color'] as Color,
                              
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

