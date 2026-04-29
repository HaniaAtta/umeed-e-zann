import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<AppUser?> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
    String? gender,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      // Create user document in Firestore
      final appUser = AppUser(
        id: user.uid,
        email: email,
        name: name,
        phone: phone,
        gender: gender ?? 'Female',
        createdAt: DateTime.now(),
        settings: {},
        trustedContacts: [],
      );

      await _firestore.collection('users').doc(user.uid).set(appUser.toJson());

      return appUser;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  // Sign in with email and password
  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      // Get user data from Firestore
      return await getUserData(user.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // Get user data from Firestore
  Future<AppUser?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      return AppUser.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Get current user data
  Future<AppUser?> getCurrentUserData() async {
    final user = currentUser;
    if (user == null) return null;
    return getUserData(user.uid);
  }

  // Update user data
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

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // First, check if email exists in Firestore
      final emailExists = await checkEmailExists(email);
      
      if (!emailExists) {
        // Check if user exists in Firebase Auth (for users created before Firestore sync)
        // Note: We can't directly check Firebase Auth, but we'll try to send anyway
        // Firebase will return an error if email doesn't exist
      }
      
      // Send password reset email via Firebase Auth
      // Add actionCodeSettings for better email handling (optional)
      await _auth.sendPasswordResetEmail(
        email: email,
        // Optional: Configure action code settings for custom email handling
        // actionCodeSettings: ActionCodeSettings(
        //   url: 'https://your-app.com/reset-password',
        //   handleCodeInApp: false,
        // ),
      );
      
      // Log password reset request to Firestore (for tracking)
      try {
        await _firestore.collection('password_reset_requests').add({
          'email': email,
          'requestedAt': Timestamp.fromDate(DateTime.now()),
          'status': 'email_sent',
          'emailExists': emailExists,
          'note': 'Email sent via Firebase Auth. Check spam folder if not received.'
        });
      } catch (logError) {
        // Don't fail the reset if logging fails
        debugPrint('Failed to log password reset request: $logError');
      }
    } on FirebaseAuthException catch (e) {
      // Log failed attempt with detailed error
      try {
        await _firestore.collection('password_reset_requests').add({
          'email': email,
          'requestedAt': Timestamp.fromDate(DateTime.now()),
          'status': 'failed',
          'error': e.code,
          'errorMessage': e.message ?? 'Unknown error',
          'fullError': e.toString(),
        });
      } catch (logError) {
        // Ignore logging errors
        debugPrint('Failed to log error: $logError');
      }
      
      // Provide more specific error messages
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
      // Log failed attempt
      try {
        await _firestore.collection('password_reset_requests').add({
          'email': email,
          'requestedAt': Timestamp.fromDate(DateTime.now()),
          'status': 'failed',
          'error': 'unknown',
          'errorMessage': e.toString(),
        });
      } catch (logError) {
        // Ignore logging errors
        debugPrint('Failed to log error: $logError');
      }
      
      // Re-throw with better message
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to send password reset email: $e');
    }
  }

  // Check if email exists in database
  Future<bool> checkEmailExists(String email) async {
    try {
      // Check if email exists in Firestore users collection
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      }
      
      // Also check Firebase Auth (try to fetch user by email)
      // Note: Firebase Auth doesn't have a direct "check email exists" method
      // So we rely on Firestore check above
      return false;
    } catch (e) {
      throw Exception('Failed to check email: $e');
    }
  }

  // Reset password (requires email verification and new password)
  // Note: This is a simplified flow - in production, you'd want additional security
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      // Verify email exists
      final emailExists = await checkEmailExists(email);
      if (!emailExists) {
        throw Exception('No account found with this email address.');
      }

      // Send password reset email which will allow user to set new password
      // Note: Firebase requires email link verification for security
      // Direct password update without authentication is not supported for security reasons
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (e.toString().contains('No account found')) {
        rethrow;
      }
      throw Exception('Failed to reset password: $e');
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user logged in');

      // Delete user data from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete user from Firebase Auth
      await user.delete();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
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
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}

