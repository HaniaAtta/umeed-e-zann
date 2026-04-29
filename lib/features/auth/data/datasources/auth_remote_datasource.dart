import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Remote data source for authentication (Firebase)
abstract class AuthRemoteDataSource {
  Future<UserModel?> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
    String? gender,
  });

  Future<UserModel?> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  User? getCurrentUser();

  Stream<User?> get authStateChanges;

  Future<UserModel?> getUserData(String userId);

  Future<void> updateUserData(String userId, Map<String, dynamic> data);

  Future<void> sendPasswordResetEmail(String email);

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<bool> checkEmailExists(String email);

  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
    String? gender,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      final userModel = UserModel(
        id: user.uid,
        email: email,
        name: name,
        phone: phone,
        gender: gender ?? 'Female',
        createdAt: DateTime.now(),
        settings: {},
        trustedContacts: [],
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      // Check for network connectivity issues
      if (errorStr.contains('unable to resolve host') ||
          errorStr.contains('no address associated with hostname') ||
          errorStr.contains('failed to resolve name') ||
          errorStr.contains('network') ||
          errorStr.contains('connection') ||
          errorStr.contains('unavailable') ||
          errorStr.contains('socket')) {
        throw Exception('No internet connection. Please check your network and try again.');
      }
      throw Exception('Failed to sign up: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      return await getUserData(user.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      // Check for network connectivity issues
      if (errorStr.contains('unable to resolve host') ||
          errorStr.contains('no address associated with hostname') ||
          errorStr.contains('failed to resolve name') ||
          errorStr.contains('network') ||
          errorStr.contains('connection') ||
          errorStr.contains('unavailable') ||
          errorStr.contains('socket')) {
        throw Exception('No internet connection. Please check your network and try again.');
      }
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  User? getCurrentUser() => _auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<UserModel?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = Timestamp.fromDate(DateTime.now());
      debugPrint('Updating user data in Firestore for userId: $userId');
      debugPrint('Data to update: $data');
      await _firestore.collection('users').doc(userId).update(data);
      debugPrint('User data updated successfully in Firestore');
    } catch (e) {
      debugPrint('Error updating user data: $e');
      throw Exception('Failed to update user data: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final emailExists = await checkEmailExists(email);

      await _auth.sendPasswordResetEmail(email: email);

      try {
        await _firestore.collection('password_reset_requests').add({
          'email': email,
          'requestedAt': Timestamp.fromDate(DateTime.now()),
          'status': 'email_sent',
          'emailExists': emailExists,
        });
      } catch (logError) {
        debugPrint('Failed to log password reset request: $logError');
      }
    } on FirebaseAuthException catch (e) {
      try {
        await _firestore.collection('password_reset_requests').add({
          'email': email,
          'requestedAt': Timestamp.fromDate(DateTime.now()),
          'status': 'failed',
          'error': e.code,
          'errorMessage': e.message ?? 'Unknown error',
        });
      } catch (logError) {
        debugPrint('Failed to log error: $logError');
      }

      String userMessage = _handleAuthException(e);
      if (e.code == 'user-not-found') {
        userMessage = 'No account found with this email address. Please check your email or sign up.';
      } else if (e.code == 'invalid-email') {
        userMessage = 'Invalid email address. Please enter a valid email.';
      } else if (e.code == 'too-many-requests') {
        userMessage = 'Too many password reset requests. Please wait a few minutes and try again.';
      }

      throw Exception(userMessage);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to send password reset email: $e');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      // Check if email exists in Firestore
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        throw Exception('No account found with this email address. Please check your email or sign up.');
      }

      final userId = userSnapshot.docs.first.id;

      // Note: Firebase Auth doesn't allow direct password update without authentication
      // We skip the deprecated fetchSignInMethodsForEmail check for security reasons
      // sendPasswordResetEmail will handle non-existent emails gracefully
      // For security, we need to either:
      // 1. Use sendPasswordResetEmail (requires email link)
      // 2. Use Firebase Admin SDK on backend
      // 3. Require user to be signed in
      
      // Since we're client-side, we'll:
      // 1. Store password reset request in Firestore
      // 2. Send password reset email (Firebase requirement)
      // 3. User will need to click the link in email to complete reset
      
      // Store password reset request
      await _firestore.collection('password_reset_requests').add({
        'email': email,
        'userId': userId,
        'requestedAt': Timestamp.fromDate(DateTime.now()),
        'status': 'pending',
        'method': 'direct_reset',
      });

      // Send password reset email (Firebase security requirement)
      await _auth.sendPasswordResetEmail(email: email);

      // Update user document with reset request flag
      await _firestore.collection('users').doc(userId).update({
        'passwordResetRequested': true,
        'passwordResetRequestedAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

    } on FirebaseAuthException catch (e) {
      String userMessage = _handleAuthException(e);
      if (e.code == 'user-not-found') {
        userMessage = 'No account found with this email address. Please check your email or sign up.';
      } else if (e.code == 'invalid-email') {
        userMessage = 'Invalid email address. Please enter a valid email.';
      } else if (e.code == 'too-many-requests') {
        userMessage = 'Too many password reset requests. Please wait a few minutes and try again.';
      }
      throw Exception(userMessage);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to reset password: $e');
    }
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check email: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    // Check for network errors in exception message first
    final errorMessage = e.message?.toLowerCase() ?? '';
    if (errorMessage.contains('network error') ||
        errorMessage.contains('unable to resolve host') ||
        errorMessage.contains('no address associated with hostname') ||
        errorMessage.contains('failed to resolve name') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('interrupted connection') ||
        errorMessage.contains('unreachable host') ||
        errorMessage.contains('connection')) {
      return 'No internet connection. Please check your network and try again.';
    }

    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network and try again.';
      default:
        // Check if it's a network error in the default case too
        if (errorMessage.contains('network') || errorMessage.contains('connection')) {
          return 'No internet connection. Please check your network and try again.';
        }
        return 'An error occurred: ${e.message}';
    }
  }
}

