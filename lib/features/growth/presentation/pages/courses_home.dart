import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../../data/models/courses_data.dart';
import '../../../../data/models/course_model.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class CoursesHome extends StatefulWidget {
  const CoursesHome({super.key});

  @override
  State<CoursesHome> createState() => _CoursesHomeState();
}

class _CoursesHomeState extends State<CoursesHome> {
  String _selectedCategory = 'all';
  final Map<String, CourseProgress> _courseProgress = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> _getCategories(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {'id': 'all', 'name': l10n.allCourses, 'icon': Icons.apps_rounded},
      {'id': 'coding', 'name': l10n.coding, 'icon': Icons.code_rounded},
      {'id': 'digital_marketing', 'name': l10n.marketing, 'icon': Icons.trending_up_rounded},
      {'id': 'wordpress', 'name': l10n.wordpress, 'icon': Icons.web_rounded},
      {'id': 'crochet', 'name': l10n.crochet, 'icon': Icons.construction_rounded},
      {'id': 'knitting', 'name': l10n.knitting, 'icon': Icons.ac_unit_rounded},
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Course> get _filteredCourses {
    List<Course> courses;
    if (_selectedCategory == 'all') {
      courses = CoursesData.getAllCourses();
    } else {
      courses = CoursesData.getCoursesByCategory(_selectedCategory);
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      courses = courses.where((course) {
        return course.title.toLowerCase().contains(query) ||
            course.description.toLowerCase().contains(query) ||
            course.instructor.toLowerCase().contains(query) ||
            course.categoryDisplayName.toLowerCase().contains(query);
      }).toList();
    }

    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'growth'),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.growthAcademy,
        showLogo: true,
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: Offset(context.responsive(0), context.responsive(2)),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchCourses,
                  hintStyle: AppTextStyles.bodyMedium1(context).copyWith(
                    color: AppColors.secondaryText,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.secondaryText,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: AppColors.secondaryText),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ThemeHelper.spacingM(context),
                    vertical: ThemeHelper.spacingM(context),
                  ),
                ),
                style: AppTextStyles.bodyMedium1(context),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
          // Category Filter Chips
          SizedBox(
            height: context.responsive(50),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: ThemeHelper.spacingM(context),
              ),
              itemCount: _getCategories(context).length,
              itemBuilder: (context, index) {
                final category = _getCategories(context)[index];
                final isSelected = _selectedCategory == category['id'];
                return Padding(
                  padding: EdgeInsets.only(
                    right: ThemeHelper.spacingS(context),
                  ),
                  child: FilterChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category['icon'] as IconData,
                          size: context.responsive(18),
                          color: isSelected
                              ? AppColors.lightText
                              : AppColors.secondaryText,
                        ),
                        SizedBox(width: ThemeHelper.spacingS(context) / 2),
                        Text(category['name'] as String),
                      ],
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category['id'] as String;
                      });
                    },
                    selectedColor: AppColors.mediumPurple,
                    labelStyle: AppTextStyles.bodySmall1(context).copyWith(
                      color: isSelected
                          ? AppColors.lightText
                          : AppColors.secondaryText,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ThemeHelper.spacingM(context),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: ThemeHelper.spacingM(context)),
          // Courses List
          Expanded(
            child: _filteredCourses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: context.responsive(80),
                          color: AppColors.secondaryText,
                        ),
                        SizedBox(height: ThemeHelper.spacingM(context)),
                        Text(
                          AppLocalizations.of(context)!.noCoursesFound,
                          style: AppTextStyles.heading4(context).copyWith(
                            color: AppColors.secondaryText,
                            fontSize: context.responsive(18),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: ThemeHelper.spacingM(context),
                    ),
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return CourseCard(
                        course: course,
                        progress: _courseProgress[course.id],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CourseDetailScreen(
                                course: course,
                                progress: _courseProgress[course.id],
                                onProgressUpdate: (progress) {
                                  setState(() {
                                    _courseProgress[course.id] = progress;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
