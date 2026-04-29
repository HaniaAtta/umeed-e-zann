import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../viewmodels/safety_provider.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class TrustedContactsScreen extends StatefulWidget {
  const TrustedContactsScreen({super.key});

  @override
  State<TrustedContactsScreen> createState() => _TrustedContactsScreenState();
}

class _TrustedContactsScreenState extends State<TrustedContactsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load trusted contacts when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SafetyProvider>(context, listen: false);
      provider.initialize();
      provider.loadTrustedContacts();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  void _showAddContactDialog() {
    _nameController.clear();
    _phoneController.clear();
    _relationController.clear();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
        ),
        child: Container(
          padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.addTrustedContact,
                  style: AppTextStyles.heading3(context),
                ),
                SizedBox(height: ThemeHelper.spacingL(context)),
                CustomTextField(
                  label: AppLocalizations.of(context)!.name,
                  hint: AppLocalizations.of(context)!.enterContactName,
                  controller: _nameController,
                ),
                SizedBox(height: ThemeHelper.spacingM(context)),
                CustomTextField(
                  label: AppLocalizations.of(context)!.phoneNumber,
                  hint: '+1 234-567-8900',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: ThemeHelper.spacingM(context)),
                CustomTextField(
                  label: AppLocalizations.of(context)!.relation,
                  hint: AppLocalizations.of(context)!.familyFriendHint,
                  controller: _relationController,
                ),
                SizedBox(height: ThemeHelper.spacingL(context)),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: AppLocalizations.of(context)!.cancel,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: AppColors.lightGrey,
                        textColor: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(width: ThemeHelper.spacingM(context)),
                    Expanded(
                      child: CustomButton(
                        text: AppLocalizations.of(context)!.add,
                        onPressed: () async {
                          if (_nameController.text.isNotEmpty &&
                              _phoneController.text.isNotEmpty) {
                            // Store context-dependent objects before async
                            final provider = Provider.of<SafetyProvider>(context, listen: false);
                            final name = _nameController.text;
                            final phone = _phoneController.text;
                            final navigator = Navigator.of(context);
                            final messenger = ScaffoldMessenger.of(context);
                            final l10n = AppLocalizations.of(context);

                            final relation = _relationController.text.isEmpty
                                ? l10n?.contactLabel ?? 'Contact'
                                : _relationController.text;
                            
                            await provider.addTrustedContact(
                              name: name,
                              phone: phone,
                              relation: relation,
                            );
                            
                            if (!mounted) return;
                            
                            final error = provider.error;
                            navigator.pop();
                            
                            if (!mounted) return;
                            
                            if (error != null) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(error),
                                  backgroundColor: AppColors.dangerColor,
                                ),
                              );
                            } else {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(l10n?.contactAddedSuccess ?? 'Contact added successfully'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteContact(String phone, String name) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: AppLocalizations.of(context)!.deleteContact,
        message: AppLocalizations.of(context)!.deleteContactConfirm(name),
        confirmText: AppLocalizations.of(context)!.delete,
        cancelText: AppLocalizations.of(context)!.cancel,
        icon: Icons.warning,
        iconColor: AppColors.dangerColor,
        onConfirm: () async {
          // Store context-dependent objects before async
          final provider = Provider.of<SafetyProvider>(context, listen: false);
          final contactPhone = phone;
          final navigator = Navigator.of(context);
          final messenger = ScaffoldMessenger.of(context);
          final l10n = AppLocalizations.of(context);
          
          await provider.removeTrustedContact(contactPhone);
          
          if (!mounted) return;
          
          final error = provider.error;
          navigator.pop();
          
          if (!mounted) return;
          
          if (error != null) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: AppColors.dangerColor,
              ),
            );
          } else {
            messenger.showSnackBar(
              SnackBar(
                content: Text(l10n?.contactRemoved ?? 'Contact removed'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.trustedContactsTitle,
        showLogo: true,
        showBackButton: true,
      ),
      body: SafeArea(
        child: Consumer<SafetyProvider>(
          builder: (context, provider, _) {
            // Use entities directly or convert to map for backward compatibility
            final contacts = provider.trustedContacts;

            return Column(
              children: [
                // Header Info
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
                  margin: EdgeInsets.all(ThemeHelper.spacingL(context)),
                  decoration: BoxDecoration(
                    color: AppColors.mediumPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                    border: Border.all(
                      color: AppColors.mediumPurple.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.contacts,
                        size: context.responsive(40),
                        color: AppColors.mediumPurple,
                      ),
                      SizedBox(height: ThemeHelper.spacingS(context)),
                      Text(
                        AppLocalizations.of(context)!.trustedContactsDesc,
                        style: AppTextStyles.bodyMedium1(context),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Contacts List
                Expanded(
                  child: provider.isLoading && contacts.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : contacts.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.contact_phone_outlined,
                                    size: context.responsive(80),
                                    color: AppColors.grey,
                                  ),
                                  SizedBox(height: ThemeHelper.spacingL(context)),
                                  Text(
                                    AppLocalizations.of(context)!.noTrustedContacts,
                                    style: AppTextStyles.heading4(context),
                                  ),
                                  SizedBox(height: ThemeHelper.spacingS(context)),
                                  Text(
                                    AppLocalizations.of(context)!.addContactsToReceiveSos,
                                    style: AppTextStyles.bodySmall1(context),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: ThemeHelper.spacingL(context),
                              ),
                              itemCount: contacts.length,
                              itemBuilder: (context, index) {
                                final contact = contacts[index];
                                final name = contact.name;
                                final phone = contact.phone;
                                final relation = contact.relation ?? AppLocalizations.of(context)!.contactLabel;
                                
                                return Container(
                                  margin: EdgeInsets.only(
                                    bottom: ThemeHelper.spacingM(context),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(
                                      ThemeHelper.radiusL,
                                    ),
                                    boxShadow: ThemeHelper.cardShadow,
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(
                                      ThemeHelper.spacingM(context),
                                    ),
                                    leading: Container(
                                      width: context.responsive(50),
                                      height: context.responsive(50),
                                      decoration: BoxDecoration(
                                        color: AppColors.mediumPurple.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        color: AppColors.mediumPurple,
                                        size: context.responsive(28),
                                      ),
                                    ),
                                    title: Text(
                                      name,
                                      style: AppTextStyles.heading4(context),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: ThemeHelper.spacingXS(context)),
                                        Text(
                                          phone,
                                          style: AppTextStyles.bodySmall1(context),
                                        ),
                                        SizedBox(height: ThemeHelper.spacingXS(context)),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ThemeHelper.spacingS(context),
                                            vertical: ThemeHelper.spacingXS(context),
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.softPink.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              ThemeHelper.radiusS,
                                            ),
                                          ),
                                          child: Text(
                                            relation,
                                            style: AppTextStyles.caption1(context).copyWith(
                                              color: AppColors.softPink,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: AppColors.dangerColor,
                                        size: context.responsive(24),
                                      ),
                                      onPressed: () => _deleteContact(phone, name),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),

                // Add Button
                Padding(
                  padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
                  child: CustomButton(
                    text: AppLocalizations.of(context)!.addTrustedContact,
                    icon: Icons.add,
                    onPressed: provider.isLoading ? null : _showAddContactDialog,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
