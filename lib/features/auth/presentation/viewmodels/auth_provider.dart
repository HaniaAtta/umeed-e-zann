import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/send_password_reset.dart';
import '../../domain/usecases/reset_password.dart';

/// Provider for authentication state management
class AuthProvider with ChangeNotifier {
  final AuthRepository repository;

  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Use cases (initialized in constructor)
  late final SignIn _signIn;
  late final SignUp _signUp;
  late final SignOut _signOut;
  late final GetCurrentUser _getCurrentUser;
  late final SendPasswordReset _sendPasswordReset;
  late final ResetPassword _resetPassword;

  AuthProvider({required this.repository}) {
    _signIn = SignIn(repository);
    _signUp = SignUp(repository);
    _signOut = SignOut(repository);
    _getCurrentUser = GetCurrentUser(repository);
    _sendPasswordReset = SendPasswordReset(repository);
    _resetPassword = ResetPassword(repository);
  }

  // Getters
  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  /// Sign in user
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      final user = await _signIn.execute(email: email, password: password);
      if (user != null) {
        _currentUser = user;
        _setLoading(false);
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      
      // Improve network error messages
      final errorStr = errorMessage.toLowerCase();
      if (errorStr.contains('no internet') || 
          errorStr.contains('network') || 
          errorStr.contains('connection')) {
        errorMessage = 'No internet connection. Please check your network and try again.';
      } else if (errorStr.contains('unable to resolve') || 
                 errorStr.contains('failed to resolve')) {
        errorMessage = 'Cannot connect to server. Please check your internet connection.';
      }
      
      _error = errorMessage;
      _setLoading(false);
      return false;
    }
  }

  /// Sign up user
  Future<bool> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
    String? gender,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final user = await _signUp.execute(
        email: email,
        password: password,
        name: name,
        phone: phone,
        gender: gender,
      );
      if (user != null) {
        _currentUser = user;
        _setLoading(false);
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      
      // Improve network error messages
      final errorStr = errorMessage.toLowerCase();
      if (errorStr.contains('no internet') || 
          errorStr.contains('network') || 
          errorStr.contains('connection')) {
        errorMessage = 'No internet connection. Please check your network and try again.';
      } else if (errorStr.contains('unable to resolve') || 
                 errorStr.contains('failed to resolve') ||
                 errorStr.contains('timeout') ||
                 errorStr.contains('unreachable host')) {
        errorMessage = 'Cannot connect to server. Please check your internet connection.';
      }
      
      _error = errorMessage;
      _setLoading(false);
      return false;
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    _setLoading(true);
    _error = null;

    try {
      await _signOut.execute();
      _currentUser = null;
      _setLoading(false);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
    }
  }

  /// Get current user
  Future<void> getCurrentUser() async {
    _setLoading(true);
    _error = null;

    try {
      final user = await _getCurrentUser.execute();
      _currentUser = user;
      _setLoading(false);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _error = null;

    try {
      await _sendPasswordReset.execute(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  /// Reset password directly (forgot password flow)
  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      await _resetPassword.execute(
        email: email,
        newPassword: newPassword,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Update user data
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    _setLoading(true);
    _error = null;

    try {
      await repository.updateUserData(userId, data);
      await getCurrentUser(); // Refresh current user
      _setLoading(false);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    _setLoading(true);
    _error = null;

    try {
      await repository.deleteAccount();
      _currentUser = null;
      _setLoading(false);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

