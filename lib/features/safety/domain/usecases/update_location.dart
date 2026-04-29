import '../entities/sos_alert_entity.dart';
import '../repositories/safety_repository.dart';

/// Use case to update live tracking location
class UpdateLocation {
  final SafetyRepository repository;

  UpdateLocation(this.repository);

  Future<void> execute({
    required String trackingId,
    required LocationEntity location,
  }) async {
    return await repository.updateLiveTrackingLocation(
      trackingId: trackingId,
      location: location,
    );
  }
}

