import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';

/// Vent Box Widget
/// Interactive section with prompt chips, text input, and release button
/// Paper texture background for the text field
/// Added a celebratory animation when the thought is released
class VentBox extends StatefulWidget {
  const VentBox({super.key});

  @override
  State<VentBox> createState() => _VentBoxState();
}

class _VentBoxState extends State<VentBox> {
  final TextEditingController _textController = TextEditingController();
  String? _selectedPrompt;
  bool _showReleaseAnim = false;

  final List<String> prompts = ['Anxiety', 'Gratitude', 'Safety'];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    setState(() => _showReleaseAnim = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _showReleaseAnim = false);
    });
  }

  void _releaseThought() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please write something before releasing'),
          backgroundColor: AppColors.primaryDark,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Your thought has been released into the universe'),
        backgroundColor: AppColors.primaryDark,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );

    _triggerAnimation();

    // Clear the text
    _textController.clear();
    setState(() {
      _selectedPrompt = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: responsive.paddingXL,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(responsive.radiusXL),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.08),
                blurRadius: responsive.spacingL,
                offset: Offset(0, responsive.spacingS),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Vent Box',
                style: AppTextStyles.headingSmall(
                  color: AppColors.primaryDark,
                ).copyWith(
                  fontSize: responsive.fontSize(20),
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              SizedBox(height: responsive.spacingL),
              
              // Prompt chips - horizontal scroll
              SizedBox(
                height: responsive.size(50),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: prompts.length,
                  itemBuilder: (context, index) {
                    final prompt = prompts[index];
                    final isSelected = _selectedPrompt == prompt;
                    
                    return Padding(
                      padding: EdgeInsets.only(right: responsive.spacingM),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedPrompt = isSelected ? null : prompt;
                            });
                          },
                          borderRadius: BorderRadius.circular(responsive.radiusRound),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.spacingL,
                              vertical: responsive.spacingM,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.softPink
                                  : AppColors.softPink.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(responsive.radiusRound),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.softPink
                                    : AppColors.softPink.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                prompt,
                                style: AppTextStyles.bodyMedium(
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.primaryDark,
                                ).copyWith(
                                  fontSize: responsive.fontSize(14),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              SizedBox(height: responsive.spacingXL),
              
              // Text input with paper texture
              Container(
                height: responsive.size(200),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(responsive.radiusL),
                  border: Border.all(
                    color: AppColors.lightGrey,
                    width: 1,
                  ),
                  // Paper texture effect using gradient
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.white,
                      AppColors.background,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.primaryDark,
                  ).copyWith(
                    fontSize: responsive.fontSize(15),
                    height: 1.6,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write your thoughts here...',
                    hintStyle: AppTextStyles.bodyMedium(
                      color: AppColors.grey,
                    ).copyWith(
                      fontSize: responsive.fontSize(15),
                    ),
                    border: InputBorder.none,
                    contentPadding: responsive.paddingL,
                  ),
                ),
              ),
              
              SizedBox(height: responsive.spacingXL),
              
              // Release button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _releaseThought,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.softPink,
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
                    'Release Thought',
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
        ),

        // Celebration animation overlay
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _showReleaseAnim ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: AnimatedScale(
                  scale: _showReleaseAnim ? 1.1 : 0.8,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                  child: Container(
                    padding: EdgeInsets.all(responsive.spacingL),
                    decoration: BoxDecoration(
                      color: AppColors.softPink.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.softPink.withValues(alpha: 0.3),
                          blurRadius: responsive.spacingL,
                          spreadRadius: responsive.spacingS,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.secondaryPurple,
                          size: responsive.iconSize(36),
                        ),
                        SizedBox(height: responsive.spacingS),
                        Text(
                          'Released!',
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.primaryDark,
                          ).copyWith(
                            fontSize: responsive.fontSize(16),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}





