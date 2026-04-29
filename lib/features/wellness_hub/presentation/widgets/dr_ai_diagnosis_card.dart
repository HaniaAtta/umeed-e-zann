import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import 'doctorbot_quiz_dialogs.dart';

/// Doctorbot Card Widget
/// Friendly doctor bot call-to-action card with health check options
/// Medical-grade but friendly design
class DrAiDiagnosisCard extends StatelessWidget {
  const DrAiDiagnosisCard({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacingXL),
      padding: responsive.paddingXL,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.white,
            AppColors.palePink.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(responsive.radiusXL),
        border: Border.all(
          color: AppColors.softPink.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: responsive.spacingXL,
            offset: Offset(0, responsive.spacingM),
          ),
        ],
      ),
      child: Column(
        children: [
          // Doctor Avatar and Text Bubble
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Avatar
              Container(
                width: responsive.size(80),
                height: responsive.size(80),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.secondaryPurple,
                      AppColors.accentPurple,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryPurple.withValues(alpha: 0.3),
                      blurRadius: responsive.spacingL,
                      offset: Offset(0, responsive.spacingS),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.face_3_rounded,
                  color: AppColors.white,
                  size: responsive.iconSize(40),
                ),
              ),
              
              SizedBox(width: responsive.spacingM),
              
              // Text Bubble
              Expanded(
                child: Container(
                  padding: responsive.paddingL,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(responsive.radiusM),
                      topRight: Radius.circular(responsive.radiusL),
                      bottomLeft: Radius.circular(responsive.radiusL),
                      bottomRight: Radius.circular(responsive.radiusL),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withValues(alpha: 0.05),
                        blurRadius: responsive.spacingS,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Not feeling right? Doctorbot can help assess your symptoms.',
                    style: AppTextStyles.bodyLarge(
                      color: AppColors.primaryDark,
                    ).copyWith(
                      fontSize: responsive.fontSize(15),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: responsive.spacingXL),
          
          // Action Buttons - Health Check Chips
          Wrap(
            spacing: responsive.spacingM,
            runSpacing: responsive.spacingM,
            children: [
              _buildHealthCheckChip(
                context: context,
                label: 'PCOS Assessment',
                responsive: responsive,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const PCOSQuizDialog(),
                  );
                },
              ),
              _buildHealthCheckChip(
                context: context,
                label: 'Endometriosis Assessment',
                responsive: responsive,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const EndometriosisQuizDialog(),
                  );
                },
              ),
              _buildHealthCheckChip(
                context: context,
                label: 'Breast Health Assessment',
                responsive: responsive,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const BreastHealthQuizDialog(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCheckChip({
    required BuildContext context,
    required String label,
    required Responsive responsive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusRound),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.spacingL,
            vertical: responsive.spacingM,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.dustyPink,
                AppColors.softPink,
              ],
            ),
            borderRadius: BorderRadius.circular(responsive.radiusRound),
            boxShadow: [
              BoxShadow(
                color: AppColors.dustyPink.withValues(alpha: 0.3),
                blurRadius: responsive.spacingS,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: AppTextStyles.bodyMedium(
              color: AppColors.white,
            ).copyWith(
              fontSize: responsive.fontSize(13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}






