import 'package:flutter/foundation.dart';
import '../../data/services/auth_service.dart';

/// Service to manage user data throughout the app
class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final AuthService _authService = AuthService();

  String _userName = 'User';
  String _userEmail = '';
  String _userPhone = '';
  String _userGender = '';
  DateTime? _userDateOfBirth;
  String _userLocation = '';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userGender => _userGender;
  DateTime? get userDateOfBirth => _userDateOfBirth;
  String get userLocation => _userLocation;

  /// Update user name
  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  /// Update user email
  void updateUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }

  /// Update user phone
  void updateUserPhone(String phone) {
    _userPhone = phone;
    notifyListeners();
  }

  /// Update user gender
  void updateUserGender(String gender) {
    _userGender = gender;
    notifyListeners();
  }

  /// Update user date of birth
  void updateUserDateOfBirth(DateTime? dateOfBirth) {
    _userDateOfBirth = dateOfBirth;
    notifyListeners();
  }

  /// Update user location
  void updateUserLocation(String location) {
    _userLocation = location;
    notifyListeners();
  }

  /// Set user data from signup
  void setUserData({
    required String name,
    required String email,
    required String phone,
    required String gender,
    DateTime? dateOfBirth,
    String? location,
  }) {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    _userGender = gender;
    _userDateOfBirth = dateOfBirth;
    _userLocation = location ?? '';
    notifyListeners();
  }

  /// Load user data from Firebase
  Future<void> loadUserData() async {
    try {
      final user = await _authService.getCurrentUserData();
      if (user != null) {
        _userName = user.name ?? 'User';
        _userEmail = user.email;
        _userPhone = user.phone ?? '';
        _userGender = user.gender ?? '';
        _userDateOfBirth = user.dateOfBirth;
        _userLocation = user.location ?? '';
        notifyListeners();
      }
    } catch (e) {
      // Handle error silently or log it
      debugPrint('Failed to load user data: $e');
    }
  }

  /// Save user data to Firebase
  Future<void> saveUserData() async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      final updateData = <String, dynamic>{
        'name': _userName,
        'phone': _userPhone,
        'gender': _userGender,
        'dateOfBirth': _userDateOfBirth?.toIso8601String(),
        'location': _userLocation,
      };

      // Only update email if it's different and not empty
      // Note: Changing email in Firestore doesn't change Firebase Auth email
      // For security, email changes should go through Firebase Auth email verification
      if (_userEmail.isNotEmpty) {
        updateData['email'] = _userEmail;
      }

      await _authService.updateUserData(userId, updateData);
      debugPrint('User data saved to Firebase successfully');
    } catch (e) {
      debugPrint('Failed to save user data: $e');
      rethrow;
    }
  }

  /// Clear user data (for logout)
  void clearUserData() {
    _userName = 'User';
    _userEmail = '';
    _userPhone = '';
    _userGender = '';
    _userDateOfBirth = null;
    _userLocation = '';
    notifyListeners();
  }
}
