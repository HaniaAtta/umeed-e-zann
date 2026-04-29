import '../repositories/safety_repository.dart';

/// Use case to stop live tracking
class StopLiveTracking {
  final SafetyRepository repository;

  StopLiveTracking(this.repository);

  Future<void> execute(String trackingId) async {
    return await repository.stopLiveTracking(trackingId);
  }
}

