import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../contents/assets.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/navigation/app_router.dart';
import '../viewmodels/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _userService = UserService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      
      final success = await authProvider.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
        gender: 'Female', // App is for women only
      );
      
      if (success && mounted) {
        final user = authProvider.currentUser;
        if (user != null) {
          // Update UserService with user data
          _userService.setUserData(
            name: user.name ?? name,
            email: user.email,
            phone: user.phone ?? phone,
            gender: user.gender ?? 'Female',
          );
          
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          }
        }
      } else if (mounted && authProvider.error != null) {
        final errorMessage = authProvider.error!;
        final messenger = ScaffoldMessenger.of(context);
        
        // Show error with appropriate duration and icon
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  errorMessage.toLowerCase().contains('internet') || 
                  errorMessage.toLowerCase().contains('network') ||
                  errorMessage.toLowerCase().contains('connection')
                      ? Icons.wifi_off
                      : Icons.error_outline,
                  color: AppColors.white,
                  size: context.responsive(20),
                ),
                SizedBox(width: context.responsive(12)),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: AppTextStyles.bodyMedium1(context).copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.dangerColor,
            duration: Duration(
              seconds: errorMessage.toLowerCase().contains('internet') || 
                      errorMessage.toLowerCase().contains('network')
                  ? 5
                  : 3
            ),
            action: SnackBarAction(
              label: 'OK',
              textColor: AppColors.white,
              onPressed: () {
                messenger.hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: ThemeHelper.spacingL(context)),
                // Logo
                Image.asset(
                  AppAssets.logo,
                  width: context.responsive(100),
                  height: context.responsive(100),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: context.responsive(80),
                      height: context.responsive(80),
                      decoration: BoxDecoration(
                        color: AppColors.mediumPurple.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: context.responsive(50),
                        color: AppColors.mediumPurple,
                      ),
                    );
                  },
                ),
                SizedBox(height: ThemeHelper.spacingL(context)),
                // Welcome text
                Text(
                  'Create Account',
                  style: AppTextStyles.heading1(context),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ThemeHelper.spacingS(context)),
                Text(
                  'Join our community of empowered women',
                  style: AppTextStyles.bodyMedium1(context).copyWith(
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ThemeHelper.spacingXL(context)),
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'e.g., Sarah Ahmed',
                    helperText: 'Enter your first and last name',
                    prefixIcon: const Icon(Icons.person_outlined),
                    labelStyle: AppTextStyles.label(context),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ThemeHelper.spacingL(context)),
                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'e.g., sarah.ahmed@example.com',
                    helperText: 'Enter a valid email address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelStyle: AppTextStyles.label(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ThemeHelper.spacingL(context)),
                // Phone field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'e.g., 03001234567 or +923001234567',
                    helperText: 'Enter your phone number (with or without country code)',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    labelStyle: AppTextStyles.label(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // Remove spaces, dashes, and plus sign for validation
                    final cleanedPhone = value.replaceAll(RegExp(r'[\s\-+]'), '');
                    if (cleanedPhone.length < 10) {
                      return 'Phone number must be at least 10 digits';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(cleanedPhone)) {
                      return 'Phone number should contain only numbers';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ThemeHelper.spacingL(context)),
                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Minimum 6 characters',
                    helperText: 'Use at least 6 characters (letters, numbers, or symbols)',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    labelStyle: AppTextStyles.label(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ThemeHelper.spacingL(context)),
                // Confirm Password field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    helperText: 'Enter the same password again',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    labelStyle: AppTextStyles.label(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ThemeHelper.spacingL(context)),
                // Divider with "OR"
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.grey.withValues(alpha: 0.3))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ThemeHelper.spacingM(context)),
                      child: Text(
                        'OR',
                        style: AppTextStyles.bodySmall1(context).copyWith(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.grey.withValues(alpha: 0.3))),
                  ],
                ),
                SizedBox(height: ThemeHelper.spacingL(context)),
                // Continue with Google
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Google Sign In coming soon'),
                        backgroundColor: AppColors.mediumPurple,
                      ),
                    );
                  },
                  icon: Icon(Icons.g_mobiledata, size: context.responsive(24)),
                  label: Text(
                    'Continue with Google',
                    style: AppTextStyles.buttonMedium(context).copyWith(
                      color: AppColors.mediumPurple,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.mediumPurple, width: 2),
                    padding: EdgeInsets.symmetric(
                      vertical: ThemeHelper.spacingM(context),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                    ),
                  ),
                ),
                SizedBox(height: ThemeHelper.spacingM(context)),
                // Other Auth Options
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                              onPressed: () {
                          _showAuthOptionDialog('Face Authentication');
                        },
                        icon: Icon(Icons.face, size: context.responsive(20)),
                        label: Text(
                          'Face ID',
                          style: AppTextStyles.bodySmall1(context).copyWith(
                            color: AppColors.mediumPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.mediumPurple.withValues(alpha: 0.5)),
                          padding: EdgeInsets.symmetric(
                            vertical: ThemeHelper.spacingS(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: ThemeHelper.spacingM(context)),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showAuthOptionDialog('CNIC Authentication');
                        },
                        icon: Icon(Icons.badge, size: context.responsive(20)),
                        label: Text(
                          'CNIC',
                          style: AppTextStyles.bodySmall1(context).copyWith(
                            color: AppColors.mediumPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.mediumPurple.withValues(alpha: 0.5)),
                          padding: EdgeInsets.symmetric(
                            vertical: ThemeHelper.spacingS(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ThemeHelper.spacingXL(context)),
                // Sign up button
                ElevatedButton(
                  onPressed: () {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    if (!authProvider.isLoading) {
                      _handleSignup();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mediumPurple,
                    padding: EdgeInsets.symmetric(
                      vertical: ThemeHelper.spacingM(context),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                    ),
                  ),
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return authProvider.isLoading
                          ? SizedBox(
                              height: context.responsive(20),
                              width: context.responsive(20),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.lightText,
                                ),
                              ),
                            )
                            : Text(
                                'Sign Up',
                                style: AppTextStyles.buttonLarge(context),
                              );
                    },
                  ),
                ),
                SizedBox(height: ThemeHelper.spacingL(context)),
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.bodyMedium1(context),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Sign In',
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          color: AppColors.mediumPurple,
                          fontWeight: FontWeight.w600,
                        ),
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

  void _showAuthOptionDialog(String authType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          authType,
          style: AppTextStyles.heading3(context),
        ),
        content: Text(
          '$authType feature will be available soon. Please use the form above to create your account.',
          style: AppTextStyles.bodyMedium1(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: AppTextStyles.bodyMedium1(context).copyWith(
                color: AppColors.mediumPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

