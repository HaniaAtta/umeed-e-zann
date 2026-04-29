import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../domain/repositories/legal_repository.dart';
import '../../data/repositories/legal_repository_impl.dart';
import '../../data/datasources/legal_remote_datasource.dart';
import '../../domain/usecases/get_chatbot_response.dart';
import '../../domain/usecases/save_chat_message.dart';
import '../../domain/usecases/get_chat_history.dart';
import '../../domain/usecases/clear_chat_history.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../../../data/services/legal_service.dart';

/// Provider for Legal Aid module (articles, documents, contacts, lawyers, NGOs, helplines, chatbot)
class LegalProvider with ChangeNotifier {
  final LegalRepository _repository;
  final LegalService _legalService = LegalService();
  
  // Use cases
  late final GetChatbotResponse _getChatbotResponse;
  late final SaveChatMessage _saveChatMessage;
  late final GetChatHistory _getChatHistory;
  late final ClearChatHistory _clearChatHistory;

  List<Map<String, dynamic>> _legalArticles = [];
  List<Map<String, dynamic>> _userDocuments = [];
  List<Map<String, dynamic>> _supportContacts = [];
  List<Map<String, dynamic>> _lawyers = [];
  List<Map<String, dynamic>> _ngos = [];
  List<Map<String, dynamic>> _helplines = [];
  List<ChatMessageEntity> _chatHistory = [];
  bool _isLoading = false;
  bool _isChatbotResponding = false;
  String? _error;

  // Stream subscriptions
  StreamSubscription<List<ChatMessageEntity>>? _chatHistorySubscription;

  List<Map<String, dynamic>> get legalArticles => _legalArticles;
  List<Map<String, dynamic>> get userDocuments => _userDocuments;
  List<Map<String, dynamic>> get supportContacts => _supportContacts;
  List<Map<String, dynamic>> get lawyers => _lawyers;
  List<Map<String, dynamic>> get ngos => _ngos;
  List<Map<String, dynamic>> get helplines => _helplines;
  List<ChatMessageEntity> get chatHistory => _chatHistory;
  bool get isLoading => _isLoading;
  bool get isChatbotResponding => _isChatbotResponding;
  String? get error => _error;

  String? get _userId {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      return currentUser?.uid;
    } catch (e) {
      return null;
    }
  }

  LegalProvider()
      : _repository = LegalRepositoryImpl(
          remoteDataSource: LegalRemoteDataSourceImpl(),
        ) {
    _initializeUseCases();
  }

  void _initializeUseCases() {
    _getChatbotResponse = GetChatbotResponse(_repository);
    _saveChatMessage = SaveChatMessage(_repository);
    _getChatHistory = GetChatHistory(_repository);
    _clearChatHistory = ClearChatHistory(_repository);
  }

  @override
  void dispose() {
    _chatHistorySubscription?.cancel();
    super.dispose();
  }

  /// Initialize - load chat history
  Future<void> initialize() async {
    if (_userId == null) return;
    
    _setLoading(true);
    _error = null;

    try {
      // Load chat history stream
      _chatHistorySubscription = _getChatHistory.execute(_userId!).listen((messages) {
        // Merge with local messages to avoid duplicates
        final existingIds = _chatHistory.map((m) => m.id).toSet();
        final newMessages = messages.where((m) => !existingIds.contains(m.id)).toList();
        if (newMessages.isNotEmpty) {
          _chatHistory.addAll(newMessages);
          // Sort by timestamp
          _chatHistory.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          notifyListeners();
        } else if (messages.length != _chatHistory.length) {
          // If stream has different count, update from stream (handles deletions)
          _chatHistory = messages;
          notifyListeners();
        }
      });
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Send message to chatbot
  Future<String?> sendChatbotMessage(String userMessage) async {
    if (_userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return null;
    }

    if (userMessage.trim().isEmpty) return null;

    _isChatbotResponding = true;
    _error = null;

    // Add user message to local list immediately for instant UI update
    final userMsgId = DateTime.now().millisecondsSinceEpoch.toString();
    final userMsg = ChatMessageEntity(
      id: userMsgId,
      userId: _userId!,
      message: userMessage.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    _chatHistory.add(userMsg);
    notifyListeners();

    try {
      // Save user message to Firestore
      await _saveChatMessage.execute(userMsg);

      // Get chatbot response
      final response = await _getChatbotResponse.execute(userMessage.trim());

      // Add bot response to local list immediately for instant UI update
      final botMsgId = '${DateTime.now().millisecondsSinceEpoch}_bot';
      final botMsg = ChatMessageEntity(
        id: botMsgId,
        userId: _userId!,
        message: userMessage.trim(),
        response: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _chatHistory.add(botMsg);
      notifyListeners();

      // Save bot response to Firestore
      await _saveChatMessage.execute(botMsg);

      return response;
    } catch (e) {
      // Remove messages from local list if error occurred
      _chatHistory.removeWhere((msg) => msg.id == userMsgId);
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _isChatbotResponding = false;
      notifyListeners();
    }
  }

  /// Clear chat history
  Future<void> clearChatHistory() async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _clearChatHistory.execute(_userId!);
      _chatHistory.clear();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load legal articles
  Future<void> loadLegalArticles({String? category, int? limit}) async {
    _setLoading(true);
    _error = null;

    try {
      _legalService.getLegalArticles(category: category, limit: limit).listen((articles) {
        _legalArticles = articles;
        notifyListeners();
      });
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Get legal article by ID
  Future<Map<String, dynamic>?> getLegalArticle(String articleId) async {
    _setLoading(true);
    _error = null;

    try {
      final article = await _legalService.getLegalArticle(articleId);
      _setLoading(false);
      return article;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return null;
    }
  }

  /// Search legal articles
  Future<List<Map<String, dynamic>>> searchLegalArticles(String query) async {
    _setLoading(true);
    _error = null;

    try {
      final results = await _legalService.searchLegalArticles(query);
      _setLoading(false);
      return results;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return [];
    }
  }

  /// Save document to vault
  Future<String?> saveDocument({
    required String title,
    required String type,
    required String fileUrl,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    if (_userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return null;
    }

    _setLoading(true);
    _error = null;

    try {
      final documentId = await _legalService.saveDocument(
        userId: _userId!,
        title: title,
        type: type,
        fileUrl: fileUrl,
        description: description,
        metadata: metadata,
      );
      await loadUserDocuments();
      _setLoading(false);
      return documentId;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return null;
    }
  }

  /// Load user documents
  Future<void> loadUserDocuments() async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      _legalService.getUserDocuments(_userId!).listen((documents) {
        _userDocuments = documents;
        notifyListeners();
      });
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Delete document
  Future<void> deleteDocument(String documentId) async {
    _setLoading(true);
    _error = null;

    try {
      await _legalService.deleteDocument(documentId);
      await loadUserDocuments();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load support contacts
  Future<void> loadSupportContacts({String? category}) async {
    _setLoading(true);
    _error = null;

    try {
      _supportContacts = await _legalService.getSupportContacts(category: category);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load lawyers
  Future<void> loadLawyers({String? specialization, String? city}) async {
    _setLoading(true);
    _error = null;

    try {
      _lawyers = await _legalService.getLawyers(
        specialization: specialization,
        city: city,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load NGOs
  Future<void> loadNGOs({String? category, String? city}) async {
    _setLoading(true);
    _error = null;

    try {
      _ngos = await _legalService.getNGOs(
        category: category,
        city: city,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load helplines
  Future<void> loadHelplines({String? category}) async {
    _setLoading(true);
    _error = null;

    try {
      _helplines = await _legalService.getHelplines(category: category);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Log helpline contact
  Future<void> logHelplineContact({
    required String helplineId,
    String? notes,
  }) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _legalService.logHelplineContact(
        userId: _userId!,
        helplineId: helplineId,
        notes: notes,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
