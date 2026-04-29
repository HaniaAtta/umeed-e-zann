# Storage Services Guide

## ✅ Completed Setup

### 1. Shared Preferences Service ✓
**Location**: `lib/core/services/shared_preferences_service.dart`

**Use for**: Non-sensitive data (theme, language, settings, login status)

**Usage**:
```dart
import 'package:umeed_e_zann/core/services/shared_preferences_service.dart';

// Save data
await SharedPreferencesService.setString('username', 'John');
await SharedPreferencesService.setInt('age', 25);
await SharedPreferencesService.setBool('isLoggedIn', true);

// Read data
String? username = await SharedPreferencesService.getString('username');
int? age = await SharedPreferencesService.getInt('age');
bool? isLoggedIn = await SharedPreferencesService.getBool('isLoggedIn');

// Remove data
await SharedPreferencesService.remove('username');

// Clear all
await SharedPreferencesService.clear();
```

### 2. Secure Storage Service ✓
**Location**: `lib/core/services/secure_storage_service.dart`

**Use for**: Sensitive data (tokens, passwords, API keys, session IDs)

**Usage**:
```dart
import 'package:umeed_e_zann/core/services/secure_storage_service.dart';

// Save token
await SecureStorageService.write('auth_token', 'abc123token');

// Read token
String? token = await SecureStorageService.read('auth_token');

// Delete token
await SecureStorageService.delete('auth_token');

// Clear all secure storage
await SecureStorageService.deleteAll();
```

## 🔐 Best Practice: Using Both Together

```dart
import 'package:umeed_e_zann/core/services/shared_preferences_service.dart';
import 'package:umeed_e_zann/core/services/secure_storage_service.dart';

// Example: Login flow
Future<void> login(String email, String password) async {
  // Authenticate user...
  final token = 'user_auth_token_123';
  
  // Save token securely
  await SecureStorageService.write('auth_token', token);
  
  // Save login state (non-sensitive)
  await SharedPreferencesService.setBool('isLoggedIn', true);
  await SharedPreferencesService.setString('userEmail', email);
}

// Example: Check login state (like in splash screen)
Future<bool> checkLoginState() async {
  final token = await SecureStorageService.read('auth_token');
  final isLoggedIn = await SharedPreferencesService.getBool('isLoggedIn') ?? false;
  
  return token != null && isLoggedIn;
}

// Example: Logout
Future<void> logout() async {
  // Clear secure storage
  await SecureStorageService.deleteAll();
  
  // Clear shared preferences
  await SharedPreferencesService.clear();
}
```

## 📝 Example: Splash Screen Implementation

```dart
import 'package:flutter/material.dart';
import 'package:umeed_e_zann/core/services/shared_preferences_service.dart';
import 'package:umeed_e_zann/core/services/secure_storage_service.dart';
import 'package:umeed_e_zann/core/navigation/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Check if user is logged in
    final token = await SecureStorageService.read('auth_token');
    final isLoggedIn = await SharedPreferencesService.getBool('isLoggedIn') ?? false;
    
    if (token != null && isLoggedIn) {
      // User is logged in, go to home
      Navigator.of(context).pushReplacementNamed(AppRouter.home);
    } else {
      // User is not logged in, go to login
      Navigator.of(context).pushReplacementNamed(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
```

## 🔑 Key Differences

| Feature | Shared Preferences | Secure Storage |
|---------|-------------------|----------------|
| **Security** | ❌ Plain text | ✅ Encrypted |
| **Speed** | ✅ Fast | ⚠️ Slightly slower |
| **Use For** | Settings, theme, language | Tokens, passwords, API keys |
| **Data Types** | String, Int, Bool, Double, List | String only |

## ✅ Summary

- ✅ `SharedPreferencesService` - For non-sensitive data
- ✅ `SecureStorageService` - For sensitive data
- ✅ Both services initialized in `main.dart`
- ✅ Ready to use throughout the app

**Recommendation**: Always use SecureStorage for authentication tokens and sensitive data!

