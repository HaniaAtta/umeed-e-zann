import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_thread.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

/// Repository implementation for chat operations
/// Implements the domain repository interface using remote data source
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final FirebaseAuth auth;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.auth,
  });

  User? get _currentUser => auth.currentUser;

  @override
  Future<String> startChatWith({
    required String otherUserId,
    Map<String, dynamic>? otherProfile,
  }) async {
    final me = _currentUser;
    if (me == null) throw Exception('Not authenticated');

    final currentUserProfile = {
      'name': me.displayName ?? '',
      'avatar': me.photoURL,
    };

    return remoteDataSource.startChatWith(
      currentUserId: me.uid,
      otherUserId: otherUserId,
      currentUserProfile: currentUserProfile,
      otherProfile: otherProfile,
    );
  }

  @override
  Stream<List<ChatThread>> watchChatThreads() {
    final me = _currentUser;
    if (me == null) {
      return Stream.value([]);
    }

    return remoteDataSource.watchChatThreads(me.uid).map((models) {
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Stream<List<ChatMessage>> watchMessages(String chatId) {
    return remoteDataSource.watchMessages(chatId).map((models) {
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String text,
    String? imageUrl,
    String? replyToText,
  }) async {
    final me = _currentUser;
    if (me == null) throw Exception('Not authenticated');

    return remoteDataSource.sendMessage(
      chatId: chatId,
      senderId: me.uid,
      text: text,
      imageUrl: imageUrl,
      replyToText: replyToText,
    );
  }

  @override
  Future<void> markAsRead(String chatId) async {
    final me = _currentUser;
    if (me == null) return;

    return remoteDataSource.markAsRead(
      chatId: chatId,
      userId: me.uid,
    );
  }

  @override
  Future<ChatThread?> getChatThread(String chatId) async {
    final model = await remoteDataSource.getChatThread(chatId);
    return model?.toEntity();
  }

  @override
  Future<ChatUser?> findUserByEmail(String email) async {
    final model = await remoteDataSource.findUserByEmail(email);
    return model?.toEntity();
  }

  @override
  Future<ChatUser?> findUserByPhone(String phone) async {
    final model = await remoteDataSource.findUserByPhone(phone);
    return model?.toEntity();
  }

  @override
  Future<ChatUser?> findUserByEmailOrPhone(String query) async {
    if (query.contains('@')) {
      return findUserByEmail(query);
    } else {
      return findUserByPhone(query);
    }
  }

  @override
  Future<String> startChatByContact({
    required String emailOrPhone,
  }) async {
    final me = _currentUser;
    if (me == null) throw Exception('Not authenticated');

    final otherUser = await findUserByEmailOrPhone(emailOrPhone);
    if (otherUser == null) {
      throw Exception('User not found with this email or phone number');
    }

    if (otherUser.id == me.uid) {
      throw Exception('You cannot start a chat with yourself');
    }

    final otherProfile = {
      'name': otherUser.name ?? otherUser.email,
      'avatar': otherUser.profileImageUrl,
      'email': otherUser.email,
      'phone': otherUser.phone,
    };

    final chatId = await startChatWith(
      otherUserId: otherUser.id,
      otherProfile: otherProfile,
    );

    // Wait a bit to ensure Firestore has propagated the document
    await Future.delayed(const Duration(milliseconds: 300));

    return chatId;
  }

  @override
  Future<void> refreshParticipantProfile(String userId) async {
    return remoteDataSource.refreshParticipantProfile(userId);
  }
}

