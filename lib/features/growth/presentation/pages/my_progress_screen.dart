import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../../data/models/courses_data.dart';
import '../../../../data/models/course_model.dart';
import '../widgets/course_card.dart';
import '../viewmodels/growth_provider.dart';
import 'course_detail_screen.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class MyProgressScreen extends StatefulWidget {
  const MyProgressScreen({super.key});

  @override
  State<MyProgressScreen> createState() => _MyProgressScreenState();
}

class _MyProgressScreenState extends State<MyProgressScreen> {
  String _selectedFilter = 'all'; // 'all', 'in_progress', 'completed'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GrowthProvider>(context, listen: false);
      provider.initialize();
    });
  }

  List<Course> get _filteredCourses {
    final provider = Provider.of<GrowthProvider>(context, listen: false);
    final allCourses = CoursesData.getAllCourses();
    final progressMap = provider.courseProgress;
    
    if (_selectedFilter == 'all') {
      return allCourses.where((course) => progressMap.containsKey(course.id)).toList();
    } else if (_selectedFilter == 'in_progress') {
      final List<Course> inProgress = [];
      for (final course in allCourses) {
        final progress = progressMap[course.id];
        if (progress != null && progress.overallProgress > 0 && progress.overallProgress < 1.0) {
          inProgress.add(course);
        }
      }
      return inProgress;
    } else if (_selectedFilter == 'completed') {
      final List<Course> completed = [];
      for (final course in allCourses) {
        final progress = progressMap[course.id];
        if (progress != null && progress.overallProgress >= 1.0) {
          completed.add(course);
        }
      }
      return completed;
    }
    
    return [];
  }

  CourseProgress? _convertToCourseProgress(String courseId) {
    final provider = Provider.of<GrowthProvider>(context, listen: false);
    final progressEntity = provider.getProgressForCourse(courseId);
    if (progressEntity == null) return null;

    final quizResults = <String, QuizResult>{};
    progressEntity.quizResults.forEach((quizId, quizResultEntity) {
      quizResults[quizId] = QuizResult(
        quizId: quizResultEntity.quizId,
        score: quizResultEntity.score,
        totalQuestions: quizResultEntity.totalQuestions,
        correctAnswers: quizResultEntity.correctAnswers,
        completedAt: quizResultEntity.completedAt,
        passed: quizResultEntity.passed,
      );
    });

    return CourseProgress(
      courseId: progressEntity.courseId,
      completedVideoIds: progressEntity.completedVideoIds,
      quizResults: quizResults,
      overallProgress: progressEntity.overallProgress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'growth'),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.myProgress,
        showLogo: true,
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
            child: Row(
              children: [
                _buildFilterChip(context, AppLocalizations.of(context)!.all, 'all'),
                SizedBox(width: ThemeHelper.spacingS(context)),
                _buildFilterChip(context, AppLocalizations.of(context)!.inProgress, 'in_progress'),
                SizedBox(width: ThemeHelper.spacingS(context)),
                _buildFilterChip(context, AppLocalizations.of(context)!.completed, 'completed'),
              ],
            ),
          ),
          // Courses List
          Expanded(
            child: Consumer<GrowthProvider>(
              builder: (context, provider, _) {
                final filteredCourses = _filteredCourses;
                
                if (provider.isLoading && filteredCourses.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (filteredCourses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: context.responsive(64),
                          color: AppColors.grey,
                        ),
                        SizedBox(height: ThemeHelper.spacingL(context)),
                        Text(
                          _selectedFilter == 'all'
                              ? AppLocalizations.of(context)!.noCoursesStarted
                              : _selectedFilter == 'in_progress'
                                  ? AppLocalizations.of(context)!.noCoursesInProgress
                                  : AppLocalizations.of(context)!.noCompletedCourses,
                          style: AppTextStyles.heading4(context).copyWith(
                            color: AppColors.grey,
                            fontSize: context.responsive(18),
                          ),
                        ),
                        SizedBox(height: ThemeHelper.spacingS(context)),
                        Text(
                          AppLocalizations.of(context)!.startLearningExplore,
                          style: AppTextStyles.bodyMedium1(context).copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    final progress = _convertToCourseProgress(course.id);
                    return Padding(
                      padding: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
                      child: CourseCard(
                        course: course,
                        progress: progress,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CourseDetailScreen(
                                course: course,
                                progress: progress,
                                onProgressUpdate: (_) {},
                              ),
                            ),
                          );
                          // Refresh after returning
                          if (mounted) {
                            provider.loadCourseProgress(course.id);
                          }
                        },
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

  Widget _buildFilterChip(BuildContext context, String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: AppColors.mediumPurple,
      checkmarkColor: AppColors.lightText,
      labelStyle: AppTextStyles.bodySmall1(context).copyWith(
        color: isSelected ? AppColors.lightText : AppColors.primaryText,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
