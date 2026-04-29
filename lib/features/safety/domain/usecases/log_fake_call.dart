import '../entities/fake_call_entity.dart';
import '../repositories/safety_repository.dart';

/// Use case to log fake call
class LogFakeCall {
  final SafetyRepository repository;

  LogFakeCall(this.repository);

  Future<void> execute(FakeCallEntity fakeCall) async {
    return await repository.logFakeCall(fakeCall);
  }
}

