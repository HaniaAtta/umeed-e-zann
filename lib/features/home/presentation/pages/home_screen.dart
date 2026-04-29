import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/widgets/notification_badge.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../app.dart';
import '../../../../data/services/search_service.dart';
import '../../../../features/auth/presentation/viewmodels/auth_provider.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/extensions/extensions.dart' as size_ext;
import '../widgets/dashboard_card.dart';
import '../widgets/chatbot_widget.dart';
import '../widgets/chat_messages_widget.dart';
import '../../../wellness_hub/presentation/screens/mental_health_screen.dart';
import '../../../safety/presentation/viewmodels/safety_provider.dart';
import '../../../growth/presentation/viewmodels/growth_provider.dart';
import '../../../wellness_hub/presentation/providers/cycle_tracker_provider.dart';
import '../../../wellness_hub/presentation/providers/maternity_wing_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final UserService _userService = UserService();
  final NotificationService _notificationService = NotificationService();
  final SearchService _searchService = SearchService();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _userService.addListener(_onUserDataChanged);
    _notificationService.addListener(_onUserDataChanged);
    
    // Load notifications from Firestore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.loadNotifications();
    });
  }

  @override
  void dispose() {
    _userService.removeListener(_onUserDataChanged);
    _notificationService.removeListener(_onUserDataChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onUserDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleSearchNavigation(String query) async {
    if (query.trim().isEmpty) return;
    
    // Save search history
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;
    if (userId != null) {
      await _searchService.saveSearchHistory(userId, query);
    }
    
    // Check if widget is still mounted before using context
    if (!mounted) return;
    
    final lowerQuery = query.toLowerCase();
    
    // Navigate based on search query
    if (lowerQuery.contains('safety') || lowerQuery.contains('shield') || lowerQuery.contains('sos')) {
      App.of(context)?.changeTab(1);
    } else if (lowerQuery.contains('wellness') || lowerQuery.contains('health')) {
      App.of(context)?.changeTab(2);
    } else if (lowerQuery.contains('growth') || lowerQuery.contains('course') || lowerQuery.contains('learn') || lowerQuery.contains('crochet') || lowerQuery.contains('knitting')) {
      App.of(context)?.changeTab(3);
    } else if (lowerQuery.contains('market') || lowerQuery.contains('shop') || lowerQuery.contains('buy') || lowerQuery.contains('product')) {
      App.of(context)?.changeTab(5); // Marketplace is at index 5
    } else if (lowerQuery.contains('legal') || lowerQuery.contains('law') || lowerQuery.contains('right')) {
      if (mounted) {
        Navigator.of(context).pushNamed(AppRouter.legal);
      }
    } else if (lowerQuery.contains('community') || lowerQuery.contains('forum') || lowerQuery.contains('discuss')) {
      if (mounted) {
        Navigator.of(context).pushNamed(AppRouter.community);
      }
    } else {
      // Perform global search and show results
      // For now, just navigate to appropriate module based on best match
      // In future, can show a search results screen
    }
  }

  List<Map<String, dynamic>> _dashboardCardsData(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return [];
    
    return [
      {
        'title': l10n.safetyShield,
        'icon': Icons.shield,
        'color': AppColors.dangerColor,
        'onTap': () => App.of(context)?.changeTab(1),
      },
      {
        'title': l10n.wellnessHub,
        'icon': Icons.health_and_safety,
        'color': AppColors.softPink,
        'onTap': () => App.of(context)?.changeTab(2),
      },
      {
        'title': l10n.growthAcademy,
        'icon': Icons.school,
        'color': AppColors.mediumBluePurple,
        'onTap': () => App.of(context)?.changeTab(3),
      },
      {
        'title': l10n.marketplace,
        'icon': Icons.shopping_bag,
        'color': AppColors.dustyRose,
        'onTap': () => App.of(context)?.changeTab(5),
      },
      {
        'title': l10n.legalAid,
        'icon': Icons.gavel,
        'color': AppColors.mediumPurple,
        'onTap': () => Navigator.of(context).pushNamed(AppRouter.legal),
      },
      {
        'title': l10n.community,
        'icon': Icons.people,
        'color': AppColors.softPink,
        'onTap': () => Navigator.of(context).pushNamed(AppRouter.community),
      },
      {
        'title': l10n.mentalSanctuary,
        'icon': Icons.psychology,
        'color': AppColors.secondaryPurple,
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const MentalHealthScreen(),
            ),
          );
        },
      },
    ];
  }

  List<Widget> _filteredDashboardCards(BuildContext context) {
    var cards = _dashboardCardsData(context);

    if (_searchQuery.isNotEmpty) {
      cards = cards.where((card) {
        final title = (card['title'] as String).toLowerCase();
        return title.contains(_searchQuery);
      }).toList();
    }

    return cards.map((card) {
      return DashboardCard(
        title: card['title'] as String,
        icon: card['icon'] as IconData,
        color: card['color'] as Color,
        onTap: card['onTap'] as VoidCallback,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)?.home ?? 'Home',
        showBackButton: false,
        showLogo: true,
        actions: [
          // Language switcher button
          Consumer<LocaleService>(
            builder: (context, localeService, _) {
              final currentLang = LocaleService.languageNames[localeService.locale.languageCode] ?? 'EN';
              return Tooltip(
                message: 'Change Language',
                child: IconButton(
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.language,
                        color: AppColors.lightText,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPink,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            currentLang.substring(0, currentLang.length > 2 ? 2 : 1),
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LanguageSelector(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: size_ext.SizeExtensions(context).responsive(8)),
            child: NotificationBadge(
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.lightText,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.notifications);
                },
              ),
            ),
          ),
        ],
      ),
      drawer: const SideDrawer(currentModule: null),
      body: SafeArea(
        child: Column(
          children: [
            // Welcome section with greeting and search
            Container(
              padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mediumPurple,
                    AppColors.mediumBluePurple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Greeting with user name
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)?.welcomeUser(_userService.userName) ?? 'Welcome, ${_userService.userName}',
                      style: AppTextStyles.heading2(context).copyWith(
                        color: AppColors.lightText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingL(context)),
                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.searchServices ?? 'Search services, resources...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.secondaryText),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AppColors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ThemeHelper.radiusL,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ThemeHelper.spacingM(context),
                        vertical: ThemeHelper.spacingM(context),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _handleSearchNavigation(value);
                      }
                    },
                  ),
                ],
              ),
            ),
            // Dashboard Grid Cards
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.quickAccess ?? 'Quick Access',
                      style: AppTextStyles.heading3(context),
                    ),
                    SizedBox(height: ThemeHelper.spacingL(context)),
                    // Grid of module cards
                    _filteredDashboardCards(context).isEmpty && _searchQuery.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: size_ext.SizeExtensions(context).responsive(64),
                                  color: AppColors.grey,
                                ),
                                SizedBox(height: ThemeHelper.spacingM(context)),
                                Text(
                                  'No results found',
                                  style: AppTextStyles.heading4(context),
                                ),
                                SizedBox(height: ThemeHelper.spacingS(context)),
                                Text(
                                  'Try searching for: Safety, Wellness, Growth, Marketplace, Legal, or Community',
                                  style: AppTextStyles.bodySmall1(context),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final responsive = Responsive(context);
                              final crossAxisCount = responsive.getColumns(2, 3, 4);
                              // Adjust aspect ratio based on screen size
                              final aspectRatio = responsive.isMobile ? 1.15 : (responsive.isTablet ? 1.1 : 1.0);
                              
                              return GridView.count(
                                crossAxisCount: crossAxisCount,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: ThemeHelper.spacingM(context),
                                mainAxisSpacing: ThemeHelper.spacingM(context),
                                childAspectRatio: aspectRatio,
                                children: _filteredDashboardCards(context),
                              );
                            },
                          ),
                    SizedBox(height: ThemeHelper.spacingXL(context)),
                    // Today highlights
                    Text(
                      AppLocalizations.of(context)?.todaysHighlights ?? 'Today\'s Highlights',
                      style: AppTextStyles.heading3(context),
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    _buildDynamicHighlights(context),
                    SizedBox(height: ThemeHelper.spacingXL(context)),
                    // Recent Messages
                    const ChatMessagesWidget(),
                    SizedBox(height: ThemeHelper.spacingXL(context)),
                    // AI Assistant Chatbot
                    const ChatbotWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicHighlights(BuildContext context) {
    return Consumer4<CycleTrackerProvider, MaternityWingProvider, GrowthProvider, SafetyProvider>(
      builder: (context, cycleProvider, maternityProvider, growthProvider, safetyProvider, _) {
        final highlights = <Widget>[];

        // Load data if not already loaded
        WidgetsBinding.instance.addPostFrameCallback((_) {
          cycleProvider.loadCycleProfile();
          maternityProvider.loadAppointments();
          growthProvider.initialize();
          safetyProvider.initialize();
        });

        // 1. Cycle Day Highlight
        final cyclePhase = cycleProvider.getCurrentPhase();
        if (cyclePhase != null && cycleProvider.cycleProfile?.lastPeriodDate != null) {
          final lastPeriod = cycleProvider.cycleProfile!.lastPeriodDate!;
          final daysSince = DateTime.now().difference(lastPeriod).inDays;
          final cycleDay = (daysSince % (cycleProvider.cycleProfile?.averageCycleLength ?? 28)) + 1;
          
          String cycleMessage;
          if (cycleDay <= 5) {
            cycleMessage = 'Day $cycleDay of your period - Take care!';
          } else if (cycleDay >= 12 && cycleDay <= 16) {
            cycleMessage = 'Day $cycleDay - Fertile window approaching';
          } else {
            cycleMessage = 'Day $cycleDay - Your cycle is on track';
          }

          highlights.add(
            _buildHighlightCard(
              context,
              'Cycle Day $cycleDay',
              cycleMessage,
              Icons.calendar_today,
              AppColors.softPink,
              onTap: () => App.of(context)?.changeTab(2),
            ),
          );
        }

        // 2. Upcoming Appointment Highlight
        final today = DateTime.now();
        final upcomingAppointments = maternityProvider.appointments
            .where((apt) => apt.date.isAfter(today) || apt.date.day == today.day)
            .take(1)
            .toList();
        
        if (upcomingAppointments.isNotEmpty) {
          final apt = upcomingAppointments.first;
          final daysUntil = apt.date.difference(today).inDays;
          final timeStr = '${apt.date.hour.toString().padLeft(2, '0')}:${apt.date.minute.toString().padLeft(2, '0')}';
          String aptMessage;
          if (daysUntil == 0) {
            aptMessage = 'Today at $timeStr - ${apt.type}';
          } else if (daysUntil == 1) {
            aptMessage = 'Tomorrow at $timeStr - ${apt.type}';
          } else {
            aptMessage = 'In $daysUntil days - ${apt.type}';
          }

          highlights.add(
            _buildHighlightCard(
              context,
              'Upcoming Appointment',
              aptMessage,
              Icons.event,
              AppColors.mediumPurple,
              onTap: () => App.of(context)?.changeTab(2),
            ),
          );
        }

        // 3. Safety Tip (always show if no other highlights, or show if no trusted contacts)
        if (highlights.isEmpty || safetyProvider.trustedContacts.isEmpty) {
          highlights.add(
            _buildHighlightCard(
              context,
              safetyProvider.trustedContacts.isEmpty 
                  ? 'Safety Reminder'
                  : 'Safety Tip',
              safetyProvider.trustedContacts.isEmpty
                  ? 'Add trusted contacts for SOS alerts'
                  : 'Always share your location with trusted contacts',
              Icons.lightbulb_outline,
              AppColors.mediumBluePurple,
              onTap: () => App.of(context)?.changeTab(1),
            ),
          );
        }

        // 4. Course Progress Highlight
        if (growthProvider.courses.isNotEmpty) {
          // Find courses with progress
          // For now, show a general message
          if (highlights.length < 3) {
            highlights.add(
              _buildHighlightCard(
                context,
                'Continue Learning',
                'Explore new courses and skills',
                Icons.book,
                AppColors.dustyRose,
                onTap: () => App.of(context)?.changeTab(3),
              ),
            );
          }
        }

        // If no highlights, show default
        if (highlights.isEmpty) {
          highlights.add(
            _buildHighlightCard(
              context,
              'Welcome!',
              'Explore the app to get started',
              Icons.explore,
              AppColors.mediumBluePurple,
              onTap: () {},
            ),
          );
        }

        return Column(
          children: highlights.map((highlight) {
            return Column(
              children: [
                highlight,
                SizedBox(height: ThemeHelper.spacingM(context)),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildHighlightCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color, {
      VoidCallback? onTap,
      }) {
    final card = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
      ),
      child: Padding(
        padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
              ),
              child: Icon(
                icon,
                color: color,
                size: size_ext.SizeExtensions(context).responsive(24),
              ),
            ),
            SizedBox(width: ThemeHelper.spacingM(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium1(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingS(context) / 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall1(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
        child: card,
      );
    }
    return card;
  }
}

