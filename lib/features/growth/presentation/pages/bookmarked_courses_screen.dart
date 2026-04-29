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

class BookmarkedCoursesScreen extends StatefulWidget {
  const BookmarkedCoursesScreen({super.key});

  @override
  State<BookmarkedCoursesScreen> createState() => _BookmarkedCoursesScreenState();
}

class _BookmarkedCoursesScreenState extends State<BookmarkedCoursesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GrowthProvider>(context, listen: false);
      provider.initialize();
    });
  }

  List<Course> get _bookmarkedCourses {
    final provider = Provider.of<GrowthProvider>(context, listen: false);
    final allCourses = CoursesData.getAllCourses();
    final bookmarkedIds = provider.bookmarkedCourseIds;
    return allCourses.where((course) => bookmarkedIds.contains(course.id)).toList();
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
        title: AppLocalizations.of(context)!.bookmarkedCoursesTitle,
        showLogo: true,
        showBackButton: true,
      ),
      body: Consumer<GrowthProvider>(
        builder: (context, provider, _) {
          final bookmarkedCourses = _bookmarkedCourses;
          
          if (provider.isLoading && bookmarkedCourses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (bookmarkedCourses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: context.responsive(64),
                    color: AppColors.grey,
                  ),
                  SizedBox(height: ThemeHelper.spacingL(context)),
                  Text(
                    AppLocalizations.of(context)!.noBookmarkedCourses,
                    style: AppTextStyles.heading4(context).copyWith(
                      color: AppColors.grey,
                      fontSize: context.responsive(18),
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingS(context)),
                  Text(
                    AppLocalizations.of(context)!.bookmarkToAccessQuickly,
                    style: AppTextStyles.bodyMedium1(context).copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingXL(context)),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mediumPurple,
                      padding: EdgeInsets.symmetric(
                        horizontal: ThemeHelper.spacingXL(context),
                        vertical: ThemeHelper.spacingM(context),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.browseCourses,
                      style: AppTextStyles.buttonMedium(context),
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
            itemCount: bookmarkedCourses.length,
            itemBuilder: (context, index) {
              final course = bookmarkedCourses[index];
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
    );
  }
}
