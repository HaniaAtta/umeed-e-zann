import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user sign in
class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<UserEntity?> execute({
    required String email,
    required String password,
  }) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Validate password not empty
    if (password.isEmpty) {
      throw Exception('Password cannot be empty');
    }

    return await repository.signIn(
      email: email,
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

