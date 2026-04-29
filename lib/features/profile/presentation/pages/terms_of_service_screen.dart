import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/theme/theme_helper.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Terms of Service',
        showLogo: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: ${DateTime.now().toString().split(' ')[0]}',
              style: AppTextStyles.bodySmall1(context).copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),
            _buildSection(
              context,
              '1. Acceptance of Terms',
              'By accessing and using امید زن, you accept and agree to be bound by the terms and provision of this agreement.',
            ),
            _buildSection(
              context,
              '2. Use License',
              'Permission is granted to temporarily download one copy of امید زن for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the materials\n• Use the materials for any commercial purpose\n• Attempt to decompile or reverse engineer any software\n• Remove any copyright or other proprietary notations',
            ),
            _buildSection(
              context,
              '3. User Account',
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
            ),
            _buildSection(
              context,
              '4. Privacy',
              'Your use of امید زن is also governed by our Privacy Policy. Please review our Privacy Policy to understand our practices.',
            ),
            _buildSection(
              context,
              '5. Prohibited Uses',
              'You may not use امید زن:\n\n• In any way that violates any applicable law or regulation\n• To transmit any malicious code or viruses\n• To impersonate or attempt to impersonate the company\n• In any way that infringes upon the rights of others',
            ),
            _buildSection(
              context,
              '6. Disclaimer',
              'The materials on امید زن are provided on an "as is" basis. امید زن makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties.',
            ),
            _buildSection(
              context,
              '7. Limitations',
              'In no event shall امید زن or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit) arising out of the use or inability to use the materials on امید زن.',
            ),
            _buildSection(
              context,
              '8. Contact Information',
              'If you have any questions about these Terms of Service, please contact us at support@umeedezann.com',
            ),
            SizedBox(height: ThemeHelper.spacingXL(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: ThemeHelper.spacingXL(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.heading3(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.mediumPurple,
            ),
          ),
          SizedBox(height: ThemeHelper.spacingM(context)),
          Text(
            content,
            style: AppTextStyles.bodyMedium1(context).copyWith(
              color: AppColors.primaryText,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
