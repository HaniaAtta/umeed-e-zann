import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generic methods for collections

  // Create document
  Future<void> createDocument({
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(id).set(data);
    } catch (e) {
      throw Exception('Failed to create document: $e');
    }
  }

  // Get document
  Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String id,
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(id).get();
      if (!doc.exists) return null;
      return {...doc.data()!, 'id': doc.id};
    } catch (e) {
      throw Exception('Failed to get document: $e');
    }
  }

  // Update document
  Future<void> updateDocument({
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(id).update(data);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  // Delete document
  Future<void> deleteDocument({
    required String collection,
    required String id,
  }) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  // Get collection stream
  Stream<List<Map<String, dynamic>>> getCollectionStream({
    required String collection,
    Query Function(Query)? queryBuilder,
    int? limit,
  }) {
    Query query = _firestore.collection(collection);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map<Map<String, dynamic>>((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'id': doc.id};
      }).toList();
    }).handleError((error) {
      throw Exception('Failed to get collection stream: $error');
    });
  }

  // Query documents
  Future<List<Map<String, dynamic>>> queryDocuments({
    required String collection,
    Query Function(Query)? queryBuilder,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collection);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map<Map<String, dynamic>>((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'id': doc.id};
      }).toList();
    } catch (e) {
      throw Exception('Failed to query documents: $e');
    }
  }

  // Search documents by field
  Future<List<Map<String, dynamic>>> searchDocuments({
    required String collection,
    required String field,
    required String searchTerm,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collection);
      
      // Firestore doesn't support full-text search, so we do client-side filtering
      // For better performance, use Algolia or implement server-side search
      final snapshot = await query.get();
      final allDocs = snapshot.docs.map<Map<String, dynamic>>((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'id': doc.id};
      }).toList();

      final filtered = allDocs.where((doc) {
        final fieldValue = doc[field]?.toString().toLowerCase() ?? '';
        return fieldValue.contains(searchTerm.toLowerCase());
      }).toList();

      if (limit != null && limit > 0) {
        return filtered.take(limit).toList();
      }
      return filtered;
    } catch (e) {
      throw Exception('Failed to search documents: $e');
    }
  }

  // Batch write
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    try {
      final batch = _firestore.batch();
      
      for (var operation in operations) {
        final collection = operation['collection'] as String;
        final id = operation['id'] as String?;
        final data = operation['data'] as Map<String, dynamic>;
        final type = operation['type'] as String; // 'set', 'update', 'delete'
        
        final docRef = id != null
            ? _firestore.collection(collection).doc(id)
            : _firestore.collection(collection).doc();

        switch (type) {
          case 'set':
            batch.set(docRef, data);
            break;
          case 'update':
            batch.update(docRef, data);
            break;
          case 'delete':
            batch.delete(docRef);
            break;
        }
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch write: $e');
    }
  }
}

