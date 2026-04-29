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
import '../viewmodels/growth_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GrowthProvider>(context, listen: false);
      provider.initialize();
      provider.loadCertificates();
    });
  }

  List<Course> get _completedCourses {
    final provider = Provider.of<GrowthProvider>(context, listen: false);
    final allCourses = CoursesData.getAllCourses();
    final progressMap = provider.courseProgress;
    final List<Course> completed = [];
    
    for (final course in allCourses) {
      final progress = progressMap[course.id];
      if (progress == null) continue;
      
      final videos = course.videos;
      final quizzes = course.quizzes;
      
      // Skip if no videos
      if (videos.isEmpty) continue;
      
      // Check if all videos are completed
      final allVideosCompleted = videos.every(
        (video) => progress.completedVideoIds.contains(video.id),
      );
      
      // Check quizzes - if there are quizzes, all must be passed; if no quizzes, just videos count
      final allQuizzesPassed = quizzes.isEmpty || quizzes.every(
        (quiz) => progress.quizResults[quiz.id]?.passed ?? false,
      );
      
      // Course is completed if all videos are done and (no quizzes OR all quizzes passed)
      // Also check if progress is at least 80% as a fallback
      final isFullyCompleted = allVideosCompleted && allQuizzesPassed;
      final hasHighProgress = progress.overallProgress >= 0.8;
      
      final certificateAvailable = course.certificateAvailable ?? '';
      if ((isFullyCompleted || hasHighProgress) && (certificateAvailable == 'Yes' || certificateAvailable.isEmpty)) {
        completed.add(course);
      }
    }
    return completed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'growth'),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.certificates,
        showLogo: true,
        showBackButton: true,
      ),
      body: Consumer<GrowthProvider>(
        builder: (context, provider, _) {
          final completedCourses = _completedCourses;
          final certificates = provider.certificates;
          
          if (provider.isLoading && completedCourses.isEmpty && certificates.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (completedCourses.isEmpty && certificates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: context.responsive(64),
                    color: AppColors.grey,
                  ),
                  SizedBox(height: ThemeHelper.spacingL(context)),
                  Text(
                    AppLocalizations.of(context)!.noCertificatesYet,
                    style: AppTextStyles.heading4(context).copyWith(
                      color: AppColors.grey,
                      fontSize: context.responsive(18),
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingS(context)),
                  Text(
                    AppLocalizations.of(context)!.completeCoursesToEarn,
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
          
          // Show certificates from Firebase first, then completed courses
          final allItems = <Map<String, dynamic>>[];
          
          // Add Firebase certificates
          for (final cert in certificates) {
            final course = CoursesData.getCourseById(cert.courseId);
            if (course != null) {
              allItems.add({
                'type': 'certificate',
                'certificate': cert,
                'course': course,
              });
            }
          }
          
          // Add completed courses that don't have certificates yet
          for (final course in completedCourses) {
            if (!certificates.any((c) => c.courseId == course.id)) {
              final progress = provider.getProgressForCourse(course.id);
              if (progress != null) {
                // Get completion date from quiz results or use progress updatedAt
                DateTime completionDate;
                if (progress.quizResults.isNotEmpty) {
                  try {
                    completionDate = progress.quizResults.values
                        .map((r) => r.completedAt)
                        .reduce((a, b) => a.isAfter(b) ? a : b);
                  } catch (e) {
                    completionDate = progress.updatedAt;
                  }
                } else {
                  completionDate = progress.updatedAt;
                }
                
                allItems.add({
                  'type': 'completed',
                  'course': course,
                  'completionDate': completionDate,
                });
              }
            }
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
            itemCount: allItems.length,
            itemBuilder: (context, index) {
              final item = allItems[index];
              final course = item['course'] as Course;
              final isCertificate = item['type'] == 'certificate';
              
              return Card(
                margin: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                ),
                child: Padding(
                  padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                            decoration: BoxDecoration(
                              color: AppColors.successColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                            ),
                            child: Icon(
                              Icons.verified,
                              color: AppColors.successColor,
                              size: context.responsive(32),
                            ),
                          ),
                          SizedBox(width: ThemeHelper.spacingM(context)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  style: AppTextStyles.heading4(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: context.responsive(16),
                                  ),
                                ),
                                SizedBox(height: ThemeHelper.spacingS(context) / 2),
                                Text(
                                  isCertificate 
                                      ? AppLocalizations.of(context)!.certOfCompletion
                                      : AppLocalizations.of(context)!.readyForCert,
                                  style: AppTextStyles.bodySmall1(context).copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                if (isCertificate && item['certificate'] != null)
                                  Text(
                                    AppLocalizations.of(context)!.certNumber((item['certificate'] as dynamic).certificateNumber.toString()),
                                    style: AppTextStyles.caption1(context).copyWith(
                                      color: AppColors.secondaryText,
                                      fontSize: context.responsive(10),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ThemeHelper.spacingM(context)),
                      Divider(),
                      SizedBox(height: ThemeHelper.spacingM(context)),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: context.responsive(16),
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: ThemeHelper.spacingS(context)),
                          Text(
                            AppLocalizations.of(context)!.instructorLabel(course.instructor),
                            style: AppTextStyles.bodySmall1(context),
                          ),
                        ],
                      ),
                      if (item['completionDate'] != null || isCertificate) ...[
                        SizedBox(height: ThemeHelper.spacingS(context)),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: context.responsive(16),
                              color: AppColors.secondaryText,
                            ),
                            SizedBox(width: ThemeHelper.spacingS(context)),
                            Text(
                              isCertificate
                                  ? AppLocalizations.of(context)!.issuedLabel(DateFormat.yMd().format((item['certificate'] as dynamic).issuedAt))
                                  : AppLocalizations.of(context)!.completedLabel(DateFormat.yMd().format(item['completionDate'] as DateTime)),
                              style: AppTextStyles.bodySmall1(context),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: ThemeHelper.spacingL(context)),
                      if (isCertificate)
                        ElevatedButton.icon(
                          onPressed: () async {
                            final cert = item['certificate'] as dynamic;
                            final url = cert.certificateUrl;
                            if (url != null && url.isNotEmpty) {
                              final uri = Uri.parse(url);
                              final messenger = ScaffoldMessenger.of(context);
                              final errorMsg = AppLocalizations.of(context)?.errorOpeningCert ?? 'Error opening certificate';
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              } else {
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(errorMsg),
                                    backgroundColor: AppColors.accentPink,
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(Icons.download, color: AppColors.lightText),
                          label: Text(
                            AppLocalizations.of(context)!.viewCertificate,
                            style: AppTextStyles.buttonMedium(context),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mediumPurple,
                            padding: EdgeInsets.symmetric(
                              horizontal: ThemeHelper.spacingL(context),
                              vertical: ThemeHelper.spacingM(context),
                            ),
                          ),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () async {
                            // Generate certificate
                            final messenger = ScaffoldMessenger.of(context);
                            final successMsg = AppLocalizations.of(context)?.certGeneratedSuccess ?? 'Certificate generated successfully';
                            final cert = await provider.generateCertificate(
                              courseId: course.id,
                              courseTitle: course.title,
                            );
                            if (!mounted) return;
                              if (cert != null) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(successMsg),
                                    backgroundColor: AppColors.successColor,
                                  ),
                                );
                              }
                          },
                          icon: Icon(Icons.verified, color: AppColors.lightText),
                          label: Text(
                            AppLocalizations.of(context)!.generateCertificate,
                            style: AppTextStyles.buttonMedium(context),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mediumPurple,
                            padding: EdgeInsets.symmetric(
                              horizontal: ThemeHelper.spacingL(context),
                              vertical: ThemeHelper.spacingM(context),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
