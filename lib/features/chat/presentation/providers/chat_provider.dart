import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_thread.dart';
import '../../domain/repositories/chat_repository.dart';

/// Provider for chat feature state management
/// Uses repository (Clean Architecture) instead of service
class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // State
  List<ChatThread> _chats = [];
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  String? _peerName;
  bool _showEmojiPicker = false;

  // Track current user to detect account switches
  String? _currentUserId;

  // Cached streams to avoid recreating on every build
  Stream<List<ChatThread>>? _chatsStream;
  StreamSubscription<List<ChatThread>>? _chatsSubscription;
  StreamSubscription<User?>? _authStateSubscription;

  // Controllers
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  ChatProvider(this._chatRepository) {
    // Listen to auth state changes to clear cache when user switches
    _authStateSubscription = _auth.authStateChanges().listen((user) {
      final newUserId = user?.uid;

      // If user changed (including logout), clear the cached stream and state
      if (_currentUserId != null && _currentUserId != newUserId) {
        debugPrint('ChatProvider: User changed from $_currentUserId to $newUserId. Clearing cache.');
        _clearCache();
      }

      _currentUserId = newUserId;
    });
  }

  // Getters
  List<ChatThread> get chats => _chats;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get peerName => _peerName;
  bool get showEmojiPicker => _showEmojiPicker;
  TextEditingController get messageController => _messageController;
  ScrollController get scrollController => _scrollController;
  FocusNode get focusNode => _focusNode;

  // Watch chats stream - cached to avoid recreating on every build
  Stream<List<ChatThread>> watchChatsForCurrentUser() {
    final currentUserId = _auth.currentUser?.uid;

    // If user changed or stream doesn't exist, create new stream
    if (_chatsStream == null || _currentUserId != currentUserId) {
      // Defer cache clearing to avoid calling notifyListeners() during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _clearCache();
      });
      _currentUserId = currentUserId;

      debugPrint('ChatProvider: Creating new chats stream for user: $currentUserId');
      _chatsStream = _chatRepository.watchChatThreads().map((chats) {
        _chats = chats;
        // Defer notifyListeners to avoid calling during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
        return chats;
      }).asBroadcastStream();
    }

    return _chatsStream!;
  }

  // Alias for backward compatibility
  Stream<List<ChatThread>> watchChats() {
    return watchChatsForCurrentUser();
  }

  // Watch messages stream
  Stream<List<ChatMessage>> watchMessages(String chatId) {
    return _chatRepository.watchMessages(chatId).map((messages) {
      _messages = messages;
      notifyListeners();
      _scrollToBottom();
      return messages;
    });
  }

  // Load participant info
  Future<void> loadParticipantInfo(ChatThread chat, String myId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final peerId = chat.participants.firstWhere(
        (id) => id != myId,
        orElse: () => chat.participants.first,
      );

      _peerName = chat.nameFor(peerId);

      // If not found, we can fetch from user repository in future
      // For now, use what's available in chat thread
    } catch (e) {
      _error = 'Failed to load participant info: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Send message
  Future<void> sendMessage({
    required String chatId,
    required String text,
    String? imageUrl,
    String? replyToText,
  }) async {
    if (text.trim().isEmpty && (imageUrl ?? '').isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _chatRepository.sendMessage(
        chatId: chatId,
        text: text,
        imageUrl: imageUrl,
        replyToText: replyToText,
      );
      _messageController.clear();
      _error = null;
      _scrollToBottom();
    } catch (e) {
      _error = 'Failed to send message: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mark as read
  Future<void> markAsRead(String chatId) async {
    try {
      await _chatRepository.markAsRead(chatId);
    } catch (e) {
      debugPrint('ChatProvider: Error marking chat as read: $e');
    }
  }

  // Start chat by contact
  Future<String?> startChatByContact(String emailOrPhone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final chatId = await _chatRepository.startChatByContact(
        emailOrPhone: emailOrPhone,
      );
      await Future.delayed(const Duration(milliseconds: 500));
      return chatId;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get chat thread
  Future<ChatThread?> getChatThread(String chatId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final chat = await _chatRepository.getChatThread(chatId);
      return chat;
    } catch (e) {
      _error = 'Failed to get chat thread: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle emoji picker
  void toggleEmojiPicker() {
    _showEmojiPicker = !_showEmojiPicker;
    if (_showEmojiPicker) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
    notifyListeners();
  }

  // Insert emoji into message controller
  void insertEmoji(String emoji) {
    final text = _messageController.text;
    final selection = _messageController.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      emoji,
    );
    _messageController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + emoji.length,
      ),
    );
  }

  // Set emoji picker visibility
  void setEmojiPicker(bool show) {
    _showEmojiPicker = show;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear messages (when leaving chat)
  void clearMessages() {
    _messages = [];
    _peerName = null;
    notifyListeners();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 64,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Clear cached stream and state
  void _clearCache() {
    _chatsSubscription?.cancel();
    _chatsStream = null;
    _chats = [];
    _messages = [];
    _peerName = null;
    _error = null;
    _showEmojiPicker = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _chatsSubscription?.cancel();
    _authStateSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

