import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../data/models/course_model.dart';
import '../viewmodels/growth_provider.dart';
import 'quiz_screen.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;
  final CourseProgress? progress;
  final Function(CourseProgress) onProgressUpdate;

  const CourseDetailScreen({
    super.key,
    required this.course,
    this.progress,
    required this.onProgressUpdate,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late CourseProgress _progress;

  @override
  void initState() {
    super.initState();
    _progress = widget.progress ??
        CourseProgress(
          courseId: widget.course.id,
          completedVideoIds: [],
          quizResults: {},
          overallProgress: 0.0,
        );
    // Load progress after build is complete to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProgressFromFirebase();
    });
  }

  Future<void> _loadProgressFromFirebase() async {
    final growthProvider = Provider.of<GrowthProvider>(context, listen: false);
    try {
      await growthProvider.loadCourseProgress(widget.course.id);
      final progressEntity = growthProvider.getProgressForCourse(widget.course.id);
      if (progressEntity != null && mounted) {
        // Convert entity to CourseProgress
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

        setState(() {
          _progress = CourseProgress(
            courseId: widget.course.id,
            completedVideoIds: progressEntity.completedVideoIds,
            quizResults: quizResults,
            overallProgress: progressEntity.overallProgress,
          );
        });
      }
    } catch (e) {
      debugPrint('Error loading progress from Firebase: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _updateProgress() async {
    final totalVideos = widget.course.videos.length;
    final completedVideos = _progress.completedVideoIds.length;
    final totalQuizzes = widget.course.quizzes.length;
    final completedQuizzes = _progress.quizResults.length;

    final videoProgress = totalVideos > 0 ? completedVideos / totalVideos : 0.0;
    final quizProgress = totalQuizzes > 0 ? completedQuizzes / totalQuizzes : 0.0;
    final overallProgress = (videoProgress + quizProgress) / 2;

    setState(() {
      _progress = CourseProgress(
        courseId: widget.course.id,
        completedVideoIds: _progress.completedVideoIds,
        quizResults: _progress.quizResults,
        overallProgress: overallProgress,
      );
    });

    // Save to Firebase via GrowthProvider
    final growthProvider = Provider.of<GrowthProvider>(context, listen: false);
    try {
      // Convert QuizResult objects to Map for Firebase
      final quizResultsMap = _progress.quizResults.map((key, value) => MapEntry(
        key,
        {
          'quizId': value.quizId,
          'score': value.score,
          'totalQuestions': value.totalQuestions,
          'correctAnswers': value.correctAnswers,
          'completedAt': value.completedAt.toIso8601String(),
          'passed': value.passed,
        },
      ));

      await growthProvider.saveCourseProgress(
        courseId: widget.course.id,
        completedVideoIds: _progress.completedVideoIds,
        quizResults: quizResultsMap,
        overallProgress: overallProgress,
      );
    } catch (e) {
      debugPrint('Error saving progress to Firebase: $e');
    }

    widget.onProgressUpdate(_progress);
  }

  Future<void> _openYouTubeVideo(String url, String videoId) async {
    try {
      // Ensure URL is properly formatted for YouTube
      String youtubeUrl = url;
      if (!youtubeUrl.startsWith('http://') && !youtubeUrl.startsWith('https://')) {
        youtubeUrl = 'https://$youtubeUrl';
      }
      
      // Parse the YouTube video ID from URL if needed
      String? extractedVideoId;
      try {
        final uri = Uri.parse(youtubeUrl);
        if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
          extractedVideoId = uri.queryParameters['v'] ?? 
                            (uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null);
        }
      } catch (e) {
        // Continue with provided videoId
      }
      
      // Try to launch with YouTube app first, fallback to browser
      final uri = Uri.parse(youtubeUrl);
      bool launched = false;
      
      // Try YouTube app first using the video ID
      final videoIdForApp = extractedVideoId ?? videoId;
      if (videoIdForApp.isNotEmpty) {
        try {
          // Try different YouTube app URI formats
          final youtubeAppUri = Uri.parse('vnd.youtube:$videoIdForApp');
          if (await canLaunchUrl(youtubeAppUri)) {
            launched = await launchUrl(youtubeAppUri, mode: LaunchMode.externalApplication);
          }
        } catch (e) {
          // Try alternative format
          try {
            final youtubeAppUri2 = Uri.parse('youtube://watch?v=$videoIdForApp');
            if (await canLaunchUrl(youtubeAppUri2)) {
              launched = await launchUrl(youtubeAppUri2, mode: LaunchMode.externalApplication);
            }
          } catch (e2) {
            // YouTube app not available, will use browser
          }
        }
      }
      
      // If YouTube app didn't launch, use browser
      if (!launched) {
        if (await canLaunchUrl(uri)) {
          launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
        } else {
          // Last resort - try opening in any available way
          launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
      
      if (launched) {
        // Mark video as completed after opening
        if (!_progress.completedVideoIds.contains(videoId) && mounted) {
          // Update completed video IDs
          final updatedCompletedVideos = [..._progress.completedVideoIds, videoId];
          
          // Calculate new progress
          final totalVideos = widget.course.videos.length;
          final completedVideos = updatedCompletedVideos.length;
          final totalQuizzes = widget.course.quizzes.length;
          final completedQuizzes = _progress.quizResults.length;

          final videoProgress = totalVideos > 0 ? completedVideos / totalVideos : 0.0;
          final quizProgress = totalQuizzes > 0 ? completedQuizzes / totalQuizzes : 0.0;
          final overallProgress = (videoProgress + quizProgress) / 2;

          setState(() {
            _progress = CourseProgress(
              courseId: _progress.courseId,
              completedVideoIds: updatedCompletedVideos,
              quizResults: _progress.quizResults,
              overallProgress: overallProgress,
            );
          });
          
          // Save to Firebase immediately
          final growthProvider = Provider.of<GrowthProvider>(context, listen: false);
          try {
            final quizResultsMap = _progress.quizResults.map((key, value) => MapEntry(
              key,
              {
                'quizId': value.quizId,
                'score': value.score,
                'totalQuestions': value.totalQuestions,
                'correctAnswers': value.correctAnswers,
                'completedAt': value.completedAt.toIso8601String(),
                'passed': value.passed,
              },
            ));

            await growthProvider.saveCourseProgress(
              courseId: widget.course.id,
              completedVideoIds: updatedCompletedVideos,
              quizResults: quizResultsMap,
              overallProgress: overallProgress,
            );
          } catch (e) {
            debugPrint('Error saving progress to Firebase: $e');
          }
          
          widget.onProgressUpdate(_progress);
        }
    } else {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorOpeningVideo),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    }
  } catch (e) {
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorOpeningVideoGeneral(e.toString())),
          backgroundColor: AppColors.dangerColor,
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
  bool isVideoCompleted(String videoId) =>
      _progress.completedVideoIds.contains(videoId);
    final totalVideos = widget.course.videos.length;
    final completedVideos = _progress.completedVideoIds.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: widget.course.title,
        showLogo: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ThemeHelper.spacingS(context),
                      vertical: ThemeHelper.spacingS(context) / 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(ThemeHelper.radiusS),
                    ),
                    child: Text(
                      _getLocalizedCategory(context, widget.course.category),
                      style: AppTextStyles.bodySmall1(context).copyWith(
                        color: AppColors.lightText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingM(context)),
                  // Title
                  Text(
                    widget.course.title,
                    style: AppTextStyles.heading2(context).copyWith(
                      color: AppColors.lightText,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsive(22),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ThemeHelper.spacingS(context)),
                  // Description - Scrollable
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: context.responsive(100),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.course.description,
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          color: AppColors.lightText.withValues(alpha: 0.9),
                          fontSize: context.responsive(14).clamp(12.0, double.infinity),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingM(context)),
                  // Course Info
                  Wrap(
                    spacing: ThemeHelper.spacingM(context),
                    runSpacing: ThemeHelper.spacingS(context),
                    children: [
                      _buildInfoChip(
                        context,
                        Icons.person_outline,
                        widget.course.instructor,
                      ),
                      _buildInfoChip(
                        context,
                        Icons.star,
                        '${widget.course.rating}',
                      ),
                      _buildInfoChip(
                        context,
                        Icons.access_time,
                        widget.course.duration,
                      ),
                    ],
                  ),
                  SizedBox(height: ThemeHelper.spacingM(context)),
                  // Progress Bar - Scrollable
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: context.responsive(100),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!.courseProgress,
                                  style: AppTextStyles.bodyMedium1(context).copyWith(
                                    color: AppColors.lightText,
                                    fontWeight: FontWeight.w600,
                                    fontSize: context.responsive(14).clamp(12.0, double.infinity),
                                  ),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.videosCount('$completedVideos/$totalVideos'),
                                style: AppTextStyles.bodySmall1(context).copyWith(
                                  color: AppColors.lightText.withValues(alpha: 0.8),
                                  fontSize: context.responsive(12).clamp(12.0, double.infinity),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ThemeHelper.spacingS(context)),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(ThemeHelper.radiusS),
                            child: LinearProgressIndicator(
                              value: _progress.overallProgress,
                              backgroundColor: AppColors.white.withValues(alpha: 0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.lightText,
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Course Content
            Padding(
              padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Videos Section
                  Text(
                    AppLocalizations.of(context)!.courseVideos,
                    style: AppTextStyles.heading4(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                      fontSize: context.responsive(18),
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingM(context)),
                  ...widget.course.videos.map((video) {
                    final isCompleted = isVideoCompleted(video.id);
                    return Card(
                      margin: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                        leading: Container(
                          width: context.responsive(50),
                          height: context.responsive(50),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppColors.successColor
                                : AppColors.mediumPurple,
                            borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                          ),
                          child: Icon(
                            isCompleted ? Icons.check : Icons.play_arrow,
                            color: AppColors.lightText,
                          ),
                        ),
                        title: Text(
                          video.title,
                          style: AppTextStyles.bodyMedium1(context).copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: context.responsive(14),
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: ThemeHelper.spacingS(context) / 2),
                            Text(
                              video.description,
                              style: AppTextStyles.bodySmall1(context),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: ThemeHelper.spacingS(context) / 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: context.responsive(14),
                                  color: AppColors.secondaryText,
                                ),
                                SizedBox(width: ThemeHelper.spacingS(context) / 2),
                                Text(
                                  video.duration,
                                  style: AppTextStyles.bodySmall1(context).copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.open_in_new,
                            color: AppColors.mediumPurple,
                          ),
                          onPressed: () => _openYouTubeVideo(video.youtubeUrl, video.youtubeVideoId),
                        ),
                        onTap: () => _openYouTubeVideo(video.youtubeUrl, video.youtubeVideoId),
                      ),
                    );
                  }),
                  // Quizzes Section
                  if (widget.course.quizzes.isNotEmpty) ...[
                    SizedBox(height: ThemeHelper.spacingXL(context)),
                    Text(
                      AppLocalizations.of(context)!.quickRecapQuizzes,
                      style: AppTextStyles.heading4(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                        fontSize: context.responsive(18),
                      ),
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    ...widget.course.quizzes.map((quiz) {
                      final quizResult = _progress.quizResults[quiz.id];
                      final isPassed = quizResult?.passed ?? false;
                      return Card(
                        margin: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                          leading: Container(
                            width: context.responsive(50),
                            height: context.responsive(50),
                            decoration: BoxDecoration(
                              color: isPassed
                                  ? AppColors.successColor
                                  : AppColors.softPink,
                              borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                            ),
                            child: Icon(
                              isPassed ? Icons.check_circle : Icons.quiz,
                              color: AppColors.lightText,
                            ),
                          ),
                          title: Text(
                            quiz.title,
                            style: AppTextStyles.bodyMedium1(context).copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: context.responsive(14),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ThemeHelper.spacingS(context) / 2),
                              Text(
                                quiz.description,
                                style: AppTextStyles.bodySmall1(context),
                              ),
                              if (quizResult != null) ...[
                                SizedBox(height: ThemeHelper.spacingS(context) / 2),
                                Text(
                                  AppLocalizations.of(context)!.scoreText(
                                    quizResult.score.toString(),
                                    quizResult.correctAnswers.toString(),
                                    quizResult.totalQuestions.toString(),
                                  ),
                                  style: AppTextStyles.bodySmall1(context).copyWith(
                                    color: isPassed
                                        ? AppColors.successColor
                                        : AppColors.dangerColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: context.responsive(16),
                            color: AppColors.mediumPurple,
                          ),
                          onTap: () async {
                            // Capture context and provider before async operations
                            final navigator = Navigator.of(context);
                            final growthProvider = Provider.of<GrowthProvider>(context, listen: false);
                            
                            final result = await navigator.push(
                              MaterialPageRoute(
                                builder: (_) => QuizScreen(
                                  quiz: quiz,
                                  courseId: widget.course.id,
                                ),
                              ),
                            );
                            
                            if (!mounted || result == null || result is! QuizResult) return;
                            
                            // Save quiz result to Firebase via GrowthProvider
                            try {
                              await growthProvider.saveQuizResult(
                                courseId: widget.course.id,
                                quizId: quiz.id,
                                score: result.score,
                                totalQuestions: result.totalQuestions,
                                correctAnswers: result.correctAnswers,
                                passed: result.passed,
                              );
                            } catch (e) {
                              debugPrint('Error saving quiz result to Firebase: $e');
                            }

                            if (!mounted) return;
                            setState(() {
                              _progress = CourseProgress(
                                courseId: _progress.courseId,
                                completedVideoIds: _progress.completedVideoIds,
                                quizResults: {
                                  ..._progress.quizResults,
                                  quiz.id: result,
                                },
                                overallProgress: _progress.overallProgress,
                              );
                            });
                            await _updateProgress();
                          },
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ThemeHelper.spacingS(context),
        vertical: ThemeHelper.spacingS(context) / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ThemeHelper.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.responsive(16), color: AppColors.lightText),
          SizedBox(width: ThemeHelper.spacingS(context) / 2),
          Text(
            text,
            style: AppTextStyles.bodySmall1(context).copyWith(
              color: AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedCategory(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'coding':
        return l10n.codingCategory;
      case 'digital_marketing':
        return l10n.marketingCategory;
      case 'wordpress':
        return l10n.wordpressCategory;
      case 'crochet':
        return l10n.crochetCategory;
      case 'knitting':
        return l10n.knittingCategory;
      default:
        return category;
    }
  }
}
