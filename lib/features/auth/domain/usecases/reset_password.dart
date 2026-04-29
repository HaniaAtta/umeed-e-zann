import '../repositories/auth_repository.dart';

/// Use case to reset password
class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<void> execute({
    required String email,
    required String newPassword,
  }) async {
    return await repository.resetPassword(
      email: email,
      newPassword: newPassword,
    );
  }
}

