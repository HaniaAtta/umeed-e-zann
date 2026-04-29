import '../entities/fake_call_entity.dart';
import '../repositories/safety_repository.dart';

/// Use case to get fake call history stream
class GetFakeCallHistory {
  final SafetyRepository repository;

  GetFakeCallHistory(this.repository);

  Stream<List<FakeCallEntity>> execute(String userId) {
    return repository.getFakeCallHistory(userId);
  }
}

