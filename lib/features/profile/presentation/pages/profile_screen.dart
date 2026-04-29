import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../contents/assets.dart';
import '../../../../core/services/user_service.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../../../../features/auth/presentation/viewmodels/auth_provider.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final ImagePicker _imagePicker = ImagePicker();
  final StorageService _storageService = StorageService();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  bool _isEditing = false;
  File? _profileImage;
  String? _profileImageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _userService.userName);
    _emailController = TextEditingController(text: _userService.userEmail);
    _phoneController = TextEditingController(text: _userService.userPhone);
    _locationController = TextEditingController(text: _userService.userLocation);
    _userService.addListener(_onUserDataChanged);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Capture provider before async operations
    if (!mounted) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    await _userService.loadUserData();
    await authProvider.getCurrentUser();
    final user = authProvider.currentUser;
    
    if (!mounted) return;
    
    setState(() {
      _nameController.text = _userService.userName;
      _emailController.text = _userService.userEmail;
      _phoneController.text = _userService.userPhone;
      _locationController.text = _userService.userLocation;
      _profileImageUrl = user?.profileImageUrl;
    });
  }

  @override
  void dispose() {
    _userService.removeListener(_onUserDataChanged);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onUserDataChanged() {
    if (mounted && !_isEditing) {
      setState(() {
        _nameController.text = _userService.userName;
        _emailController.text = _userService.userEmail;
        _phoneController.text = _userService.userPhone;
        _locationController.text = _userService.userLocation;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        if (!mounted) return;
        setState(() {
          _profileImage = File(image.path);
          _isUploadingImage = true;
        });
        
        // Upload image to Firebase Storage
        try {
          final imageUrl = await _storageService.uploadProfileImage(_profileImage!);
          
          if (!mounted) return;
          setState(() {
            _profileImageUrl = imageUrl;
            _isUploadingImage = false;
          });
          
          // Save image URL to Firestore
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final userId = authProvider.currentUser?.id;
          if (userId != null) {
            await authProvider.updateUserData(userId, {
              'profileImageUrl': imageUrl,
            });
          }
          
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.imageUploaded),
                backgroundColor: AppColors.successColor,
                duration: Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            setState(() {
              _isUploadingImage = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${l10n.imageUploadFailed}: $e'),
                backgroundColor: AppColors.dangerColor,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _isUploadingImage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.pickImageError}: $e'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;
    // Validate email if provided
    final email = _emailController.text.trim();
    if (email.isNotEmpty && !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.validEmailError),
          backgroundColor: AppColors.dangerColor,
        ),
      );
      return;
    }

    setState(() {
      _isEditing = false;
    });

    try {
      // Update all fields - update UserService first
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final location = _locationController.text.trim();

      if (name.isNotEmpty) {
        _userService.updateUserName(name);
      }
      if (email.isNotEmpty) {
        _userService.updateUserEmail(email);
      }
      if (phone.isNotEmpty) {
        _userService.updateUserPhone(phone);
      }
      if (location.isNotEmpty) {
        _userService.updateUserLocation(location);
      }

      // Save to Firebase
      await _userService.saveUserData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdated),
            backgroundColor: AppColors.successColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isEditing = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.profileUpdateFailed}: $e'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'profile'),
      appBar: CustomAppBar(
        title: l10n.profile,
        showLogo: true,
        showBackButton: false,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.lightText),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          else
            IconButton(
              icon: Icon(Icons.check, color: AppColors.lightText),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.softPink.withValues(alpha: 0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: ThemeHelper.spacingXL(context)),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(ThemeHelper.radiusXL),
                    bottomRight: Radius.circular(ThemeHelper.radiusXL),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mediumPurple.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: ThemeHelper.spacingXL(context)),
                    // Profile picture
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.mediumPurple, AppColors.softPink],
                            ),
                          ),
                          child: GestureDetector(
                            onTap: _isEditing ? _pickImage : null,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: context.responsive(60),
                                  backgroundColor: AppColors.white,
                                  backgroundImage: _profileImage != null
                                      ? FileImage(_profileImage!)
                                      : (_profileImageUrl != null
                                          ? NetworkImage(_profileImageUrl!)
                                          : null),
                                  child: _profileImage == null && _profileImageUrl == null
                                      ? Image.asset(
                                          AppAssets.logo,
                                          width: context.responsive(100),
                                          height: context.responsive(100),
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              size: context.responsive(60),
                                              color: AppColors.mediumPurple,
                                            );
                                          },
                                        )
                                      : null,
                                ),
                                if (_isUploadingImage)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightText),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: EdgeInsets.all(context.responsive(8)),
                                decoration: BoxDecoration(
                                  color: AppColors.mediumPurple,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.white, width: 2),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: context.responsive(18),
                                  color: AppColors.lightText,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    if (!_isEditing)
                      Text(
                        _userService.userName.isNotEmpty ? _userService.userName : l10n.fullName,
                        style: AppTextStyles.heading2(context),
                      ),
                  ],
                ),
              ),
              SizedBox(height: ThemeHelper.spacingXL(context)),
              // Profile information cards
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ThemeHelper.spacingL(context),
                ),
                child: Column(
                  children: [
                    _buildEditableField(
                      context,
                      l10n.fullName,
                      _nameController,
                      Icons.person_outline,
                      enabled: _isEditing,
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    _buildEditableField(
                      context,
                      l10n.email,
                      _emailController,
                      Icons.mail_outline,
                      enabled: _isEditing,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    _buildEditableField(
                      context,
                      l10n.phone,
                      _phoneController,
                      Icons.phone_outlined,
                      enabled: _isEditing,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: ThemeHelper.spacingM(context)),
                    _buildEditableField(
                      context,
                      l10n.location,
                      _locationController,
                      Icons.location_on_outlined,
                      enabled: _isEditing,
                    ),
                  ],
                ),
              ),
              if (_isEditing) ...[
                SizedBox(height: ThemeHelper.spacingXL(context)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ThemeHelper.spacingXL(context),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Reset controllers to current UserService values
                            _nameController.text = _userService.userName;
                            _emailController.text = _userService.userEmail;
                            _phoneController.text = _userService.userPhone;
                            _locationController.text = _userService.userLocation;
                            
                            setState(() {
                              _isEditing = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.mediumPurple, width: 2),
                            padding: EdgeInsets.symmetric(
                              vertical: ThemeHelper.spacingM(context),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                            ),
                          ),
                          child: Text(
                            l10n.cancel,
                            style: AppTextStyles.buttonMedium(context).copyWith(
                              color: AppColors.mediumPurple,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ThemeHelper.spacingM(context)),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mediumPurple,
                            padding: EdgeInsets.symmetric(
                              vertical: ThemeHelper.spacingM(context),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                            ),
                          ),
                          child: Text(
                            l10n.save,
                            style: AppTextStyles.buttonMedium(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: ThemeHelper.spacingXL(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
              decoration: BoxDecoration(
                color: AppColors.softPink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
              ),
              child: Icon(
                icon,
                color: AppColors.mediumPurple,
                size: context.responsive(24),
              ),
            ),
            SizedBox(width: ThemeHelper.spacingM(context)),
            Expanded(
              child: enabled
                  ? TextField(
                      controller: controller,
                      keyboardType: keyboardType,
                      style: AppTextStyles.bodyMedium1(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        labelText: label,
                        labelStyle: AppTextStyles.bodySmall1(context).copyWith(
                          color: AppColors.secondaryText,
                        ),
                        border: InputBorder.none,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: AppTextStyles.bodySmall1(context).copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                        SizedBox(height: ThemeHelper.spacingS(context) / 2),
                        Text(
                          controller.text.isNotEmpty
                              ? controller.text
                              : l10n.notSet,
                          style: AppTextStyles.bodyMedium1(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: controller.text.isEmpty
                                ? AppColors.grey
                                : AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
