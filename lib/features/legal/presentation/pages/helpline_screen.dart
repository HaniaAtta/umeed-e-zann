// lib/modules/legal/screens/helpline_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/navigation/route_paths.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  // Mock data for helpline directory
  static final List<Map<String, dynamic>> helplines = [
  {
    'name': 'Women Crisis Center',
    'contact': '0800-44444',
    'description': '24/7 legal and psychological support for women in crisis',
    'color': AppColors.accentPink,
    'icon': Icons.shield_rounded,
    'available': '24/7',
    'type': 'Emergency',
  },
  {
    'name': 'National Police Helpline',
    'contact': '15',
    'description': 'For immediate police assistance and emergency response',
    'color': AppColors.mediumPurple,
    'icon': Icons.local_police_rounded,
    'available': '24/7',
    'type': 'Emergency',
  },
  {
    'name': 'Legal Aid Society',
    'contact': '021-3587XXXX',
    'description': 'Free legal advice and representation for those in need',
    'color': AppColors.accentPurple,
    'icon': Icons.gavel_rounded,
    'available': 'Mon-Fri 9AM-5PM',
    'type': 'Legal Support',
  },
  {
    'name': 'Psychological Support',
    'contact': '0300-111XXXX',
    'description': 'Confidential counseling and mental health services',
    'color': AppColors.lightPink,
    'icon': Icons.favorite_rounded,
    'available': '24/7',
    'type': 'Support',
  },
  {
    'name': 'Domestic Violence Helpline',
    'contact': '1099',
    'description': 'Specialized support for domestic violence victims',
    'color': AppColors.primaryDark,
    'icon': Icons.warning_rounded,
    'available': '24/7',
    'type': 'Emergency',
  },
];

  /// Clean phone number for tel: URI (remove spaces, dashes, parentheses)
  String _cleanPhoneNumber(String number) {
    // Remove spaces, dashes, parentheses, and other non-digit characters except +
    return number.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }

  Future<void> _makeCall(BuildContext context, String number) async {
    try {
      final cleanedNumber = _cleanPhoneNumber(number);
      final uri = Uri.parse('tel:$cleanedNumber');
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch phone call: $number'),
              backgroundColor: AppColors.accentPink,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error making call: ${e.toString()}'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'legal'),
      appBar: const CustomAppBar(
        title: 'Emergency Helplines',
        showLogo: true,
        showBackButton: true,
      ),
      body: CustomScrollView(
        slivers: [
          // Top spacing
          SliverToBoxAdapter(
            child: SizedBox(height: context.responsive(16)),
          ),
          // Hero Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.responsive(24)),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: context.responsive(16)),
                    padding: EdgeInsets.all(context.responsive(24)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accentPink.withValues(alpha: 0.2),
                          AppColors.lightPink.withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(context.responsive(24)),
                      border: Border.all(
                        color: AppColors.accentPink.withValues(alpha: 0.3),
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
                              colors: [AppColors.accentPink, AppColors.lightPink],
                            ),
                            borderRadius: BorderRadius.circular(context.responsive(16)),
                          ),
                          child: Icon(
                            Icons.emergency_rounded,
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
                                'Immediate Support',
                                style: AppTextStyles.heading4(context).copyWith(
                                  fontSize: context.responsive(20),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: context.responsive(4)),
                              Text(
                                '24/7 helplines for legal, security, and psychological support',
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
                  // Combined Support Contacts Link Card
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(RoutePaths.supportContacts);
                      },
                      borderRadius: BorderRadius.circular(context.responsive(20)),
                      child: Container(
                        padding: EdgeInsets.all(context.responsive(20)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.mediumPurple, AppColors.accentPurple],
                          ),
                          borderRadius: BorderRadius.circular(context.responsive(20)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mediumPurple.withValues(alpha: 0.3),
                              blurRadius: context.responsive(15),
                              offset: Offset(0, context.responsive(5)),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.handshake_rounded,
                              color: AppColors.white,
                              size: context.responsive(28),
                            ),
                            SizedBox(width: context.responsive(16)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'NGOs & Lawyers',
                                      style: AppTextStyles.heading4(context).copyWith(
                                        fontSize: context.responsive(16),
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: context.responsive(4)),
                                  Flexible(
                                    child: Text(
                                      'Find support & legal professionals',
                                      style: AppTextStyles.bodySmall1(context).copyWith(
                                        fontSize: context.responsive(12),
                                        color: AppColors.white.withValues(alpha: 0.9),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.white,
                              size: context.responsive(24),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Helplines List
          if (HelplineScreen.helplines.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: context.responsive(24)),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= HelplineScreen.helplines.length) return const SizedBox.shrink();
                    final line = HelplineScreen.helplines[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (index * 100)),
                      curve: Curves.easeOut,
                      builder: (BuildContext builderContext, double value, Widget? child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: _buildHelplineCard(builderContext, line, index == HelplineScreen.helplines.length - 1),
                          ),
                        );
                      },
                    );
                  },
                  childCount: HelplineScreen.helplines.length,
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(context.responsive(24)),
                child: Center(
                  child: Text(
                    'No helplines available',
                    style: AppTextStyles.bodyMedium1(context),
                  ),
                ),
              ),
            ),

          SliverToBoxAdapter(child: SizedBox(height: context.responsive(32))),
        ],
      ),
    );
  }

  Widget _buildHelplineCard(BuildContext context, Map<String, dynamic> line, bool isLast) {
    final isEmergency = line['type'] == 'Emergency';

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : context.responsive(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsive(24)),
        border: Border.all(
          color: (line['color'] as Color).withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (line['color'] as Color).withValues(alpha: 0.15),
            blurRadius: context.responsive(20),
            offset: Offset(0, context.responsive(8)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _makeCall(context, line['contact'] as String),
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
                            line['color'] as Color,
                            (line['color'] as Color).withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(context.responsive(18)),
                        boxShadow: [
                          BoxShadow(
                            color: (line['color'] as Color).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: Offset(context.responsive(0), context.responsive(4)),
                          ),
                        ],
                      ),
                      child: Icon(
                        line['icon'] as IconData,
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
                                  line['name'] as String,
                                  style: AppTextStyles.heading4(context).copyWith(
                                    fontSize: context.responsive(18),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (isEmergency)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.responsive(8),
                                    vertical: context.responsive(4),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentPink.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(context.responsive(8)),
                                  ),
                                  child: Text(
                                    'EMERGENCY',
                                    style: AppTextStyles.caption1(context).copyWith(
                                      fontSize: context.responsive(10),
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accentPink,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: context.responsive(6)),
                          Text(
                            line['available'] as String,
                            style: AppTextStyles.bodySmall1(context).copyWith(
                              fontSize: context.responsive(12),
                              fontWeight: FontWeight.w500,
                              color: (line['color'] as Color),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.responsive(16)),
                Text(
                  line['description'] as String,
                  style: AppTextStyles.bodyMedium1(context).copyWith(
                    fontSize: context.responsive(14),
                    color: AppColors.primaryDark.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: context.responsive(16)),
                Container(
                  padding: EdgeInsets.all(context.responsive(16)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (line['color'] as Color).withValues(alpha: 0.1),
                        (line['color'] as Color).withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(context.responsive(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phone_rounded,
                            color: line['color'] as Color,
                            size: context.responsive(24),
                          ),
                          SizedBox(width: context.responsive(12)),
                          Text(
                            line['contact'] as String,
                            style: AppTextStyles.heading4(context).copyWith(
                              fontSize: context.responsive(20),
                              fontWeight: FontWeight.w800,
                              color: line['color'] as Color,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(context.responsive(10)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              line['color'] as Color,
                              (line['color'] as Color).withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(context.responsive(12)),
                          boxShadow: [
                            BoxShadow(
                              color: (line['color'] as Color).withValues(alpha: 0.3),
                              blurRadius: context.responsive(10),
                              offset: Offset(0, context.responsive(4)),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.call_rounded,
                          color: AppColors.white,
                          size: context.responsive(24),
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
    );
  }
}
