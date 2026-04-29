import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../providers/maternity_wing_provider.dart';
import '../widgets/pregnancy_start_dialog.dart';
import 'appointment_manager_screen.dart';
import 'pregnancy_foods_screen.dart';
import 'pregnancy_tips_screen.dart';
import 'pregnancy_exercises_screen.dart';

/// Premium Maternity Wing Screen
/// Split into Pregnancy and Post-Partum modes
class MaternityWingScreen extends StatefulWidget {
  const MaternityWingScreen({super.key});

  @override
  State<MaternityWingScreen> createState() => _MaternityWingScreenState();
}

class _MaternityWingScreenState extends State<MaternityWingScreen> {
  bool isPregnancyMode = true;
  double ppdScore = 5; // slider 0-10
  Set<int> completedMilestones = {}; // Track completed milestones

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MaternityWingProvider>(context, listen: false);
      provider.loadPregnancyProfile();
      provider.loadAppointments();
      
      // Show pregnancy start dialog if profile doesn't exist
      if (provider.pregnancyProfile == null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const PregnancyStartDialog(),
            ).then((_) {
              // Reload profile after dialog closes
              provider.loadPregnancyProfile();
              if (mounted) setState(() {});
            });
          }
        });
      }
    });
  }

  int get currentWeek {
    final provider = Provider.of<MaternityWingProvider>(context, listen: true);
    final week = provider.getCurrentWeek();
    if (week == null && provider.pregnancyProfile == null) {
      return 0; // No profile set yet
    }
    return week ?? 0;
  }
  
  String get currentBabySize {
    final provider = Provider.of<MaternityWingProvider>(context, listen: true);
    return provider.getBabySizeReference() ?? 'Growing strong';
  }

  final List<Map<String, dynamic>> milestones = [
    {'week': 12, 'title': 'First Trimester Complete', 'description': 'Baby is fully formed'},
    {'week': 20, 'title': 'Halfway There!', 'description': 'Anatomy scan completed'},
    {'week': 28, 'title': 'Third Trimester Begins', 'description': 'Baby can open eyes'},
    {'week': 36, 'title': 'Almost There!', 'description': 'Baby is full-term'},
  ];

  final List<Map<String, String>> babySizes = [
    {'week': '12', 'label': 'Size of a Lime'},
    {'week': '16', 'label': 'Size of an Avocado'},
    {'week': '20', 'label': 'Size of a Mango'},
    {'week': '24', 'label': 'Size of a Corn Ear'},
    {'week': '28', 'label': 'Size of a Eggplant'},
    {'week': '32', 'label': 'Size of a Squash'},
    {'week': '36', 'label': 'Size of a Papaya'},
  ];


  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    // Force rebuild when provider updates
    Provider.of<MaternityWingProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'wellness'),
      appBar: const CustomAppBar(
        title: 'Maternity Wing',
        showLogo: true,
        showBackButton: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFB8A8D4), // Light cool purple
                    Color(0xFFA891C8), // Medium cool purple
                    Color(0xFF9A7FBD), // Slightly deeper cool purple
                  ],
                ),
              ),
              padding: EdgeInsets.all(responsive.spacingXL),
              child: Column(
                children: [
                  SizedBox(height: responsive.spacingXL),
                  Container(
                    padding: EdgeInsets.all(responsive.spacingXL),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(responsive.radiusXXL),
                    ),
                    child: Icon(
                      isPregnancyMode ? Icons.pregnant_woman_rounded : Icons.baby_changing_station_rounded,
                      size: responsive.iconSize(60),
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: responsive.spacingL),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(responsive.radiusXXL),
                  topRight: Radius.circular(responsive.radiusXXL),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(responsive.spacingXL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mode Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(responsive.radiusXL),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(alpha: 0.05),
                            blurRadius: responsive.spacingS,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildModeButton(context, responsive, label: 'Pregnancy', selected: isPregnancyMode, onTap: () => setState(() => isPregnancyMode = true)),
                          _buildModeButton(context, responsive, label: 'Post-Partum', selected: !isPregnancyMode, onTap: () => setState(() => isPregnancyMode = false)),
                        ],
                      ),
                    ),

                    SizedBox(height: responsive.spacingXL),

                    if (isPregnancyMode) ...[
                      // Pregnancy Progress Card
                      _buildProgressCard(responsive),

                      SizedBox(height: responsive.spacingXL),

                      // Week Information + Baby Size Visualizer
                      _buildWeekInfo(responsive),
                      SizedBox(height: responsive.spacingM),
                      _buildBabySizeVisualizer(responsive),

                      SizedBox(height: responsive.spacingXXL),

                      // Milestones Section
                      Text(
                        'Pregnancy Milestones',
                        style: AppTextStyles.headingMedium().copyWith(
                          fontSize: responsive.fontSize(20),
                        ),
                      ),
                      SizedBox(height: responsive.spacingM),
                      _buildMilestones(responsive),

                      SizedBox(height: responsive.spacingXXL),

                      // Daily Wisdom Section
                      Text(
                        'Daily Wisdom',
                        style: AppTextStyles.headingMedium().copyWith(
                          fontSize: responsive.fontSize(20),
                        ),
                      ),
                      SizedBox(height: responsive.spacingM),
                      _buildDailyWisdom(responsive),

                      SizedBox(height: responsive.spacingXXL),

                      // Quick Actions
                      Text(
                        'Quick Actions',
                        style: AppTextStyles.headingMedium().copyWith(
                          fontSize: responsive.fontSize(20),
                        ),
                      ),
                      SizedBox(height: responsive.spacingM),
                      _buildQuickActions(responsive),
                    ] else ...[
                      // Post-Partum Mode: PPD Screener
                      _buildPPDScreener(responsive),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(BuildContext context, Responsive responsive, {required String label, required bool selected, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusXL),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: responsive.spacingM,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.softPink : Colors.transparent,
            borderRadius: BorderRadius.circular(responsive.radiusXL),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.bodyLarge(
                color: AppColors.primaryDark,
              ).copyWith(
                fontSize: responsive.fontSize(16),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(Responsive responsive) {
    final progress = currentWeek / 40;

    return Container(
      padding: EdgeInsets.all(responsive.spacingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dustyPink,
            AppColors.softPink,
          ],
        ),
        borderRadius: BorderRadius.circular(responsive.radiusXXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.dustyPink.withValues(alpha: 0.3),
            blurRadius: responsive.spacingXL,
            offset: Offset(0, responsive.spacingM),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Pregnancy Journey',
            style: AppTextStyles.headingSmall(
              color: AppColors.white,
            ).copyWith(
              fontSize: responsive.fontSize(20),
            ),
          ),
          SizedBox(height: responsive.spacingXL),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week $currentWeek',
                      style: AppTextStyles.displayMedium(
                        color: AppColors.white,
                      ).copyWith(
                        fontSize: responsive.fontSize(32),
                      ),
                    ),
                    Text(
                      'of 40 weeks',
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.white.withValues(alpha: 0.9),
                      ).copyWith(
                        fontSize: responsive.fontSize(14),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: responsive.size(80),
                height: responsive.size(80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: AppColors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style: AppTextStyles.bodyLarge(
                          color: AppColors.white,
                          weight: FontWeight.bold,
                        ).copyWith(
                          fontSize: responsive.fontSize(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacingL),
          ClipRRect(
            borderRadius: BorderRadius.circular(responsive.radiusM),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: responsive.size(8),
              backgroundColor: AppColors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekInfo(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.spacingL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(responsive.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: responsive.spacingL,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(responsive.spacingM),
                decoration: BoxDecoration(
                  color: AppColors.palePink.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(responsive.radiusM),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.dustyPink,
                  size: responsive.iconSize(24),
                ),
              ),
              SizedBox(width: responsive.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week $currentWeek Update',
                      style: AppTextStyles.headingSmall().copyWith(
                        fontSize: responsive.fontSize(18),
                      ),
                    ),
                    Text(
                      _getTrimester(currentWeek),
                      style: AppTextStyles.bodySmall().copyWith(
                        fontSize: responsive.fontSize(13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacingM),
          Text(
            _getWeekDescription(currentWeek),
            style: AppTextStyles.bodyMedium().copyWith(
              fontSize: responsive.fontSize(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBabySizeVisualizer(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(top: responsive.spacingM),
      padding: EdgeInsets.all(responsive.spacingL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(responsive.radiusL),
        border: Border.all(
          color: AppColors.softPink.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.05),
            blurRadius: responsive.spacingM,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: responsive.size(60),
            height: responsive.size(60),
            decoration: BoxDecoration(
              color: AppColors.palePink.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.eco_rounded,
              color: AppColors.secondaryPurple,
              size: responsive.iconSize(30),
            ),
          ),
          SizedBox(width: responsive.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Baby Size Visualizer',
                  style: AppTextStyles.bodyLarge(
                    color: AppColors.primaryDark,
                  ).copyWith(
                    fontSize: responsive.fontSize(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: responsive.spacingXS),
                Text(
                  'Week $currentWeek: $currentBabySize',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.primaryDark.withValues(alpha: 0.7),
                  ).copyWith(
                    fontSize: responsive.fontSize(13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestones(Responsive responsive) {
    return Column(
      children: milestones.map((milestone) {
        final week = milestone['week'] as int;
        final isCompleted = completedMilestones.contains(week) || week <= currentWeek;
        return Container(
          margin: EdgeInsets.only(bottom: responsive.spacingM),
          padding: EdgeInsets.all(responsive.spacingL),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(responsive.radiusL),
            border: Border.all(
              color: isCompleted
                  ? AppColors.dustyPink
                  : AppColors.lightGrey,
              width: isCompleted ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.05),
                blurRadius: responsive.spacingM,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              if (week <= currentWeek) {
                setState(() {
                  if (completedMilestones.contains(week)) {
                    completedMilestones.remove(week);
                  } else {
                    completedMilestones.add(week);
                  }
                });
              }
            },
            borderRadius: BorderRadius.circular(responsive.radiusL),
            child: Row(
              children: [
                Container(
                  width: responsive.size(48),
                  height: responsive.size(48),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.dustyPink
                        : AppColors.lightGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_rounded : Icons.circle_outlined,
                    color: AppColors.white,
                    size: responsive.iconSize(24),
                  ),
                ),
              SizedBox(width: responsive.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      milestone['title'],
                      style: AppTextStyles.bodyLarge(
                        weight: FontWeight.w600,
                      ).copyWith(
                        fontSize: responsive.fontSize(15),
                      ),
                    ),
                    Text(
                      'Week ${milestone['week']} • ${milestone['description']}',
                      style: AppTextStyles.bodySmall().copyWith(
                        fontSize: responsive.fontSize(13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          )
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions(Responsive responsive) {
    final List<Map<String, dynamic>> cards = [
      {
        'title': 'Manage Appointments',
        'icon': Icons.calendar_today_rounded,
        'color': AppColors.accentPurple,
        'body':
            'View upcoming visits, reschedule, and set reminders. Keep your care team aligned.',
        'cta': 'Open Appointments',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AppointmentManagerScreen(),
            ),
          );
        },
      },
      {
        'title': 'Pregnancy Foods',
        'icon': Icons.restaurant_rounded,
        'color': AppColors.dustyPink,
        'body':
            'Add leafy greens, lean protein, whole grains. Avoid high-mercury fish, unpasteurized cheese.',
        'cta': 'View Food Guide',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PregnancyFoodsScreen(),
            ),
          );
        },
      },
      {
        'title': 'Health Tips',
        'icon': Icons.favorite_rounded,
        'color': AppColors.softPink,
        'body':
            'Hydrate well, sleep 7-9 hours, take prenatal vitamins, and listen to your body.',
        'cta': 'See Daily Tips',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PregnancyTipsScreen(),
            ),
          );
        },
      },
      {
        'title': 'Exercises',
        'icon': Icons.fitness_center_rounded,
        'color': AppColors.secondaryPurple,
        'body':
            'Try prenatal yoga, walking, and light strength. Avoid high impact without clearance.',
        'cta': 'Start a Routine',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PregnancyExercisesScreen(),
            ),
          );
        },
      },
    ];

    return Column(
      children: cards
          .map(
            (card) => Container(
              margin: EdgeInsets.only(bottom: responsive.spacingL),
              padding: EdgeInsets.all(responsive.spacingL),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(responsive.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.08),
                    blurRadius: responsive.spacingM,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(responsive.spacingM),
                        decoration: BoxDecoration(
                          color: (card['color'] as Color).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          card['icon'] as IconData,
                          color: card['color'] as Color,
                          size: responsive.iconSize(26),
                        ),
                      ),
                      SizedBox(width: responsive.spacingM),
                      Expanded(
                        child: Text(
                          card['title'] as String,
                          style: AppTextStyles.bodyLarge(
                            color: AppColors.primaryDark,
                          ).copyWith(
                            fontSize: responsive.fontSize(16),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.spacingS),
                  Text(
                    card['body'] as String,
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.primaryDark,
                    ).copyWith(
                      fontSize: responsive.fontSize(14),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: responsive.spacingM),
                  Align(
                    alignment: Alignment.centerRight,
                      child: TextButton(
                      onPressed: card['onTap'] as VoidCallback?,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.spacingM,
                          vertical: responsive.spacingS,
                        ),
                      ),
                      child: Text(
                        card['cta'] as String,
                        style: AppTextStyles.bodyMedium(
                          color: card['color'] as Color,
                        ).copyWith(
                          fontSize: responsive.fontSize(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPPDScreener(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(responsive.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: responsive.spacingL,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling emotionally today?',
            style: AppTextStyles.headingSmall(
              color: AppColors.primaryDark,
            ).copyWith(
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: responsive.spacingS),
          Text(
            'Edinburgh Postnatal Depression Scale (quick check)',
            style: AppTextStyles.bodySmall(
              color: AppColors.primaryDark.withValues(alpha: 0.7),
            ).copyWith(
              fontSize: responsive.fontSize(13),
            ),
          ),
          SizedBox(height: responsive.spacingXL),

          // Slider
          Slider(
            value: ppdScore,
            min: 0,
            max: 10,
            divisions: 10,
            activeColor: AppColors.secondaryPurple,
            inactiveColor: AppColors.secondaryPurple.withValues(alpha: 0.2),
            label: ppdScore.toStringAsFixed(0),
            onChanged: (value) {
              setState(() {
                ppdScore = value;
              });
            },
          ),
          SizedBox(height: responsive.spacingS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Low',
                style: AppTextStyles.bodySmall(
                  color: AppColors.primaryDark.withValues(alpha: 0.7),
                ).copyWith(fontSize: responsive.fontSize(12)),
              ),
              Text(
                'High',
                style: AppTextStyles.bodySmall(
                  color: AppColors.primaryDark.withValues(alpha: 0.7),
                ).copyWith(fontSize: responsive.fontSize(12)),
              ),
            ],
          ),

          SizedBox(height: responsive.spacingXL),

          // Emoji quick select
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _emojiChip(responsive, '😊', 'Good'),
              _emojiChip(responsive, '😐', 'Okay'),
              _emojiChip(responsive, '😢', 'Low'),
            ],
          ),

          SizedBox(height: responsive.spacingXL),

          // Show Mood Regulation if score is high
          if (ppdScore >= 7) ...[
            _buildMoodRegulationCard(responsive),
            SizedBox(height: responsive.spacingXL),
          ],

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Calculate PPD score and save
                final score = ppdScore.toInt();
                // Save PPD log (would need to create PPDLog entity)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(score >= 7
                        ? 'Your feeling has been noted. Please consider speaking with a healthcare provider.'
                        : 'Thank you. Your feeling has been noted.'),
                    backgroundColor: AppColors.primaryDark,
                    duration: const Duration(seconds: 2),
                  ),
                );
                if (score >= 7) {
                  // Additional logic if needed for high PPD score
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(
                  vertical: responsive.spacingL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.radiusL),
                ),
                elevation: 2,
              ),
              child: Text(
                'Log Feeling',
                style: AppTextStyles.buttonText(
                  color: AppColors.white,
                ).copyWith(
                  fontSize: responsive.fontSize(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emojiChip(Responsive responsive, String emoji, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(responsive.spacingM),
          decoration: BoxDecoration(
            color: AppColors.palePink.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            emoji,
            style: TextStyle(fontSize: responsive.fontSize(20)),
          ),
        ),
        SizedBox(height: responsive.spacingS),
        Text(
          label,
          style: AppTextStyles.bodySmall(
            color: AppColors.primaryDark,
          ).copyWith(
            fontSize: responsive.fontSize(12),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyWisdom(Responsive responsive) {
    final week = currentWeek;
    final tips = _getDailyTipsForWeek(week);

    return Container(
      padding: responsive.paddingXL,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.palePink.withValues(alpha: 0.3),
            AppColors.softPink.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(responsive.radiusL),
        border: Border.all(
          color: AppColors.softPink.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_rounded,
                color: AppColors.dustyPink,
                size: responsive.iconSize(24),
              ),
              SizedBox(width: responsive.spacingM),
              Text(
                'Week $week Tips',
                style: AppTextStyles.headingSmall(
                  color: AppColors.primaryDark,
                ).copyWith(
                  fontSize: responsive.fontSize(18),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacingL),
          ...tips.map((tip) => Padding(
                padding: EdgeInsets.only(bottom: responsive.spacingM),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: responsive.spacingXS),
                      width: responsive.size(6),
                      height: responsive.size(6),
                      decoration: BoxDecoration(
                        color: AppColors.dustyPink,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: responsive.spacingM),
                    Expanded(
                      child: Text(
                        tip,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.primaryDark,
                        ).copyWith(
                          fontSize: responsive.fontSize(14),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  List<String> _getDailyTipsForWeek(int week) {
    if (week <= 12) {
      return [
        'Focus on folic acid - take prenatal vitamins daily',
        'Stay hydrated - aim for 8-10 glasses of water',
        'Get plenty of rest - your body is working hard',
        'Avoid raw fish, unpasteurized cheese, and deli meats',
      ];
    } else if (week <= 24) {
      return [
        'This is a great time for light exercise like walking or prenatal yoga',
        'Eat iron-rich foods like spinach, lentils, and lean meats',
        'Start thinking about your birth plan',
        'Consider prenatal classes or childbirth education',
      ];
    } else if (week <= 36) {
      return [
        'Prepare your hospital bag - have it ready by week 36',
        'Practice breathing exercises for labor',
        'Sleep on your left side for better circulation',
        'Stay active but listen to your body - rest when needed',
      ];
    } else {
      return [
        'You\'re almost there! Rest as much as possible',
        'Watch for signs of labor - contractions, water breaking',
        'Have your support person ready and contact numbers handy',
        'Trust your body - you\'ve got this!',
      ];
    }
  }

  Widget _buildMoodRegulationCard(Responsive responsive) {
    return Container(
      padding: responsive.paddingXL,
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(responsive.radiusL),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                color: AppColors.warning,
                size: responsive.iconSize(24),
              ),
              SizedBox(width: responsive.spacingM),
              Text(
                'Mood Regulation',
                style: AppTextStyles.headingSmall(
                  color: AppColors.primaryDark,
                ).copyWith(
                  fontSize: responsive.fontSize(18),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacingL),
          Text(
            'Try these breathing exercises to help regulate your mood:',
            style: AppTextStyles.bodyMedium(
              color: AppColors.primaryDark,
            ).copyWith(
              fontSize: responsive.fontSize(14),
            ),
          ),
          SizedBox(height: responsive.spacingL),
          _buildBreathingExercise(
            responsive,
            title: '4-7-8 Breathing',
            description: 'Inhale for 4 counts, hold for 7, exhale for 8. Repeat 4 times.',
          ),
          SizedBox(height: responsive.spacingM),
          _buildBreathingExercise(
            responsive,
            title: 'Box Breathing',
            description: 'Inhale 4 counts, hold 4, exhale 4, hold 4. Repeat 5 cycles.',
          ),
          SizedBox(height: responsive.spacingM),
          _buildBreathingExercise(
            responsive,
            title: 'Deep Belly Breathing',
            description: 'Place hand on belly, breathe deeply into your belly. 10 slow breaths.',
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingExercise(
    Responsive responsive, {
    required String title,
    required String description,
  }) {
    return Container(
      padding: responsive.paddingM,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(responsive.radiusM),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: responsive.paddingS,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.air_rounded,
              color: AppColors.warning,
              size: responsive.iconSize(20),
            ),
          ),
          SizedBox(width: responsive.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge(
                    color: AppColors.primaryDark,
                  ).copyWith(
                    fontSize: responsive.fontSize(15),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: responsive.spacingXS),
                Text(
                  description,
                  style: AppTextStyles.bodySmall(
                    color: AppColors.primaryDark.withValues(alpha: 0.7),
                  ).copyWith(
                    fontSize: responsive.fontSize(13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getTrimester(int week) {
    if (week <= 12) return 'First Trimester';
    if (week <= 27) return 'Second Trimester';
    return 'Third Trimester';
  }
  
  String _getWeekDescription(int week) {
    if (week <= 12) {
      return 'Your baby is in the early stages of development. All major organs are forming.';
    } else if (week <= 27) {
      return 'Your baby is growing rapidly! At $week weeks, your baby can hear sounds from outside the womb.';
    } else {
      return 'Your baby is almost ready! At $week weeks, your baby is preparing for birth.';
    }
  }
}
