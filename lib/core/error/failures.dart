/// Base class for all failures in the application
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => message;
}

/// Server failure - errors from API/Firebase
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Cache failure - errors from local storage
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Network failure - no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

