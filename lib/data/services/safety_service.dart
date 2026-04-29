import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // SOS Alert Methods

  // Create SOS alert
  Future<String> createSosAlert({
    required String userId,
    required Map<String, dynamic> location,
    String? audioUrl,
    String? message,
  }) async {
    try {
      final sosData = {
        'userId': userId,
        'location': location,
        'audioUrl': audioUrl,
        'message': message ?? 'Emergency SOS Alert',
        'status': 'active',
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'responded': false,
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
      
      // Send notifications to trusted contacts (would integrate with FCM)
      await _notifyTrustedContacts(userId, docRef.id);
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create SOS alert: $e');
    }
  }

  // Get SOS alerts for user
  Stream<List<Map<String, dynamic>>> getUserSosAlerts(String userId) {
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
          debugPrint('Firestore index required for sos_alerts query. '
              'Please create the index in Firebase Console.');
          // Return empty stream instead of crashing
          return Stream.value(<Map<String, dynamic>>[]);
        }
        throw error;
      }).map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return {...data, 'id': doc.id};
        }).toList();
      });
    } catch (e) {
      // If it's an index error, return empty list instead of crashing
      if (e.toString().contains('index') || 
          e.toString().contains('FAILED_PRECONDITION')) {
        debugPrint('Firestore index required for sos_alerts query: $e');
        return Stream.value(<Map<String, dynamic>>[]);
      }
      throw Exception('Failed to get SOS alerts: $e');
    }
  }

  // Update SOS alert status
  Future<void> updateSosAlertStatus(String alertId, String status) async {
    try {
      await _firestore.collection('sos_alerts').doc(alertId).update({
        'status': status,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update SOS alert: $e');
    }
  }

  // Trusted Contacts Methods

  // Add trusted contact
  Future<void> addTrustedContact(
    String userId, {
    required String name,
    required String phone,
    String? email,
    String? relation,
  }) async {
    try {
      // Validate inputs
      if (name.trim().isEmpty) {
        throw Exception('Name cannot be empty');
      }
      if (phone.trim().isEmpty) {
        throw Exception('Phone number cannot be empty');
      }

      // Use phone number as contactId (sanitize it - remove all non-digits)
      final contactId = phone.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (contactId.isEmpty) {
        throw Exception('Invalid phone number format');
      }
      
      final contactData = {
        'userId': userId,
        'contactId': contactId,
        'name': name.trim(),
        'phone': phone.trim(),
        'email': email?.trim(),
        'relation': relation?.trim() ?? 'Contact',
        'addedAt': Timestamp.fromDate(DateTime.now()),
        'isActive': true,
      };
      
      // Save to trusted_contacts collection
      final docRef = _firestore
          .collection('trusted_contacts')
          .doc('${userId}_$contactId');
      
      await docRef.set(contactData, SetOptions(merge: false));
      
      debugPrint('✅ Trusted contact saved to Firestore: ${docRef.id}');
      
      // Also update user's trustedContacts array in users collection
      try {
        await _firestore.collection('users').doc(userId).update({
          'trustedContacts': FieldValue.arrayUnion([contactId]),
        });
        debugPrint('✅ User trustedContacts array updated');
      } catch (e) {
        // If user document doesn't exist or update fails, log but don't fail
        debugPrint('⚠️ Warning: Could not update user trustedContacts array: $e');
        // Continue - the contact is still saved in trusted_contacts collection
      }
    } on FirebaseException catch (e) {
      debugPrint('❌ Firebase error adding contact: ${e.code} - ${e.message}');
      throw Exception('Firebase error: ${e.code} - ${e.message}');
    } catch (e) {
      debugPrint('❌ Error adding trusted contact: $e');
      throw Exception('Failed to add trusted contact: $e');
    }
  }

  // Remove trusted contact
  Future<void> removeTrustedContact(String userId, String contactId) async {
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

  // Get trusted contacts
  Stream<List<Map<String, dynamic>>> getTrustedContacts(String userId) {
    try {
      return _firestore
          .collection('trusted_contacts')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return {...data, 'id': doc.id};
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get trusted contacts: $e');
    }
  }

  // Live Tracking Methods

  // Start live tracking session
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
      };
      
      final docRef = await _firestore.collection('live_tracking').add(trackingData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to start live tracking: $e');
    }
  }

  // Update location for live tracking
  Future<void> updateLiveTrackingLocation(
    String trackingId,
    Map<String, dynamic> location,
  ) async {
    try {
      await _firestore.collection('live_tracking').doc(trackingId).update({
        'locations': FieldValue.arrayUnion([
          {
            ...location,
            'timestamp': Timestamp.fromDate(DateTime.now()),
          }
        ]),
        'lastUpdated': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update tracking location: $e');
    }
  }

  // Get live tracking data
  Stream<Map<String, dynamic>?> getLiveTracking(String trackingId) {
    try {
      return _firestore
          .collection('live_tracking')
          .doc(trackingId)
          .snapshots()
          .map((doc) {
        if (!doc.exists) return null;
        return {...doc.data()!, 'id': doc.id};
      });
    } catch (e) {
      throw Exception('Failed to get live tracking: $e');
    }
  }

  // Stop live tracking
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

  // Fake Call Methods

  // Log fake call
  Future<void> logFakeCall(String userId, {
    String? contactName,
    String? contactNumber,
    DateTime? scheduledTime,
  }) async {
    try {
      final fakeCallData = {
        'userId': userId,
        'contactName': contactName,
        'contactNumber': contactNumber,
        'scheduledTime': scheduledTime != null
            ? Timestamp.fromDate(scheduledTime)
            : Timestamp.fromDate(DateTime.now()),
        'createdAt': Timestamp.fromDate(DateTime.now()),
      };
      
      await _firestore.collection('fake_calls').add(fakeCallData);
    } catch (e) {
      throw Exception('Failed to log fake call: $e');
    }
  }

  // Get fake call history
  Stream<List<Map<String, dynamic>>> getFakeCallHistory(String userId) {
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
          debugPrint('Firestore index required for fake_calls query. '
              'Please create the index in Firebase Console.');
          // Return empty stream instead of crashing
          return Stream.value(<Map<String, dynamic>>[]);
        }
        throw error;
      }).map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return {...data, 'id': doc.id};
        }).toList();
      });
    } catch (e) {
      // If it's an index error, return empty list instead of crashing
      if (e.toString().contains('index') || 
          e.toString().contains('FAILED_PRECONDITION')) {
        debugPrint('Firestore index required for fake_calls query: $e');
        return Stream.value(<Map<String, dynamic>>[]);
      }
      throw Exception('Failed to get fake call history: $e');
    }
  }

  // Private method to notify trusted contacts
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
      
      // Create notifications for each contact
      final batch = _firestore.batch();
      for (var contactDoc in contactsSnapshot.docs) {
        final contactData = contactDoc.data();
        final contactId = contactData['contactId'] as String?;
        final contactPhone = contactData['phone'] as String?;
        
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
    } catch (e) {
      // Don't throw error, just log it
      debugPrint('Failed to notify trusted contacts: $e');
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
        await launchUrl(smsUrl);
        debugPrint('SMS help message sent to $phoneNumber');
      } else {
        debugPrint('Could not launch SMS for $phoneNumber');
      }
    } catch (e) {
      debugPrint('Failed to send SMS to $phoneNumber: $e');
      // Don't throw - continue with other contacts
    }
  }
}

