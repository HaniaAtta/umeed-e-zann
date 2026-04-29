// lib/modules/legal/screens/legal_home.dart

import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../../../../core/navigation/route_paths.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/extensions/extensions.dart' as size_ext;

import 'package:umeed_e_zann/l10n/app_localizations.dart';

class LegalCategoriesScreen extends StatefulWidget {
  const LegalCategoriesScreen({super.key});

  @override
  State<LegalCategoriesScreen> createState() => _LegalCategoriesScreenState();
}

class _LegalCategoriesScreenState extends State<LegalCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Using extensions.dart directly
    final List<Map<String, dynamic>> legalCategories = [
      {
        'title': l10n.familyLaw,
        'icon': Icons.family_restroom_rounded,
        'color': AppColors.accentPurple,
        'gradient': [AppColors.accentPurple, AppColors.mediumPurple],
        'articles': 12,
      },
      {
        'title': l10n.propertyRights,
        'icon': Icons.home_work_rounded,
        'color': AppColors.accentPink,
        'gradient': [AppColors.accentPink, AppColors.lightPink],
        'articles': 8,
      },
      {
        'title': l10n.inheritance,
        'icon': Icons.account_balance_rounded,
        'color': AppColors.mediumPurple,
        'gradient': [AppColors.mediumPurple, AppColors.accentPurple],
        'articles': 10,
      },
      {
        'title': l10n.laborRights,
        'icon': Icons.work_rounded,
        'color': AppColors.lightPink,
        'gradient': [AppColors.lightPink, AppColors.accentPink],
        'articles': 15,
      },
      {
        'title': l10n.criminalLaw,
        'icon': Icons.gavel_rounded,
        'color': AppColors.primaryDark,
        'gradient': [AppColors.primaryDark, AppColors.accentPurple],
        'articles': 9,
      },
      {
        'title': l10n.cyberSecurity,
        'icon': Icons.security_rounded,
        'color': AppColors.lighterPink,
        'gradient': [AppColors.lighterPink, AppColors.lightPink],
        'articles': 7,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'legal'),
      appBar: CustomAppBar(
        title: l10n.legalRightsWiki,
        showLogo: true,
        showBackButton: false,
      ),
      body: CustomScrollView(
        slivers: [
          // Top spacing after app bar
          SliverToBoxAdapter(
            child: SizedBox(height: size_ext.SizeExtensions(context).responsive(16)),
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: size_ext.SizeExtensions(context).responsive(24),
                right: size_ext.SizeExtensions(context).responsive(24),
                top: size_ext.SizeExtensions(context).responsive(8),
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: size_ext.SizeExtensions(context).responsive(32)),
                padding: EdgeInsets.all(size_ext.SizeExtensions(context).responsive(28)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentPurple.withValues(alpha: 0.15),
                      AppColors.accentPink.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(size_ext.SizeExtensions(context).responsive(24)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentPurple.withValues(alpha: 0.1),
                      blurRadius: size_ext.SizeExtensions(context).responsive(20),
                      offset: Offset(0, size_ext.SizeExtensions(context).responsive(10)),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(RoutePaths.legalCategories);
                    },
                    borderRadius: BorderRadius.circular(size_ext.SizeExtensions(context).responsive(24)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.knowYourRights,
                                style: AppTextStyles.heading2(context).copyWith(
                                  fontSize: size_ext.SizeExtensions(context).responsive(24),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: size_ext.SizeExtensions(context).responsive(8)),
                              Text(
                                l10n.legalHeroDesc,
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  fontSize: size_ext.SizeExtensions(context).responsive(14),
                                  color: AppColors.primaryDark.withValues(alpha: 0.7),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: size_ext.SizeExtensions(context).responsive(16)),
                        Container(
                          width: size_ext.SizeExtensions(context).responsive(80),
                          height: size_ext.SizeExtensions(context).responsive(80),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.accentPurple, AppColors.mediumPurple],
                            ),
                            borderRadius: BorderRadius.circular(size_ext.SizeExtensions(context).responsive(20)),
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: AppColors.white,
                            size: size_ext.SizeExtensions(context).responsive(40),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Spacing before categories grid
          SliverToBoxAdapter(
            child: SizedBox(height: size_ext.SizeExtensions(context).responsive(16)),
          ),

          // Categories Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: size_ext.SizeExtensions(context).responsive(24)),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final responsive = Responsive(context);
                final crossAxisCount = responsive.getColumns(2, 3, 4);
                final aspectRatio = responsive.isMobile ? 0.85 : (responsive.isTablet ? 0.9 : 1.0);
                
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: size_ext.SizeExtensions(context).responsive(16),
                    mainAxisSpacing: size_ext.SizeExtensions(context).responsive(16),
                    childAspectRatio: aspectRatio,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = legalCategories[index];
                      return _buildCategoryCard(context, category, l10n);
                    },
                    childCount: legalCategories.length,
                  ),
                );
              },
            ),
          ),

          // Bottom spacing
          SliverToBoxAdapter(
            child: SizedBox(height: size_ext.SizeExtensions(context).responsive(32)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category, AppLocalizations l10n) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutePaths.legalDetail,
            arguments: category['title'],
          );
        },
        borderRadius: BorderRadius.circular(size_ext.SizeExtensions(context).responsive(24)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (category['gradient'] as List<Color>)[0].withValues(alpha: 0.15),
                (category['gradient'] as List<Color>)[1].withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(size_ext.SizeExtensions(context).responsive(24)),
            border: Border.all(
              color: (category['color'] as Color).withValues(alpha: 0.2),
              width: size_ext.SizeExtensions(context).responsive(1.5),
            ),
            boxShadow: [
              BoxShadow(
                color: (category['color'] as Color).withValues(alpha: 0.1),
                blurRadius: size_ext.SizeExtensions(context).responsive(15),
                offset: Offset(0, size_ext.SizeExtensions(context).responsive(5)),
              ),
            ],
          ),
          padding: EdgeInsets.all(size_ext.SizeExtensions(context).responsive(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size_ext.SizeExtensions(context).responsive(56),
                height: size_ext.SizeExtensions(context).responsive(56),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: category['gradient'] as List<Color>,
                  ),
                  borderRadius: BorderRadius.circular(size_ext.SizeExtensions(context).responsive(16)),
                  boxShadow: [
                    BoxShadow(
                      color: (category['color'] as Color).withValues(alpha: 0.3),
                      blurRadius: size_ext.SizeExtensions(context).responsive(10),
                      offset: Offset(0, size_ext.SizeExtensions(context).responsive(4)),
                    ),
                  ],
                ),
                child: Icon(
                  category['icon'] as IconData,
                  color: AppColors.white,
                  size: size_ext.SizeExtensions(context).responsive(28),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  category['title'] as String,
                  style: AppTextStyles.heading4(context).copyWith(
                    fontSize: size_ext.SizeExtensions(context).responsive(16),
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: size_ext.SizeExtensions(context).responsive(6)),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      l10n.articlesCount(category['articles']),
                      style: AppTextStyles.caption1(context).copyWith(
                        fontSize: size_ext.SizeExtensions(context).responsive(11),
                        fontWeight: FontWeight.w500,
                        color: category['color'],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: size_ext.SizeExtensions(context).responsive(16),
                    color: category['color'],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}