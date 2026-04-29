import '../repositories/safety_repository.dart';

/// Use case to start live tracking
class StartLiveTracking {
  final SafetyRepository repository;

  StartLiveTracking(this.repository);

  Future<String> execute({
    required String userId,
    required List<String> viewerIds,
  }) async {
    return await repository.startLiveTracking(
      userId: userId,
      viewerIds: viewerIds,
    );
  }
}

