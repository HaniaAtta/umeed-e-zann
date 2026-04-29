import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/doctor.dart';

/// Doctor Card Widget
/// Shows doctor information with availability indicators
/// Chat icon is very distinct as a key safety feature
class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onViewProfile;
  final VoidCallback? onBookAppointment;
  final VoidCallback? onChat;
  final VoidCallback? onVideoCall;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onViewProfile,
    this.onBookAppointment,
    this.onChat,
    this.onVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacingL),
      padding: responsive.paddingL,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(responsive.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: responsive.spacingL,
            offset: Offset(0, responsive.spacingS),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Row: Avatar, Info, Indicators
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Circular Avatar
              Container(
                width: responsive.size(70),
                height: responsive.size(70),
                decoration: BoxDecoration(
                  color: AppColors.palePink,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.softPink.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.secondaryPurple,
                  size: responsive.iconSize(35),
                ),
              ),
              
              SizedBox(width: responsive.spacingM),
              
              // Middle: Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: AppTextStyles.bodyLarge(
                        color: AppColors.primaryDark,
                      ).copyWith(
                        fontSize: responsive.fontSize(17),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: responsive.spacingXS),
                    Text(
                      doctor.specialty,
                      style: AppTextStyles.bodySmall(
                        color: AppColors.grey,
                      ).copyWith(
                        fontSize: responsive.fontSize(14),
                      ),
                    ),
                    SizedBox(height: responsive.spacingXS),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: responsive.iconSize(16),
                        ),
                        SizedBox(width: responsive.spacingXS),
                        Text(
                          doctor.ratingString,
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.primaryDark,
                          ).copyWith(
                            fontSize: responsive.fontSize(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Right: Availability Indicators (Clickable)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Video Camera Icon (Green) - if available
                  if (doctor.isVideoAvailable)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onVideoCall,
                        borderRadius: BorderRadius.circular(responsive.radiusS),
                        child: Container(
                          margin: EdgeInsets.only(right: responsive.spacingS),
                          padding: responsive.paddingS,
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(responsive.radiusS),
                          ),
                          child: Icon(
                            Icons.videocam_rounded,
                            color: Colors.green,
                            size: responsive.iconSize(20),
                          ),
                        ),
                      ),
                    ),
                  
                  // Chat Bubble Icon (Purple) - Very Distinct
                  if (doctor.isChatAvailable)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onChat,
                        borderRadius: BorderRadius.circular(responsive.radiusS),
                        child: Container(
                          padding: responsive.paddingS,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryPurple.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(responsive.radiusS),
                            border: Border.all(
                              color: AppColors.secondaryPurple,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.chat_bubble_rounded,
                            color: AppColors.secondaryPurple,
                            size: responsive.iconSize(22),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: responsive.spacingM),
          
          // Bottom: Action Buttons
          Row(
            children: [
              if (onBookAppointment != null)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onBookAppointment,
                    icon: Icon(
                      Icons.calendar_today_rounded,
                      size: responsive.iconSize(18),
                    ),
                    label: Text(
                      'Book',
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.white,
                      ).copyWith(
                        fontSize: responsive.fontSize(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryPurple,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: responsive.spacingM),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.radiusM),
                      ),
                    ),
                  ),
                ),
              if (onBookAppointment != null) SizedBox(width: responsive.spacingM),
              Expanded(
                child: TextButton(
                  onPressed: onViewProfile,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: responsive.spacingM),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(responsive.radiusM),
                    ),
                  ),
                  child: Text(
                    'View Profile',
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.secondaryPurple,
                    ).copyWith(
                      fontSize: responsive.fontSize(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}






