// lib/modules/legal/screens/legal_welcome_screen.dart
import '../../../../contents/textstyles.dart';

import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/navigation/route_paths.dart';
import '../../../../core/widgets/cute_animations.dart';
import '../../../../core/widgets/cartoon_character.dart';

class LegalWelcomeScreen extends StatefulWidget {
  const LegalWelcomeScreen({super.key});

  @override
  State<LegalWelcomeScreen> createState() => _LegalWelcomeScreenState();
}

class _LegalWelcomeScreenState extends State<LegalWelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsive(24),
              vertical: context.responsive(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: context.responsive(20)),
                
                // App Logo/Brand
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'امید زن',
                    style: AppTextStyles.bodyMedium1(context).copyWith(
                      fontSize: context.responsive(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark.withValues(alpha: 0.6),
                      
                    ),
                  ),
                ),

                SizedBox(height: context.responsive(40)),

                // Main Illustration with Gradient Background
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    height: context.ph(0.35),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.lighterPink.withValues(alpha: 0.3),
                          AppColors.lightPink.withValues(alpha: 0.2),
                          AppColors.accentPink.withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(context.responsive(30)),
                    ),
                    child: Stack(
                      children: [
                        // Sparkle animations
                        SparkleAnimation(
                          count: 6,
                          size: context.responsive(18),
                          color: AppColors.accentPurple,
                        ),
                        // Animated decorative circles
                        Positioned(
                          top: context.responsive(20),
                          right: context.responsive(20),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1500),
                            builder: (BuildContext context, double value, Widget? child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  width: context.responsive(80),
                                  height: context.responsive(80),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentPurple.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: context.responsive(30),
                          left: context.responsive(30),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1800),
                            builder: (BuildContext context, double value, Widget? child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  width: context.responsive(60),
                                  height: context.responsive(60),
                                  decoration: BoxDecoration(
                                    color: AppColors.mediumPurple.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Cartoon character (bouncing)
                        Positioned(
                          bottom: context.responsive(50),
                          right: context.responsive(40),
                          child: CartoonCharacter(
                            size: context.responsive(60),
                            backgroundColor: AppColors.accentPink,
                            icon: Icons.favorite_rounded,
                          ),
                        ),
                        // Main Icon
                        Center(
                          child: Container(
                            width: context.responsive(140),
                            height: context.responsive(140),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentPurple.withValues(alpha: 0.2),
                                  blurRadius: context.responsive(20),
                                  spreadRadius: context.responsive(5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.balance_rounded,
                              size: context.responsive(70),
                              color: AppColors.accentPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: context.responsive(50)),

                // Main Headline
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Your Legal\nCompanion',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium1(context).copyWith(
                        fontSize: context.responsive(42),
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryDark,
                        height: 1.1,
                        letterSpacing: -1,
                        
                      ),
                    ),
                  ),
                ),

                SizedBox(height: context.responsive(20)),

                // Rich Description
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Empower yourself with knowledge. Access comprehensive legal resources, get instant AI guidance, and protect your rights—all in one secure place.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium1(context).copyWith(
                      fontSize: context.responsive(17),
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryDark.withValues(alpha: 0.7),
                      height: 1.6,
                      
                    ),
                  ),
                ),

                SizedBox(height: context.responsive(40)),

                // Feature Cards with staggered animations
                _buildFeatureCard(
                  context: context,
                  icon: Icons.article_rounded,
                  title: 'Legal Rights Wiki',
                  description: 'Comprehensive articles on your rights',
                  color: AppColors.accentPurple,
                  route: RoutePaths.legalCategories,
                  delay: 0,
                ),
                SizedBox(height: context.responsive(16)),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.smart_toy_rounded,
                  title: 'AI Assistant',
                  description: 'Get instant answers to legal questions',
                  color: AppColors.accentPink,
                  route: RoutePaths.aiAssistant,
                  delay: 200,
                ),
                SizedBox(height: context.responsive(16)),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.mic_rounded,
                  title: 'Urdu Voice Assistant',
                  description: 'Ask questions in your language',
                  color: AppColors.mediumPurple,
                  route: RoutePaths.voiceAssistant,
                  delay: 400,
                ),
                SizedBox(height: context.responsive(16)),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.phone_in_talk_rounded,
                  title: 'Helpline Directory',
                  description: 'Emergency contacts and support lines',
                  color: AppColors.lightPink,
                  route: RoutePaths.helpline,
                  delay: 600,
                ),
                SizedBox(height: context.responsive(16)),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.handshake_rounded,
                  title: 'Support & Contacts',
                  description: 'NGOs and lawyers for women\'s rights',
                  color: AppColors.accentPurple,
                  route: RoutePaths.supportContacts,
                  delay: 800,
                ),

                SizedBox(height: context.responsive(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required String route,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(route);
                },
                borderRadius: BorderRadius.circular(context.responsive(18)),
                child: Container(
                  padding: EdgeInsets.all(context.responsive(20)),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(context.responsive(18)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.1),
                        blurRadius: context.responsive(15),
                        offset: Offset(0, context.responsive(5)),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: context.responsive(56),
                        height: context.responsive(56),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.7)],
                          ),
                          borderRadius: BorderRadius.circular(context.responsive(14)),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: context.responsive(10),
                              offset: Offset(0, context.responsive(4)),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.white,
                          size: context.responsive(28),
                        ),
                      ),
                      SizedBox(width: context.responsive(16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  fontSize: context.responsive(16),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                  
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: context.responsive(4)),
                            Flexible(
                              child: Text(
                                description,
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  fontSize: context.responsive(13),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryDark.withValues(alpha: 0.6),
                                  
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
                        color: color,
                        size: context.responsive(24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}