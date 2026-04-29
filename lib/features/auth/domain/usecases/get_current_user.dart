import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case to get current user
class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<UserEntity?> execute() async {
    return await repository.getCurrentUserData();
  }
}

