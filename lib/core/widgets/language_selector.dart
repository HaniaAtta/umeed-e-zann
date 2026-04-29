import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

import '../../contents/colors.dart';
import '../../contents/textstyles.dart';
import '../services/locale_service.dart';
import '../theme/theme_helper.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Provider.of<LocaleService>(context);
    final localizations = AppLocalizations.of(context);
    final currentLocale = localeService.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations?.language ?? 'Language',
          style: AppTextStyles.heading3(context),
        ),
        backgroundColor: AppColors.primaryPink,
        foregroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          // Current language indicator
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
            margin: EdgeInsets.all(ThemeHelper.spacingM(context)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryPink.withValues(alpha: 0.1),
                  AppColors.mediumPurple.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
              border: Border.all(
                color: AppColors.primaryPink.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  color: AppColors.primaryPink,
                  size: 32,
                ),
                SizedBox(width: ThemeHelper.spacingM(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Language',
                        style: AppTextStyles.bodySmall1(context).copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        LocaleService.languageNames[currentLocale.languageCode] ?? 
                        currentLocale.languageCode.toUpperCase(),
                        style: AppTextStyles.heading4(context).copyWith(
                          color: AppColors.primaryPink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Language list
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: ThemeHelper.spacingM(context)),
              children: LocaleService.supportedLocales.map((locale) {
                final isSelected = localeService.locale == locale;
                final languageName = LocaleService.languageNames[locale.languageCode] ?? locale.languageCode;

                return Card(
                  margin: EdgeInsets.only(bottom: ThemeHelper.spacingS(context)),
                  elevation: isSelected ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                    side: BorderSide(
                      color: isSelected 
                          ? AppColors.primaryPink 
                          : AppColors.lightGrey,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.primaryPink.withValues(alpha: 0.1)
                            : AppColors.lightGrey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSelected ? Icons.check_circle : Icons.language,
                        color: isSelected ? AppColors.primaryPink : AppColors.grey,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      languageName,
                      style: AppTextStyles.bodyMedium1(context).copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primaryPink : AppColors.primaryText,
                      ),
                    ),
                    subtitle: Text(
                      '${locale.languageCode.toUpperCase()}${locale.countryCode != null ? '-${locale.countryCode}' : ''}',
                      style: AppTextStyles.bodySmall1(context),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.radio_button_checked,
                            color: AppColors.primaryPink,
                          )
                        : null,
                    onTap: () {
                      localeService.setLocale(locale);
                      // Show confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Language changed to $languageName',
                            style: TextStyle(color: AppColors.white),
                          ),
                          backgroundColor: AppColors.primaryPink,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    selected: isSelected,
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Info banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
            margin: EdgeInsets.all(ThemeHelper.spacingM(context)),
            decoration: BoxDecoration(
              color: AppColors.mediumPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.mediumPurple,
                  size: 20,
                ),
                SizedBox(width: ThemeHelper.spacingS(context)),
                Expanded(
                  child: Text(
                    'Changing language will update all text in the app',
                    style: AppTextStyles.bodySmall1(context).copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

