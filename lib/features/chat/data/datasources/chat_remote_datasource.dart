import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/chat_message.dart';
import '../models/chat_message_model.dart';
import '../models/chat_thread_model.dart';
import '../models/user_model.dart';

/// Remote data source for chat operations
/// Handles all Firebase/Firestore interactions
abstract class ChatRemoteDataSource {
  Future<String> startChatWith({
    required String currentUserId,
    required String otherUserId,
    Map<String, dynamic>? currentUserProfile,
    Map<String, dynamic>? otherProfile,
  });

  Stream<List<ChatThreadModel>> watchChatThreads(String userId);

  Stream<List<ChatMessageModel>> watchMessages(String chatId);

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? imageUrl,
    String? replyToText,
  });

  Future<void> markAsRead({
    required String chatId,
    required String userId,
  });

  Future<ChatThreadModel?> getChatThread(String chatId);

  Future<ChatUserModel?> findUserByEmail(String email);

  Future<ChatUserModel?> findUserByPhone(String phone);

  Future<void> refreshParticipantProfile(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  String _chatIdFor(String userA, String userB) {
    final ids = [userA, userB]..sort();
    return ids.join('_');
  }

  @override
  Future<String> startChatWith({
    required String currentUserId,
    required String otherUserId,
    Map<String, dynamic>? currentUserProfile,
    Map<String, dynamic>? otherProfile,
  }) async {
    final chatId = _chatIdFor(currentUserId, otherUserId);
    final docRef = firestore.collection('chats').doc(chatId);
    final existing = await docRef.get();

    final now = DateTime.now();
    final participantProfiles = {
      currentUserId: currentUserProfile ?? {},
      otherUserId: otherProfile ?? {},
    };

    if (!existing.exists) {
      await docRef.set({
        'participants': [currentUserId, otherUserId],
        'lastMessage': 'Say hello 👋',
        'lastSenderId': currentUserId,
        'updatedAt': Timestamp.fromDate(now),
        'unreadCounts': {
          currentUserId: 0,
          otherUserId: 1,
        },
        'participantProfiles': participantProfiles,
      });
    } else if (otherProfile != null || currentUserProfile != null) {
      await docRef.set({
        'participantProfiles': participantProfiles,
      }, SetOptions(merge: true));
    }

    return chatId;
  }

  @override
  Stream<List<ChatThreadModel>> watchChatThreads(String userId) {
    debugPrint('ChatRemoteDataSource: Watching chats for user $userId');

    return firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snap) {
      debugPrint('ChatRemoteDataSource: Received ${snap.docs.length} chat documents');

      final threads = <ChatThreadModel>[];
      for (final doc in snap.docs) {
        try {
          final thread = ChatThreadModel.fromFirestore(doc);
          threads.add(thread);
        } catch (e, stackTrace) {
          debugPrint('ChatRemoteDataSource: Error parsing chat document ${doc.id}: $e');
          debugPrint('ChatRemoteDataSource: Stack trace: $stackTrace');
        }
      }

      // Sort by updatedAt descending (most recent first)
      threads.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return threads;
    }).handleError((error, stackTrace) {
      debugPrint('ChatRemoteDataSource: Error in watchChatThreads: $error');
      return <ChatThreadModel>[];
    });
  }

  @override
  Stream<List<ChatMessageModel>> watchMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snap) => snap.docs.map(ChatMessageModel.fromFirestore).toList());
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? imageUrl,
    String? replyToText,
  }) async {
    if (text.trim().isEmpty && (imageUrl ?? '').isEmpty) return;

    final now = DateTime.now();
    final messageRef = firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    final message = ChatMessageModel(
      id: messageRef.id,
      chatId: chatId,
      senderId: senderId,
      text: text.trim(),
      createdAt: now,
      status: ChatMessageStatus.sent,
      imageUrl: imageUrl,
      replyToText: replyToText,
    );

    final chatRef = firestore.collection('chats').doc(chatId);
    final chatSnap = await chatRef.get();
    final participants = (chatSnap.data()?['participants'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    final unreadCounts = Map<String, int>.from(chatSnap.data()?['unreadCounts'] ?? {});
    for (final participant in participants) {
      if (participant == senderId) {
        unreadCounts[participant] = 0;
      } else {
        unreadCounts[participant] = (unreadCounts[participant] ?? 0) + 1;
      }
    }

    await firestore.runTransaction((txn) async {
      txn.set(messageRef, message.toJson());
      txn.set(chatRef, {
        'lastMessage': text.trim().isEmpty ? 'Sent a media' : text.trim(),
        'lastSenderId': senderId,
        'updatedAt': Timestamp.fromDate(now),
        'unreadCounts': unreadCounts,
      }, SetOptions(merge: true));
    });
  }

  @override
  Future<void> markAsRead({
    required String chatId,
    required String userId,
  }) async {
    final chatRef = firestore.collection('chats').doc(chatId);
    await chatRef.set({
      'unreadCounts': {userId: 0},
    }, SetOptions(merge: true));

    final unreadMessages = await chatRef
        .collection('messages')
        .where('senderId', isNotEqualTo: userId)
        .where('status', isNotEqualTo: 'read')
        .limit(20)
        .get();

    final batch = firestore.batch();
    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {'status': 'read'});
    }
    await batch.commit();
  }

  @override
  Future<ChatThreadModel?> getChatThread(String chatId) async {
    try {
      final doc = await firestore.collection('chats').doc(chatId).get();
      if (!doc.exists) return null;
      return ChatThreadModel.fromFirestore(doc);
    } catch (e) {
      debugPrint('ChatRemoteDataSource: Error getting chat thread: $e');
      return null;
    }
  }

  @override
  Future<ChatUserModel?> findUserByEmail(String email) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email.toLowerCase().trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return ChatUserModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to find user: $e');
    }
  }

  @override
  Future<ChatUserModel?> findUserByPhone(String phone) async {
    try {
      final normalizedPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
      final querySnapshot = await firestore
          .collection('users')
          .where('phone', isEqualTo: normalizedPhone)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return ChatUserModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to find user: $e');
    }
  }

  @override
  Future<void> refreshParticipantProfile(String userId) async {
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return;

      final userData = userDoc.data()!;
      final profile = {
        'name': userData['name'] ?? userData['email'] ?? '',
        'avatar': userData['profileImageUrl'],
        'email': userData['email'],
        'phone': userData['phone'],
      };

      final chatsQuery = await firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .get();

      final batch = firestore.batch();
      for (final doc in chatsQuery.docs) {
        batch.update(doc.reference, {
          'participantProfiles.$userId': profile,
        });
      }
      await batch.commit();
    } catch (e) {
      debugPrint('ChatRemoteDataSource: Error refreshing participant profile: $e');
    }
  }
}

