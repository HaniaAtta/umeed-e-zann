import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../contents/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/gradient_card.dart';
import 'verification_form_page.dart';

class VerificationStatusPage extends StatelessWidget {
  const VerificationStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    // Mock verification status - in real app, this would come from state/API
    final String status = 'pending'; // 'pending', 'approved', 'rejected', 'not_started'
    final String? rejectionReason = null;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Verification',
      ),
      body: SingleChildScrollView(
        padding: responsive.getPadding(),
        child: Column(
          children: [
            // Status card
            GradientCard(
              child: Column(
                children: [
                  _buildStatusIcon(status),
                  const SizedBox(height: 16),
                  Text(
                    _getStatusTitle(status),
                    style: TextStyle(
                      fontSize: responsive.getFontSize(24, 26, 28),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getStatusMessage(status),
                    style: TextStyle(
                      fontSize: responsive.getFontSize(14, 15, 16),
                      color: AppColors.darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (status == 'rejected' && rejectionReason != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Reason: $rejectionReason',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Verification steps
            _buildVerificationSteps(status, responsive),

            const SizedBox(height: 32),

            // Action button
            if (status == 'not_started' || status == 'rejected')
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerificationFormPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mediumPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_user, color: AppColors.white),
                    const SizedBox(width: 8),
                    Text(
                      status == 'not_started' ? 'Start Verification' : 'Resubmit Application',
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ],
                ),
              ),

            if (status == 'pending')
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Your verification is under review. This usually takes 1-3 business days.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (status == 'approved')
              GradientCard(
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 60,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Benefits of Verified Seller',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem('Verified badge on your profile'),
                    _buildBenefitItem('Increased trust from buyers'),
                    _buildBenefitItem('Priority in search results'),
                    _buildBenefitItem('Access to premium features'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'approved':
        icon = Icons.check_circle;
        color = AppColors.success;
        break;
      case 'rejected':
        icon = Icons.cancel;
        color = AppColors.error;
        break;
      case 'pending':
        icon = Icons.pending;
        color = AppColors.warning;
        break;
      default:
        icon = Icons.verified_user_outlined;
        color = AppColors.white;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 60,
        color: color,
      ),
    );
  }

  String _getStatusTitle(String status) {
    switch (status) {
      case 'approved':
        return 'Verified Seller';
      case 'rejected':
        return 'Verification Rejected';
      case 'pending':
        return 'Verification Pending';
      default:
        return 'Not Verified';
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'approved':
        return 'Congratulations! Your seller account has been verified.';
      case 'rejected':
        return 'Your verification application was rejected. Please review the reason and resubmit.';
      case 'pending':
        return 'Your verification application is currently under review.';
      default:
        return 'Complete the verification process to become a verified seller.';
    }
  }

  Widget _buildVerificationSteps(String status, Responsive responsive) {
    final steps = [
      {'title': 'Personal Information', 'completed': status != 'not_started'},
      {'title': 'Identity Verification', 'completed': status == 'approved' || status == 'pending'},
      {'title': 'Document Upload', 'completed': status == 'approved' || status == 'pending'},
      {'title': 'Review & Approval', 'completed': status == 'approved'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verification Steps',
              style: TextStyle(
                fontSize: responsive.getFontSize(18, 20, 22),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCompleted = step['completed'] as bool;
              final isCurrent = !isCompleted &&
                  (index == 0 || steps[index - 1]['completed'] as bool);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppColors.success
                            : isCurrent
                                ? AppColors.primaryPink
                                : AppColors.grey,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, color: AppColors.white, size: 20)
                            : Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step['title'] as String,
                        style: TextStyle(
                          fontSize: responsive.getFontSize(14, 15, 16),
                          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                          color: isCompleted || isCurrent
                              ? AppColors.primaryDark
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            size: 20,
            color: AppColors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

