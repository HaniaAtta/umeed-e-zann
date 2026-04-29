import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/chat_message_model.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../knowledge_base/legal_knowledge_base.dart';

/// Remote data source for Legal module (Firebase operations)
abstract class LegalRemoteDataSource {
  Future<String> getChatbotResponse(String userMessage);
  
  Future<void> saveChatMessage(ChatMessageEntity message);
  
  Stream<List<ChatMessageModel>> getChatHistory(String userId);
  
  Future<void> clearChatHistory(String userId);
}

/// Implementation of LegalRemoteDataSource
class LegalRemoteDataSourceImpl implements LegalRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> getChatbotResponse(String userMessage) async {
    try {
      // Use the knowledge base to get response
      final response = LegalKnowledgeBase.search(userMessage);
      
      // Add a helpful note if response seems generic
      if (response.contains("couldn't find")) {
        return '$response\n\n💡 **Tip**: Try asking about specific topics like "divorce rights", "property inheritance", or "constitutional rights for women".';
      }
      
      return response;
    } catch (e) {
      throw Exception('Failed to get chatbot response: $e');
    }
  }

  @override
  Future<void> saveChatMessage(ChatMessageEntity message) async {
    try {
      final model = ChatMessageModel.fromEntity(message);
      await _firestore
          .collection('legal_chat_history')
          .doc(message.id)
          .set(model.toFirestore());
    } catch (e) {
      throw Exception('Failed to save chat message: $e');
    }
  }

  @override
  Stream<List<ChatMessageModel>> getChatHistory(String userId) {
    try {
      return _firestore
          .collection('legal_chat_history')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: false)
          .limit(100)
          .snapshots()
          .handleError((error) {
        // Handle Firestore index errors gracefully
        if (error.toString().contains('index') || 
            error.toString().contains('FAILED_PRECONDITION')) {
          debugPrint('Firestore index required for legal_chat_history query. '
              'Please create the index in Firebase Console.');
          // Return empty stream instead of crashing
          return Stream.value(<ChatMessageModel>[]);
        }
        throw error;
      }).map((snapshot) {
        return snapshot.docs
            .map((doc) => ChatMessageModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      // If it's an index error, return empty stream instead of crashing
      if (e.toString().contains('index') || 
          e.toString().contains('FAILED_PRECONDITION')) {
        debugPrint('Firestore index required for legal_chat_history query: $e');
        return Stream.value(<ChatMessageModel>[]);
      }
      throw Exception('Failed to get chat history: $e');
    }
  }

  @override
  Future<void> clearChatHistory(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('legal_chat_history')
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear chat history: $e');
    }
  }
}

