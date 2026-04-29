import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user sign up
class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<UserEntity?> execute({
    required String email,
    required String password,
    String? name,
    String? phone,
    String? gender,
  }) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Validate password strength
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    return await repository.signUp(
      email: email,
      password: password,
      name: name,
      phone: phone,
      gender: gender,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

