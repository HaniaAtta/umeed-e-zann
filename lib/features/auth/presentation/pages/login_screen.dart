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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userService = UserService();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      
      final success = await authProvider.signIn(email, password);
      
      if (success && mounted) {
        final user = authProvider.currentUser;
        if (user != null) {
          // Update UserService with user data
          _userService.setUserData(
            name: user.name ?? 'User',
            email: user.email,
            phone: user.phone ?? '',
            gender: user.gender ?? 'Female',
          );
          
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          }
        }
      } else if (mounted && authProvider.error != null) {
        final errorMessage = authProvider.error!;
        final messenger = ScaffoldMessenger.of(context);
        
        // Show error with appropriate duration
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

  Future<void> _handleForgotPassword() async {
    try {
      if (!mounted) return;
      
      // Show dialog to enter email, new password, and confirm password
      final emailController = TextEditingController();
      final newPasswordController = TextEditingController();
      final confirmPasswordController = TextEditingController();
      final formKey = GlobalKey<FormState>();
      
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => StatefulBuilder(
          builder: (dialogContext, setDialogState) => AlertDialog(
            title: Text(
              'Reset Password',
              style: AppTextStyles.heading3(dialogContext),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your email and new password to reset your password.',
                        style: AppTextStyles.bodyMedium1(dialogContext),
                      ),
                      SizedBox(height: ThemeHelper.spacingL(dialogContext)),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelStyle: AppTextStyles.label(dialogContext),
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
                      SizedBox(height: ThemeHelper.spacingM(dialogContext)),
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          labelStyle: AppTextStyles.label(dialogContext),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter new password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: ThemeHelper.spacingM(dialogContext)),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          labelStyle: AppTextStyles.label(dialogContext),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  'Cancel',
                  style: AppTextStyles.bodyMedium1(dialogContext).copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(dialogContext, true);
                  }
                },
                child: Text(
                  'Reset Password',
                  style: AppTextStyles.bodyMedium1(dialogContext).copyWith(
                    color: AppColors.mediumPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      if (result != true) return;

      final email = emailController.text.trim();
      final newPassword = newPasswordController.text.trim();
      
      emailController.dispose();
      newPasswordController.dispose();
      confirmPasswordController.dispose();

      if (!mounted) return;

      // Reset password via provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.resetPassword(
        email: email,
        newPassword: newPassword,
      );
      
      if (!mounted) return;
      
      if (success) {
        // Show success message
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
            title: Text(
              'Password Reset Request Sent',
              style: AppTextStyles.heading3(context),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password reset request has been sent to:',
                  style: AppTextStyles.bodyMedium1(context),
                ),
                SizedBox(height: ThemeHelper.spacingS(context)),
                Text(
                  email,
                  style: AppTextStyles.bodyMedium1(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.mediumPurple,
                  ),
                ),
                SizedBox(height: ThemeHelper.spacingM(context)),
                Text(
                  'Please check your email and click the link to complete the password reset.',
                  style: AppTextStyles.bodyMedium1(context).copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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
      } else if (authProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error!),
            backgroundColor: AppColors.dangerColor,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      String errorMessage = 'Failed to reset password.';
      final errorStr = e.toString().toLowerCase();
      
      if (errorStr.contains('user-not-found') || errorStr.contains('no account')) {
        errorMessage = 'No account found with this email address. Please check your email or sign up.';
      } else if (errorStr.contains('invalid-email')) {
        errorMessage = 'Invalid email address. Please enter a valid email.';
      } else if (errorStr.contains('network') || errorStr.contains('connection')) {
        errorMessage = 'Network error. Please check your internet connection and try again.';
      } else if (errorStr.contains('too-many-requests')) {
        errorMessage = 'Too many requests. Please wait a few minutes before trying again.';
      } else {
        if (e.toString().contains('Exception: ')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '').trim();
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.dangerColor,
          duration: const Duration(seconds: 4),
        ),
      );
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
                  'Welcome Back',
                  style: AppTextStyles.heading1(context),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ThemeHelper.spacingS(context)),
                Text(
                  'Sign in to continue your journey',
                  style: AppTextStyles.bodyMedium1(context).copyWith(
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ThemeHelper.spacingXL(context)),
                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'e.g., sarah.ahmed@example.com',
                    helperText: 'Enter your registered email address',
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
                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    helperText: 'Enter your account password',
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
                    return null;
                  },
                ),
                SizedBox(height: ThemeHelper.spacingS(context)),
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.bodyMedium1(context).copyWith(
                        color: AppColors.mediumPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
                // Sign in button
                ElevatedButton(
                  onPressed: () {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    if (!authProvider.isLoading) {
                      _handleSignIn();
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
                              'Sign In',
                              style: AppTextStyles.buttonLarge(context),
                            );
                    },
                  ),
                ),
                SizedBox(height: ThemeHelper.spacingL(context)),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: AppTextStyles.bodyMedium1(context),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRouter.signup);
                      },
                      child: Text(
                        'Sign Up',
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
          '$authType feature will be available soon. Please use the form above to sign in.',
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
