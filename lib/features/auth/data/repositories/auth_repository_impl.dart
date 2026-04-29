import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Repository implementation for authentication
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity?> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
    String? gender,
  }) async {
    try {
      final userModel = await remoteDataSource.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
        gender: gender,
      );
      return userModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<UserEntity?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return userModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  UserEntity? getCurrentUser() {
    final firebaseUser = remoteDataSource.getCurrentUser();
    if (firebaseUser == null) return null;
    // Return a minimal user entity from Firebase user
    // Full user data should be fetched via getCurrentUserData
    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      createdAt: DateTime.now(),
    );
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        final userModel = await remoteDataSource.getUserData(firebaseUser.uid);
        return userModel?.toEntity();
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Future<UserEntity?> getUserData(String userId) async {
    try {
      final userModel = await remoteDataSource.getUserData(userId);
      return userModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  @override
  Future<UserEntity?> getCurrentUserData() async {
    try {
      final firebaseUser = remoteDataSource.getCurrentUser();
      if (firebaseUser == null) return null;
      return await getUserData(firebaseUser.uid);
    } catch (e) {
      throw Exception('Failed to get current user data: $e');
    }
  }

  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await remoteDataSource.updateUserData(userId, data);
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        email: email,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    try {
      return await remoteDataSource.checkEmailExists(email);
    } catch (e) {
      throw Exception('Failed to check email: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}

