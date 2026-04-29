import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? time,
    IconData? icon,
    Color? color,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isRead: isRead ?? this.isRead,
    );
  }

  factory NotificationModel.fromFirestore(Map<String, dynamic> data) {
    // Map notification type to icon and color
    IconData icon;
    Color color;
    
    final type = data['type'] as String? ?? 'general';
    switch (type) {
      case 'sos_alert':
        icon = Icons.emergency;
        color = const Color(0xFFE63946); // dangerColor
        break;
      case 'course':
      case 'course_available':
        icon = Icons.book;
        color = const Color(0xFF6C63FF); // mediumBluePurple
        break;
      case 'cycle':
      case 'cycle_reminder':
        icon = Icons.calendar_today;
        color = const Color(0xFFFFB6C1); // softPink
        break;
      case 'appointment':
        icon = Icons.event;
        color = const Color(0xFF9B8FB8); // mediumPurple
        break;
      case 'community':
        icon = Icons.people;
        color = const Color(0xFFD4A5A5); // dustyRose
        break;
      default:
        icon = Icons.notifications;
        color = const Color(0xFF6C63FF);
    }

    // Calculate time string from createdAt timestamp
    String timeStr = 'Just now';
    if (data['createdAt'] != null) {
      final createdAt = data['createdAt'] as Timestamp;
      final now = DateTime.now();
      final diff = now.difference(createdAt.toDate());
      
      if (diff.inMinutes < 1) {
        timeStr = 'Just now';
      } else if (diff.inMinutes < 60) {
        timeStr = '${diff.inMinutes} minutes ago';
      } else if (diff.inHours < 24) {
        timeStr = '${diff.inHours} hours ago';
      } else {
        timeStr = '${diff.inDays} days ago';
      }
    }

    return NotificationModel(
      id: data['id'] ?? '',
      title: data['title'] as String? ?? 'Notification',
      message: data['message'] as String? ?? data['body'] as String? ?? '',
      time: timeStr,
      icon: icon,
      color: color,
      isRead: data['read'] as bool? ?? false,
    );
  }
}

/// Service to manage notifications throughout the app
class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  List<NotificationModel> _notifications = [];
  StreamSubscription? _notificationsSubscription;
  String? _fcmToken;

  /// Initialize notification service including FCM and Local Notifications
  Future<void> initialize() async {
    // Request permissions for iOS and Android 13+
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permission');
      
      // Get FCM token
      _fcmToken = await _messaging.getToken();
      debugPrint('FCM Token: $_fcmToken');
      
      // Initialise Local Notifications for foreground display
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings();
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );
      
      await _localNotifications.initialize(initializationSettings);

      // Handle token refreshes
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _updateTokenInFirestore(newToken);
      });

      // Start listening to messages
      _setupMessageHandlers();
      
      // Update token in Firestore if user is logged in
      if (_auth.currentUser != null) {
        _updateTokenInFirestore(_fcmToken);
      }
    } else {
      debugPrint('User declined or has not accepted notification permission');
    }
    
    // Load initial notifications from Firestore
    await loadNotifications();
  }

  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      if (message.notification != null) {
        _showLocalNotification(message);
        // Also add to Firestore so it shows in the notification list
        addNotification(
          title: message.notification!.title ?? 'New Notification',
          message: message.notification!.body ?? '',
          type: message.data['type'] ?? 'general',
        );
      }
    });

    // Background/Terminated state message click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      // Handle navigation if needed
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'safety_alerts',
          'Safety Alerts',
          channelDescription: 'Notifications for SOS and safety alerts',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await _localNotifications.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }

  Future<void> _updateTokenInFirestore(String? token) async {
    if (_userId == null || token == null) return;
    try {
      await _firestore.collection('users').doc(_userId).set({
        'fcmToken': token,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  String? get _userId => _auth.currentUser?.uid;

  /// Load notifications from Firestore
  Future<void> loadNotifications() async {
    if (_userId == null) {
      _notifications = [];
      notifyListeners();
      return;
    }

    try {
      // Cancel previous subscription
      await _notificationsSubscription?.cancel();

      // Listen to notifications stream
      _notificationsSubscription = _firestore
          .collection('notifications')
          .where('userId', isEqualTo: _userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots()
          .listen((snapshot) {
        _notifications = snapshot.docs.map((doc) {
          final data = doc.data();
          return NotificationModel.fromFirestore({
            ...data,
            'id': doc.id,
          });
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      // If error, keep empty list
      _notifications = [];
      notifyListeners();
    }
  }

  /// Add notification to Firestore (respects user notification settings)
  Future<void> addNotification({
    required String title,
    required String message,
    String type = 'general',
  }) async {
    if (_userId == null) return;

    try {
      // Check user's notification settings
      final userDoc = await _firestore.collection('users').doc(_userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        final settings = userData?['settings'] as Map<String, dynamic>?;
        final notificationsEnabled = settings?['notificationsEnabled'] as bool? ?? true;
        
        // Only add notification if user has notifications enabled
        if (!notificationsEnabled) {
          debugPrint('Notifications disabled for user, skipping notification');
          return;
        }
      }

      await _firestore.collection('notifications').add({
        'userId': _userId,
        'title': title,
        'message': message,
        'type': type,
        'read': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      debugPrint('Error adding notification: $e');
    }
  }

  /// Remove notification from Firestore
  Future<void> removeNotification(String id) async {
    if (_userId == null) return;

    try {
      await _firestore.collection('notifications').doc(id).delete();
    } catch (e) {
      debugPrint('Error removing notification: $e');
    }
  }

  /// Mark notification as read in Firestore
  Future<void> markAsRead(String id) async {
    if (_userId == null) return;

    try {
      await _firestore.collection('notifications').doc(id).update({
        'read': true,
      });
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    if (_userId == null) return;

    try {
      final batch = _firestore.batch();
      final unread = _notifications.where((n) => !n.isRead).toList();
      
      for (var notification in unread) {
        final ref = _firestore.collection('notifications').doc(notification.id);
        batch.update(ref, {'read': true});
      }
      
      await batch.commit();
    } catch (e) {
      debugPrint('Error marking all as read: $e');
    }
  }

  /// Clear all notifications
  Future<void> clearAll() async {
    if (_userId == null) return;

    try {
      final batch = _firestore.batch();
      for (var notification in _notifications) {
        final ref = _firestore.collection('notifications').doc(notification.id);
        batch.delete(ref);
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Error clearing notifications: $e');
    }
  }

  @override
  void dispose() {
    _notificationsSubscription?.cancel();
    super.dispose();
  }
}
