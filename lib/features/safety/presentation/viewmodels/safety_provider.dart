import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/navigation/app_router.dart';
import '../../domain/repositories/safety_repository.dart';
import '../../data/repositories/safety_repository_impl.dart';
import '../../data/datasources/safety_remote_datasource.dart';
import '../../domain/usecases/create_sos_alert.dart';
import '../../domain/usecases/get_sos_alerts.dart';
import '../../domain/usecases/update_sos_alert_status.dart';
import '../../domain/usecases/add_trusted_contact.dart';
import '../../domain/usecases/remove_trusted_contact.dart';
import '../../domain/usecases/get_trusted_contacts.dart';
import '../../domain/usecases/start_live_tracking.dart';
import '../../domain/usecases/update_location.dart';
import '../../domain/usecases/stop_live_tracking.dart';
import '../../domain/usecases/save_shake_alert_settings.dart';
import '../../domain/usecases/get_shake_alert_settings.dart';
import '../../domain/usecases/log_fake_call.dart';
import '../../domain/usecases/get_fake_call_history.dart';
import '../../domain/entities/sos_alert_entity.dart';
import '../../domain/entities/trusted_contact_entity.dart';
import '../../domain/entities/live_tracking_entity.dart';
import '../../domain/entities/shake_alert_settings_entity.dart';
import '../../domain/entities/fake_call_entity.dart';

/// Provider for Safety module (SOS alerts, fake calls, live tracking)
class SafetyProvider with ChangeNotifier {
  final SafetyRepository _repository;
  
  // Use cases
  late final CreateSosAlert _createSosAlert;
  late final GetSosAlerts _getSosAlerts;
  late final UpdateSosAlertStatus _updateSosAlertStatus;
  late final AddTrustedContact _addTrustedContact;
  late final RemoveTrustedContact _removeTrustedContact;
  late final GetTrustedContacts _getTrustedContacts;
  late final StartLiveTracking _startLiveTracking;
  late final UpdateLocation _updateLocation;
  late final StopLiveTracking _stopLiveTracking;
  late final SaveShakeAlertSettings _saveShakeAlertSettings;
  late final GetShakeAlertSettings _getShakeAlertSettings;
  late final LogFakeCall _logFakeCall;
  late final GetFakeCallHistory _getFakeCallHistory;

  List<SosAlertEntity> _sosAlerts = [];
  List<TrustedContactEntity> _trustedContacts = [];
  List<FakeCallEntity> _fakeCallHistory = [];
  LiveTrackingEntity? _currentLiveTracking;
  ShakeAlertSettingsEntity? _shakeAlertSettings;
  bool _isLoading = false;
  String? _error;

  // Stream subscriptions
  StreamSubscription<List<SosAlertEntity>>? _sosAlertsSubscription;
  StreamSubscription<List<TrustedContactEntity>>? _trustedContactsSubscription;
  StreamSubscription<List<FakeCallEntity>>? _fakeCallHistorySubscription;
  StreamSubscription<QuerySnapshot>? _incomingSosSubscription;
  String? _lastNotifiedAlertId;

  List<SosAlertEntity> get sosAlerts => _sosAlerts;
  List<TrustedContactEntity> get trustedContacts => _trustedContacts;
  List<FakeCallEntity> get fakeCallHistory => _fakeCallHistory;
  LiveTrackingEntity? get currentLiveTracking => _currentLiveTracking;
  ShakeAlertSettingsEntity? get shakeAlertSettings => _shakeAlertSettings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  SafetyProvider()
      : _repository = SafetyRepositoryImpl(
          remoteDataSource: SafetyRemoteDataSourceImpl(),
        ) {
    _initializeUseCases();
  }

  void _initializeUseCases() {
    _createSosAlert = CreateSosAlert(_repository);
    _getSosAlerts = GetSosAlerts(_repository);
    _updateSosAlertStatus = UpdateSosAlertStatus(_repository);
    _addTrustedContact = AddTrustedContact(_repository);
    _removeTrustedContact = RemoveTrustedContact(_repository);
    _getTrustedContacts = GetTrustedContacts(_repository);
    _startLiveTracking = StartLiveTracking(_repository);
    _updateLocation = UpdateLocation(_repository);
    _stopLiveTracking = StopLiveTracking(_repository);
    _saveShakeAlertSettings = SaveShakeAlertSettings(_repository);
    _getShakeAlertSettings = GetShakeAlertSettings(_repository);
    _logFakeCall = LogFakeCall(_repository);
    _getFakeCallHistory = GetFakeCallHistory(_repository);
  }

  @override
  void dispose() {
    _sosAlertsSubscription?.cancel();
    _trustedContactsSubscription?.cancel();
    _fakeCallHistorySubscription?.cancel();
    _incomingSosSubscription?.cancel();
    super.dispose();
  }

  /// Initialize - load all streams
  Future<void> initialize() async {
    if (_userId == null) return;
    
    _setLoading(true);
    _error = null;

    try {
      // Load SOS alerts stream
      _sosAlertsSubscription = _getSosAlerts.execute(_userId!).listen((alerts) {
        _sosAlerts = alerts;
        notifyListeners();
      });

      // Load trusted contacts stream
      _trustedContactsSubscription = _getTrustedContacts.execute(_userId!).listen((contacts) {
        _trustedContacts = contacts;
        notifyListeners();
      });

      // Load fake call history stream
      _fakeCallHistorySubscription = _getFakeCallHistory.execute(_userId!).listen((history) {
        _fakeCallHistory = history;
        notifyListeners();
      });

      // Load shake alert settings
      await loadShakeAlertSettings();

      // Listen for incoming SOS notifications
      _listenForIncomingSos();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Create SOS alert
  Future<String?> createSosAlert({
    required LocationEntity location,
    String? audioUrl,
    String? message,
  }) async {
    if (_userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return null;
    }

    _setLoading(true);
    _error = null;

    try {
      final alertId = await _createSosAlert.execute(
        userId: _userId!,
        location: location,
        audioUrl: audioUrl,
        message: message,
      );
      return alertId;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Load SOS alerts (already loaded via stream, but can be called to refresh)
  Future<void> loadSosAlerts() async {
    if (_userId == null) return;
    // Already handled by stream in initialize()
  }

  /// Update SOS alert status
  Future<void> updateSosAlertStatus(String alertId, String status) async {
    _setLoading(true);
    _error = null;

    try {
      await _updateSosAlertStatus.execute(
        alertId: alertId,
        status: status,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Add trusted contact
  Future<void> addTrustedContact({
    required String name,
    required String phone,
    String? email,
    String? relation,
  }) async {
    if (_userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _error = null;

    try {
      // Sanitize phone number for contactId
      final contactId = phone.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (contactId.isEmpty) {
        throw Exception('Invalid phone number format');
      }

      final contact = TrustedContactEntity(
        id: '${_userId!}_$contactId',
        userId: _userId!,
        contactId: contactId,
        name: name.trim(),
        phone: phone.trim(),
        email: email?.trim(),
        relation: relation?.trim(),
        isActive: true,
        addedAt: DateTime.now(),
      );

      await _addTrustedContact.execute(contact);
    } catch (e) {
      _error = 'Failed to add contact: ${e.toString()}';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Remove trusted contact
  Future<void> removeTrustedContact(String phone) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      final contactId = phone.replaceAll(RegExp(r'[^0-9]'), '');
      await _removeTrustedContact.execute(
        userId: _userId!,
        contactId: contactId,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load trusted contacts (already loaded via stream)
  Future<void> loadTrustedContacts() async {
    if (_userId == null) return;
    // Already handled by stream in initialize()
  }

  /// Start live tracking
  Future<String?> startLiveTracking(List<String> viewerIds) async {
    if (_userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return null;
    }

    _setLoading(true);
    _error = null;

    try {
      final trackingId = await _startLiveTracking.execute(
        userId: _userId!,
        viewerIds: viewerIds,
      );
      return trackingId;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Update live tracking location
  Future<void> updateLiveTrackingLocation(
    String trackingId,
    LocationEntity location,
  ) async {
    _setLoading(true);
    _error = null;

    try {
      await _updateLocation.execute(
        trackingId: trackingId,
        location: location,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Get live tracking stream
  Stream<LiveTrackingEntity?> getLiveTrackingStream(String trackingId) {
    return _repository.getLiveTracking(trackingId);
  }

  /// Stop live tracking
  Future<void> stopLiveTracking(String trackingId) async {
    _setLoading(true);
    _error = null;

    try {
      await _stopLiveTracking.execute(trackingId);
      _currentLiveTracking = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load shake alert settings
  Future<void> loadShakeAlertSettings() async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      _shakeAlertSettings = await _getShakeAlertSettings.execute(_userId!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Save shake alert settings
  Future<void> saveShakeAlertSettings({
    required bool enabled,
    required int sensitivity,
  }) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      final settings = ShakeAlertSettingsEntity(
        userId: _userId!,
        enabled: enabled,
        sensitivity: sensitivity,
        lastTriggered: enabled ? DateTime.now() : null,
      );

      await _saveShakeAlertSettings.execute(settings);
      _shakeAlertSettings = settings;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Log fake call
  Future<void> logFakeCall({
    String? contactName,
    String? contactNumber,
    DateTime? scheduledTime,
    int duration = 0,
  }) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      final fakeCall = FakeCallEntity(
        id: '', // Will be generated by Firebase
        userId: _userId!,
        contactName: contactName,
        contactNumber: contactNumber,
        scheduledTime: scheduledTime ?? DateTime.now(),
        createdAt: DateTime.now(),
        duration: duration,
      );

      await _logFakeCall.execute(fakeCall);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load fake call history (already loaded via stream)
  Future<void> loadFakeCallHistory() async {
    if (_userId == null) return;
    // Already handled by stream in initialize()
  }

  /// Helper method to convert entities to maps (for backward compatibility)
  List<Map<String, dynamic>> get sosAlertsAsMap {
    return _sosAlerts.map((alert) {
      return {
        'id': alert.id,
        'userId': alert.userId,
        'location': {
          'lat': alert.location.lat,
          'lng': alert.location.lng,
          'accuracy': alert.location.accuracy,
          'timestamp': alert.location.timestamp.toIso8601String(),
        },
        'audioUrl': alert.audioUrl,
        'message': alert.message,
        'status': alert.status,
        'responded': alert.responded,
        'createdAt': alert.createdAt.toIso8601String(),
        'updatedAt': alert.updatedAt?.toIso8601String(),
      };
    }).toList();
  }

  List<Map<String, dynamic>> get trustedContactsAsMap {
    return _trustedContacts.map((contact) {
      return {
        'id': contact.id,
        'userId': contact.userId,
        'contactId': contact.contactId,
        'name': contact.name,
        'phone': contact.phone,
        'email': contact.email,
        'relation': contact.relation,
        'isActive': contact.isActive,
        'addedAt': contact.addedAt.toIso8601String(),
      };
    }).toList();
  }

  List<Map<String, dynamic>> get fakeCallHistoryAsMap {
    return _fakeCallHistory.map((call) {
      return {
        'id': call.id,
        'userId': call.userId,
        'contactName': call.contactName,
        'contactNumber': call.contactNumber,
        'scheduledTime': call.scheduledTime.toIso8601String(),
        'createdAt': call.createdAt.toIso8601String(),
        'duration': call.duration,
      };
    }).toList();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Listen for incoming SOS notifications from Firestore
  void _listenForIncomingSos() {
    if (_userId == null) return;

    _incomingSosSubscription?.cancel();
    
    // Only listen for notifications created in the last 5 minutes to avoid old alerts
    final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));

    _incomingSosSubscription = FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: _userId)
        .where('type', isEqualTo: 'sos_alert')
        .where('read', isEqualTo: false)
        .where('createdAt', isGreaterThan: Timestamp.fromDate(fiveMinutesAgo))
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        final alertId = data['alertId'] as String?;
        final message = data['message'] as String? ?? 'Safety Alert';
        final title = data['title'] as String? ?? 'Emergency SOS';

        if (alertId != null && alertId != _lastNotifiedAlertId) {
          _lastNotifiedAlertId = alertId;
          
          // Mark as read immediately
          FirebaseFirestore.instance
              .collection('notifications')
              .doc(doc.id)
              .update({'read': true});
              
          _showGlobalSosDialog(title, message, alertId);
        }
      }
    });
  }

  /// Show a global SOS dialog regardless of current screen
  void _showGlobalSosDialog(String title, String message, String alertId) {
    final context = AppRouter.navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xffBD0000), // AppColors.dangerColor
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please check the SOS dashboard immediately.',
              style: TextStyle(color: Colors.white70, fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('DISMISS', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppRouter.navigatorKey.currentState?.pushNamed('/safety');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xffBD0000),
            ),
            child: const Text('VIEW LOCATION'),
          ),
        ],
      ),
    );
  }

  /// Trigger a test SOS alert for demonstration purposes
  Future<void> triggerTestSosLocally() async {
    _showGlobalSosDialog(
      'TEST SOS ALERT', 
      'This is a demonstration of the in-app SOS alert fallback for iOS. Your trusted contacts will see a similar alert when you trigger an emergency.', 
      'test_alert_id'
    );
  }
}
