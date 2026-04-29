import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LegalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Legal Articles/Documents Methods

  // Get legal articles by category
  Stream<List<Map<String, dynamic>>> getLegalArticles({
    String? category,
    int? limit,
  }) {
    Query query = _firestore.collection('legal_articles').where('isPublished', isEqualTo: true);
    
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    
    // Note: If using orderBy with where, you may need a composite index
    // For now, we'll try orderBy and handle errors gracefully
    try {
      query = query.orderBy('createdAt', descending: true);
    } catch (e) {
      // If orderBy fails (due to missing index), continue without it
      // The query will still work, just not ordered
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'id': doc.id};
      }).toList();
    }).handleError((error) {
      throw Exception('Failed to get legal articles: $error');
    });
  }

  // Get legal article by ID
  Future<Map<String, dynamic>?> getLegalArticle(String articleId) async {
    try {
      final doc = await _firestore.collection('legal_articles').doc(articleId).get();
      if (!doc.exists) return null;
      return {...doc.data()!, 'id': doc.id};
    } catch (e) {
      throw Exception('Failed to get legal article: $e');
    }
  }

  // Search legal articles
  Future<List<Map<String, dynamic>>> searchLegalArticles(String query) async {
    try {
      final snapshot = await _firestore
          .collection('legal_articles')
          .where('isPublished', isEqualTo: true)
          .get();
      
      final allArticles = snapshot.docs.map((doc) {
        final data = doc.data();
        return {...data, 'id': doc.id};
      }).toList();
      
      // Client-side search
      final searchLower = query.toLowerCase();
      return allArticles.where((article) {
        final title = (article['title'] ?? '').toString().toLowerCase();
        final content = (article['content'] ?? '').toString().toLowerCase();
        final category = (article['category'] ?? '').toString().toLowerCase();
        return title.contains(searchLower) ||
            content.contains(searchLower) ||
            category.contains(searchLower);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search legal articles: $e');
    }
  }

  // Document Vault Methods

  // Save document to vault
  Future<String> saveDocument({
    required String userId,
    required String title,
    required String type,
    required String fileUrl,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final documentData = {
        'userId': userId,
        'title': title,
        'type': type,
        'fileUrl': fileUrl,
        'description': description,
        'metadata': metadata ?? {},
        'uploadedAt': Timestamp.fromDate(DateTime.now()),
      };
      
      final docRef = await _firestore.collection('user_documents').add(documentData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save document: $e');
    }
  }

  // Get user documents
  Stream<List<Map<String, dynamic>>> getUserDocuments(String userId) {
    try {
      return _firestore
          .collection('user_documents')
          .where('userId', isEqualTo: userId)
          .orderBy('uploadedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return {...data, 'id': doc.id};
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get user documents: $e');
    }
  }

  // Delete document
  Future<void> deleteDocument(String documentId) async {
    try {
      await _firestore.collection('user_documents').doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  // Support Contacts Methods

  // Get support contacts by category
  Future<List<Map<String, dynamic>>> getSupportContacts({
    String? category,
  }) async {
    try {
      Query query = _firestore.collection('support_contacts').where('isActive', isEqualTo: true);
      
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map<Map<String, dynamic>>((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'id': doc.id};
      }).toList();
    } catch (e) {
      throw Exception('Failed to get support contacts: $e');
    }
  }

  // Get lawyers list
  Future<List<Map<String, dynamic>>> getLawyers({
    String? specialization,
    String? city,
  }) async {
    try {
      Query query = _firestore.collection('lawyers').where('isActive', isEqualTo: true);
      
      if (specialization != null) {
        query = query.where('specialization', isEqualTo: specialization);
      }
      
      if (city != null) {
        query = query.where('city', isEqualTo: city);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map<Map<String, dynamic>>((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'id': doc.id};
      }).toList();
    } catch (e) {
      throw Exception('Failed to get lawyers: $e');
    }
  }

  // Get NGOs list
  Future<List<Map<String, dynamic>>> getNGOs({
    String? category,
    String? city,
  }) async {
    try {
      Query query = _firestore.collection('ngos').where('isActive', isEqualTo: true);
      
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }
      
      if (city != null) {
        query = query.where('city', isEqualTo: city);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map<Map<String, dynamic>>((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'id': doc.id};
      }).toList();
    } catch (e) {
      throw Exception('Failed to get NGOs: $e');
    }
  }

  // Helpline Methods

  // Get helplines
  Future<List<Map<String, dynamic>>> getHelplines({
    String? category,
  }) async {
    try {
      Query query = _firestore.collection('helplines').where('isActive', isEqualTo: true);
      
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map<Map<String, dynamic>>((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'id': doc.id};
      }).toList();
    } catch (e) {
      throw Exception('Failed to get helplines: $e');
    }
  }

  // Log helpline contact
  Future<void> logHelplineContact({
    required String userId,
    required String helplineId,
    String? notes,
  }) async {
    try {
      await _firestore.collection('helpline_contacts').add({
        'userId': userId,
        'helplineId': helplineId,
        'notes': notes,
        'contactedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to log helpline contact: $e');
    }
  }
}

