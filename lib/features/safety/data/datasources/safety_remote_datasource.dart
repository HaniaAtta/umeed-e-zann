import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/sos_alert_model.dart';
import '../models/trusted_contact_model.dart';
import '../models/live_tracking_model.dart';
import '../models/shake_alert_settings_model.dart';
import '../models/fake_call_model.dart';
import '../../domain/entities/sos_alert_entity.dart';
import '../../domain/entities/trusted_contact_entity.dart';
import '../../domain/entities/shake_alert_settings_entity.dart';
import '../../domain/entities/fake_call_entity.dart';

/// Remote data source for Safety module (Firebase operations)
abstract class SafetyRemoteDataSource {
  // SOS Alert Methods
  Future<String> createSosAlert({
    required String userId,
    required LocationEntity location,
    String? audioUrl,
    String? message,
  });

  Stream<List<SosAlertModel>> getSosAlerts(String userId);

  Future<void> updateSosAlertStatus({
    required String alertId,
    required String status,
  });

  // Trusted Contacts Methods
  Future<void> addTrustedContact(TrustedContactEntity contact);

  Future<void> removeTrustedContact({
    required String userId,
    required String contactId,
  });

  Stream<List<TrustedContactModel>> getTrustedContacts(String userId);

  // Live Tracking Methods
  Future<String> startLiveTracking({
    required String userId,
    required List<String> viewerIds,
  });

  Future<void> updateLiveTrackingLocation({
    required String trackingId,
    required LocationEntity location,
  });

  Stream<LiveTrackingModel?> getLiveTracking(String trackingId);

  Future<void> stopLiveTracking(String trackingId);

  // Shake Alert Methods
  Future<void> saveShakeAlertSettings(ShakeAlertSettingsEntity settings);

  Future<ShakeAlertSettingsModel?> getShakeAlertSettings(String userId);

  // Fake Call Methods
  Future<void> logFakeCall(FakeCallEntity fakeCall);

  Stream<List<FakeCallModel>> getFakeCallHistory(String userId);
}

/// Implementation of SafetyRemoteDataSource
class SafetyRemoteDataSourceImpl implements SafetyRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> createSosAlert({
    required String userId,
    required LocationEntity location,
    String? audioUrl,
    String? message,
  }) async {
    try {
      final sosData = {
        'userId': userId,
        'location': {
          'lat': location.lat,
          'lng': location.lng,
          'accuracy': location.accuracy,
          'timestamp': location.timestamp.toIso8601String(),
        },
        if (audioUrl != null) 'audioUrl': audioUrl,
        'message': message ?? 'Emergency SOS Alert',
        'status': 'active',
        'responded': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      };

      final docRef = await _firestore.collection('sos_alerts').add(sosData);

      // Create notification for the user
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': 'SOS Alert Sent',
        'message': 'Your SOS alert has been sent to trusted contacts and authorities',
        'type': 'sos_alert',
        'alertId': docRef.id,
        'read': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });

      // Notify trusted contacts
      await _notifyTrustedContacts(userId, docRef.id);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create SOS alert: $e');
    }
  }

  @override
  Stream<List<SosAlertModel>> getSosAlerts(String userId) {
    try {
      return _firestore
          .collection('sos_alerts')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots()
          .handleError((error) {
        // Handle Firestore index errors gracefully
        if (error.toString().contains('index') || 
            error.toString().contains('FAILED_PRECONDITION')) {
          // debugPrint('Firestore index required for sos_alerts query. '
          //    'Please create the index in Firebase Console.');
          // Return empty stream instead of crashing
          return Stream.value(<SosAlertModel>[]);
        }
        throw error;
      }).map((snapshot) {
        return snapshot.docs
            .map((doc) => SosAlertModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      // If it's an index error, return empty list instead of crashing
      if (e.toString().contains('index') || 
          e.toString().contains('FAILED_PRECONDITION')) {
        // debugPrint('Firestore index required for sos_alerts query: $e');
        return Stream.value(<SosAlertModel>[]);
      }
      throw Exception('Failed to get SOS alerts: $e');
    }
  }

  @override
  Future<void> updateSosAlertStatus({
    required String alertId,
    required String status,
  }) async {
    try {
      await _firestore.collection('sos_alerts').doc(alertId).update({
        'status': status,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update SOS alert: $e');
    }
  }

  @override
  Future<void> addTrustedContact(TrustedContactEntity contact) async {
    try {
      if (contact.name.trim().isEmpty) {
        throw Exception('Name cannot be empty');
      }
      if (contact.phone.trim().isEmpty) {
        throw Exception('Phone number cannot be empty');
      }

      final contactData = {
        'userId': contact.userId,
        'contactId': contact.contactId,
        'name': contact.name.trim(),
        'phone': contact.phone.trim(),
        if (contact.email != null) 'email': contact.email!.trim(),
        'relation': contact.relation?.trim() ?? 'Contact',
        'isActive': contact.isActive,
        'addedAt': Timestamp.fromDate(contact.addedAt),
      };

      final docRef = _firestore
          .collection('trusted_contacts')
          .doc('${contact.userId}_${contact.contactId}');

      await docRef.set(contactData, SetOptions(merge: false));

      // Update user's trustedContacts array
      try {
        await _firestore.collection('users').doc(contact.userId).update({
          'trustedContacts': FieldValue.arrayUnion([contact.contactId]),
        });
      } catch (e) {
        // Continue even if user document update fails
      }
    } catch (e) {
      throw Exception('Failed to add trusted contact: $e');
    }
  }

  @override
  Future<void> removeTrustedContact({
    required String userId,
    required String contactId,
  }) async {
    try {
      await _firestore
          .collection('trusted_contacts')
          .doc('${userId}_$contactId')
          .delete();

      await _firestore.collection('users').doc(userId).update({
        'trustedContacts': FieldValue.arrayRemove([contactId]),
      });
    } catch (e) {
      throw Exception('Failed to remove trusted contact: $e');
    }
  }

  @override
  Stream<List<TrustedContactModel>> getTrustedContacts(String userId) {
    try {
      return _firestore
          .collection('trusted_contacts')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => TrustedContactModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to get trusted contacts: $e');
    }
  }

  @override
  Future<String> startLiveTracking({
    required String userId,
    required List<String> viewerIds,
  }) async {
    try {
      final trackingData = {
        'userId': userId,
        'viewerIds': viewerIds,
        'status': 'active',
        'startedAt': Timestamp.fromDate(DateTime.now()),
        'locations': <Map<String, dynamic>>[],
        'lastUpdated': Timestamp.fromDate(DateTime.now()),
      };

      final docRef = await _firestore.collection('live_tracking').add(trackingData);
      final trackingId = docRef.id;
      
      // Notify trusted contacts about live tracking
      await _notifyTrustedContactsAboutLiveTracking(userId, trackingId, viewerIds);
      
      return trackingId;
    } catch (e) {
      throw Exception('Failed to start live tracking: $e');
    }
  }
  
  /// Notify trusted contacts about live tracking
  Future<void> _notifyTrustedContactsAboutLiveTracking(
    String userId,
    String trackingId,
    List<String> viewerIds,
  ) async {
    try {
      // Get user name
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userName = userDoc.data()?['name'] as String? ?? 'A trusted contact';
      
      // Get trusted contacts
      final contactsSnapshot = await _firestore
          .collection('trusted_contacts')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();
      
      final batch = _firestore.batch();
      
      for (var contactDoc in contactsSnapshot.docs) {
        final contactData = contactDoc.data();
        final contactId = contactData['contactId'] as String?;
        final contactPhone = contactData['phone'] as String?;
        
        // Create Firestore notification
        if (contactId != null && viewerIds.contains(contactId)) {
          final notificationRef = _firestore.collection('notifications').doc();
          batch.set(notificationRef, {
            'userId': contactId,
            'title': 'Live Tracking Started',
            'message': '$userName has started sharing their live location. You can now track them in real-time.',
            'type': 'live_tracking',
            'trackingId': trackingId,
            'read': false,
            'createdAt': Timestamp.fromDate(DateTime.now()),
          });
        }
        
        // Send SMS notification
        if (contactPhone != null && contactPhone.isNotEmpty) {
          await _sendSmsHelpMessage(
            phoneNumber: contactPhone,
            userName: userName,
            message: 'Live location tracking has been started. You can track me in the app.',
            lat: null,
            lng: null,
          );
        }
      }
      
      await batch.commit();
    } catch (e) {
      debugPrint('Failed to notify trusted contacts about live tracking: $e');
      // Don't throw - continue with tracking
    }
  }

  @override
  Future<void> updateLiveTrackingLocation({
    required String trackingId,
    required LocationEntity location,
  }) async {
    try {
      await _firestore.collection('live_tracking').doc(trackingId).update({
        'locations': FieldValue.arrayUnion([
          {
            'lat': location.lat,
            'lng': location.lng,
            'accuracy': location.accuracy,
            'timestamp': Timestamp.fromDate(location.timestamp),
          }
        ]),
        'lastUpdated': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update tracking location: $e');
    }
  }

  @override
  Stream<LiveTrackingModel?> getLiveTracking(String trackingId) {
    try {
      return _firestore
          .collection('live_tracking')
          .doc(trackingId)
          .snapshots()
          .map((doc) {
        if (!doc.exists) return null;
        return LiveTrackingModel.fromFirestore(doc);
      });
    } catch (e) {
      throw Exception('Failed to get live tracking: $e');
    }
  }

  @override
  Future<void> stopLiveTracking(String trackingId) async {
    try {
      await _firestore.collection('live_tracking').doc(trackingId).update({
        'status': 'stopped',
        'stoppedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to stop live tracking: $e');
    }
  }

  @override
  Future<void> saveShakeAlertSettings(ShakeAlertSettingsEntity settings) async {
    try {
      final settingsData = {
        'enabled': settings.enabled,
        'sensitivity': settings.sensitivity,
        if (settings.lastTriggered != null)
          'lastTriggered': Timestamp.fromDate(settings.lastTriggered!),
      };

      await _firestore
          .collection('shake_alert_settings')
          .doc(settings.userId)
          .set(settingsData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save shake alert settings: $e');
    }
  }

  @override
  Future<ShakeAlertSettingsModel?> getShakeAlertSettings(String userId) async {
    try {
      final doc = await _firestore
          .collection('shake_alert_settings')
          .doc(userId)
          .get();

      if (!doc.exists) return null;
      return ShakeAlertSettingsModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get shake alert settings: $e');
    }
  }

  @override
  Future<void> logFakeCall(FakeCallEntity fakeCall) async {
    try {
      final fakeCallData = {
        'userId': fakeCall.userId,
        if (fakeCall.contactName != null) 'contactName': fakeCall.contactName,
        if (fakeCall.contactNumber != null) 'contactNumber': fakeCall.contactNumber,
        'scheduledTime': Timestamp.fromDate(fakeCall.scheduledTime),
        'createdAt': Timestamp.fromDate(fakeCall.createdAt),
        'duration': fakeCall.duration,
      };

      await _firestore.collection('fake_calls').add(fakeCallData);
    } catch (e) {
      throw Exception('Failed to log fake call: $e');
    }
  }

  @override
  Stream<List<FakeCallModel>> getFakeCallHistory(String userId) {
    try {
      return _firestore
          .collection('fake_calls')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots()
          .handleError((error) {
        // Handle Firestore index errors gracefully
        if (error.toString().contains('index') || 
            error.toString().contains('FAILED_PRECONDITION')) {
          // debugPrint('Firestore index required for fake_calls query. '
          //    'Please create the index in Firebase Console.');
          // Return empty stream instead of crashing
          return Stream.value(<FakeCallModel>[]);
        }
        throw error;
      }).map((snapshot) {
        return snapshot.docs
            .map((doc) => FakeCallModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      // If it's an index error, return empty list instead of crashing
      if (e.toString().contains('index') || 
          e.toString().contains('FAILED_PRECONDITION')) {
        // debugPrint('Firestore index required for fake_calls query: $e');
        return Stream.value(<FakeCallModel>[]);
      }
      throw Exception('Failed to get fake call history: $e');
    }
  }

  /// Private method to notify trusted contacts
  Future<void> _notifyTrustedContacts(String userId, String alertId) async {
    try {
      // Get SOS alert details to include location in message
      final alertDoc = await _firestore.collection('sos_alerts').doc(alertId).get();
      if (!alertDoc.exists) return;

      final alertData = alertDoc.data();
      final location = alertData?['location'] as Map<String, dynamic>?;
      final lat = location?['lat'] as double?;
      final lng = location?['lng'] as double?;
      final message = alertData?['message'] as String? ?? 'Emergency SOS Alert';
      
      // Get user name for the message
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userName = userDoc.data()?['name'] as String? ?? 'A trusted contact';

      // Get trusted contacts
      final contactsSnapshot = await _firestore
          .collection('trusted_contacts')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      final batch = _firestore.batch();
      
      for (var contactDoc in contactsSnapshot.docs) {
        final contactData = contactDoc.data();
        final contactId = contactData['contactId'] as String?;
        final contactPhone = contactData['phone'] as String?;

        // Create Firestore notification
        if (contactId != null) {
          final notificationRef = _firestore.collection('notifications').doc();
          batch.set(notificationRef, {
            'userId': contactId,
            'title': 'SOS Alert',
            'message': '$userName has sent an SOS alert. Please check their location immediately.',
            'type': 'sos_alert',
            'alertId': alertId,
            'read': false,
            'createdAt': Timestamp.fromDate(DateTime.now()),
          });
        }

        // Send SMS help message to contact's phone number
        if (contactPhone != null && contactPhone.isNotEmpty) {
          await _sendSmsHelpMessage(
            phoneNumber: contactPhone,
            userName: userName,
            message: message,
            lat: lat,
            lng: lng,
          );
        }
      }
      
      await batch.commit();
      debugPrint('Successfully notified ${contactsSnapshot.docs.length} trusted contacts for SOS alert $alertId');
    } catch (e) {
      // Don't throw error, just log it
      debugPrint('Failed to notify trusted contacts: $e');
      debugPrint('Error details: ${e.toString()}');
    }
  }

  /// Send SMS help message to a contact
  Future<void> _sendSmsHelpMessage({
    required String phoneNumber,
    required String userName,
    required String message,
    double? lat,
    double? lng,
  }) async {
    try {
      // Build help message with location
      String helpMessage = '🚨 SOS ALERT 🚨\n\n';
      helpMessage += '$userName needs immediate help!\n\n';
      helpMessage += 'Message: $message\n\n';
      
      if (lat != null && lng != null) {
        // Create Google Maps link
        final mapsUrl = 'https://www.google.com/maps?q=$lat,$lng';
        helpMessage += '📍 Location: $lat, $lng\n';
        helpMessage += 'Map: $mapsUrl\n\n';
      }
      
      helpMessage += 'Please respond immediately!';

      // Clean phone number (remove spaces, dashes, etc.)
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      
      // Create SMS URL
      final smsUrl = Uri.parse('sms:$cleanPhone?body=${Uri.encodeComponent(helpMessage)}');
      
      // Launch SMS app with pre-filled message
      if (await canLaunchUrl(smsUrl)) {
        await launchUrl(smsUrl, mode: LaunchMode.externalApplication);
        debugPrint('SMS app opened for $phoneNumber with pre-filled message');
        debugPrint('Note: User must manually tap "Send" in SMS app - this is by design for security');
      } else {
        debugPrint('Could not launch SMS for $phoneNumber - SMS app may not be available');
      }
    } catch (e) {
      debugPrint('Failed to open SMS app for $phoneNumber: $e');
      // Don't throw - continue with other contacts
    }
  }
}

