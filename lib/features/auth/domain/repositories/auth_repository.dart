import '../entities/user.dart';

/// Abstract repository interface for authentication operations
abstract class AuthRepository {
  /// Sign up with email and password
  Future<UserEntity?> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
    String? gender,
  });

  /// Sign in with email and password
  Future<UserEntity?> signIn({
    required String email,
    required String password,
  });

  /// Sign out
  Future<void> signOut();

  /// Get current user
  UserEntity? getCurrentUser();

  /// Get auth state changes stream
  Stream<UserEntity?> get authStateChanges;

  /// Get user data by ID
  Future<UserEntity?> getUserData(String userId);

  /// Get current user data
  Future<UserEntity?> getCurrentUserData();

  /// Update user data
  Future<void> updateUserData(String userId, Map<String, dynamic> data);

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Reset password directly (forgot password flow)
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  /// Check if email exists
  Future<bool> checkEmailExists(String email);

  /// Delete user account
  Future<void> deleteAccount();
}

