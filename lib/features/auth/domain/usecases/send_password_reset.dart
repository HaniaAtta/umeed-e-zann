import '../repositories/auth_repository.dart';

/// Use case to send password reset email
class SendPasswordReset {
  final AuthRepository repository;

  SendPasswordReset(this.repository);

  Future<void> execute(String email) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    return await repository.sendPasswordResetEmail(email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

