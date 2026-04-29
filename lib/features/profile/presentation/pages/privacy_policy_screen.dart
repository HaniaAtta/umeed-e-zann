import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/theme/theme_helper.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Privacy Policy',
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
              '1. Information We Collect',
              'We collect information that you provide directly to us, including:\n\n• Personal information (name, email, phone number)\n• Account credentials\n• Profile information\n• Usage data and preferences',
            ),
            _buildSection(
              context,
              '2. How We Use Your Information',
              'We use the information we collect to:\n\n• Provide, maintain, and improve our services\n• Process transactions and send related information\n• Send you technical notices and support messages\n• Respond to your comments and questions\n• Monitor and analyze trends and usage',
            ),
            _buildSection(
              context,
              '3. Information Sharing',
              'We do not sell, trade, or rent your personal information to third parties. We may share your information only in the following circumstances:\n\n• With your consent\n• To comply with legal obligations\n• To protect our rights and safety\n• With service providers who assist us in operating our app',
            ),
            _buildSection(
              context,
              '4. Data Security',
              'We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.',
            ),
            _buildSection(
              context,
              '5. Your Rights',
              'You have the right to:\n\n• Access your personal information\n• Correct inaccurate information\n• Request deletion of your information\n• Object to processing of your information\n• Data portability',
            ),
            _buildSection(
              context,
              '6. Cookies and Tracking',
              'We may use cookies and similar tracking technologies to track activity on our app and hold certain information. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent.',
            ),
            _buildSection(
              context,
              '7. Children\'s Privacy',
              'Our app is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13.',
            ),
            _buildSection(
              context,
              '8. Changes to This Policy',
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.',
            ),
            _buildSection(
              context,
              '9. Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at privacy@umeedezann.com',
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
