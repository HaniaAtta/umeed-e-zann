import '../repositories/auth_repository.dart';

/// Use case for user sign out
class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<void> execute() async {
    return await repository.signOut();
  }
}

