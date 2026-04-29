import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../data/models/course_model.dart';
import '../viewmodels/growth_provider.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  final CourseProgress? progress;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.progress,
    required this.onTap,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GrowthProvider>(
      builder: (context, provider, _) {
        final isBookmarked = provider.isBookmarked(widget.course.id);
        final progressPercentage = widget.progress?.overallProgress ?? 0.0;
        final isStarted = progressPercentage > 0.0;

        Future<void> toggleBookmark() async {
          if (isBookmarked) {
            await provider.unbookmarkCourse(widget.course.id);
          } else {
            await provider.bookmarkCourse(widget.course.id);
          }
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
          ),
          margin: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ThemeHelper.radiusL),
                    topRight: Radius.circular(ThemeHelper.radiusL),
                  ),
                  child: Container(
                    height: context.responsive(180),
                    width: double.infinity,
                    color: AppColors.mediumPurple.withValues(alpha: 0.3),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            _getCategoryIcon(widget.course.category),
                            size: context.responsive(60),
                            color: AppColors.mediumPurple,
                          ),
                        ),
                        Positioned(
                          top: ThemeHelper.spacingS(context),
                          right: ThemeHelper.spacingS(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isStarted)
                                Container(
                                  margin: EdgeInsets.only(right: ThemeHelper.spacingS(context)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ThemeHelper.spacingS(context),
                                    vertical: ThemeHelper.spacingS(context) / 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.successColor,
                                    borderRadius: BorderRadius.circular(ThemeHelper.radiusS),
                                  ),
                                  child: Text(
                                    '${(progressPercentage * 100).toInt()}%',
                                    style: AppTextStyles.bodySmall1(context).copyWith(
                                      color: AppColors.lightText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              InkWell(
                                onTap: toggleBookmark,
                                borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                                child: Container(
                                  padding: EdgeInsets.all(ThemeHelper.spacingS(context)),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.grey.withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        offset: Offset(context.responsive(0), context.responsive(2)),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                    color: isBookmarked ? AppColors.mediumPurple : AppColors.grey,
                                    size: context.responsive(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
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
                          color: _getCategoryColor(widget.course.category).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(ThemeHelper.radiusS),
                        ),
                        child: Text(
                          _getLocalizedCategory(context, widget.course.category),
                          style: AppTextStyles.bodySmall1(context).copyWith(
                            color: _getCategoryColor(widget.course.category),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: ThemeHelper.spacingS(context)),
                      // Course Title
                      Text(
                        widget.course.title,
                        style: AppTextStyles.heading3(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ThemeHelper.spacingS(context) / 2),
                      // Instructor
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: context.responsive(16),
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: ThemeHelper.spacingS(context) / 2),
                          Expanded(
                            child: Text(
                              widget.course.instructor,
                              style: AppTextStyles.bodySmall1(context).copyWith(
                                color: AppColors.secondaryText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ThemeHelper.spacingS(context)),
                      // Course Info Row
                      Row(
                        children: [
                          // Rating
                          Icon(
                            Icons.star,
                            size: context.responsive(16),
                            color: AppColors.amber,
                          ),
                          SizedBox(width: ThemeHelper.spacingS(context) / 2),
                          Text(
                            widget.course.rating.toString(),
                            style: AppTextStyles.bodySmall1(context).copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(width: ThemeHelper.spacingM(context)),
                          // Duration
                          Icon(
                            Icons.access_time,
                            size: context.responsive(16),
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: ThemeHelper.spacingS(context) / 2),
                          Text(
                            widget.course.duration,
                            style: AppTextStyles.bodySmall1(context).copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(width: ThemeHelper.spacingM(context)),
                          // Level
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ThemeHelper.spacingS(context) / 2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getLevelColor(widget.course.level).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(ThemeHelper.radiusS),
                            ),
                            child: Text(
                              _getLocalizedLevel(context, widget.course.level),
                              style: AppTextStyles.bodySmall1(context).copyWith(
                                color: _getLevelColor(widget.course.level),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Progress Bar (if started)
                      if (isStarted) ...[
                        SizedBox(height: ThemeHelper.spacingM(context)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(ThemeHelper.radiusS),
                          child: LinearProgressIndicator(
                            value: progressPercentage,
                            backgroundColor: AppColors.lightGrey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getCategoryColor(widget.course.category),
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'coding':
        return Icons.code;
      case 'digital_marketing':
        return Icons.trending_up;
      case 'wordpress':
        return Icons.web;
      default:
        return Icons.school;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'coding':
        return AppColors.mediumBluePurple;
      case 'digital_marketing':
        return AppColors.softPink;
      case 'wordpress':
        return AppColors.dustyRose;
      default:
        return AppColors.mediumPurple;
    }
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'beginner':
        return AppColors.successColor;
      case 'intermediate':
        return AppColors.amber;
      case 'advanced':
        return AppColors.dangerColor;
      default:
        return AppColors.secondaryText;
    }
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

  String _getLocalizedLevel(BuildContext context, String level) {
    final l10n = AppLocalizations.of(context)!;
    switch (level) {
      case 'beginner':
        return l10n.beginnerLevel;
      case 'intermediate':
        return l10n.intermediateLevel;
      case 'advanced':
        return l10n.advancedLevel;
      default:
        return level;
    }
  }
}
