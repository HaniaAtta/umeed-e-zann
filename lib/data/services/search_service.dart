import 'package:cloud_firestore/cloud_firestore.dart';
import 'marketplace_service.dart';
import 'growth_service.dart';
import 'legal_service.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MarketplaceService _marketplaceService = MarketplaceService();
  final GrowthService _growthService = GrowthService();
  final LegalService _legalService = LegalService();

  // Global search across all modules
  Future<Map<String, dynamic>> globalSearch(String query) async {
    try {
      final results = <String, dynamic>{
        'products': <Map<String, dynamic>>[],
        'courses': <Map<String, dynamic>>[],
        'legalArticles': <Map<String, dynamic>>[],
      };

      // Search products
      try {
        final products = await _marketplaceService.searchProducts(query: query, limit: 5);
        results['products'] = products.map((p) => {
          'id': p.id,
          'title': p.title,
          'category': 'marketplace',
          'type': 'product',
          'price': p.price,
        }).toList();
      } catch (e) {
        // Ignore errors for individual searches
      }

      // Search courses
      try {
        final courses = await _growthService.getCourses(searchQuery: query);
        results['courses'] = courses.take(5).map((c) => {
          'id': c.id,
          'title': c.title,
          'category': 'growth',
          'type': 'course',
          'description': c.description,
        }).toList();
      } catch (e) {
        // Ignore errors
      }

      // Search legal articles
      try {
        final articles = await _legalService.searchLegalArticles(query);
        results['legalArticles'] = articles.take(5).map((a) => {
          'id': a['id'],
          'title': a['title'] ?? '',
          'category': 'legal',
          'type': 'article',
        }).toList();
      } catch (e) {
        // Ignore errors
      }

      return results;
    } catch (e) {
      throw Exception('Failed to perform global search: $e');
    }
  }

  // Search suggestions based on query
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      // Get popular search terms from Firestore
      final snapshot = await _firestore
          .collection('search_history')
          .where('query', isGreaterThanOrEqualTo: query)
          .where('query', isLessThanOrEqualTo: '$query\uf8ff')
          .orderBy('query')
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['query'] as String)
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Save search query to history
  Future<void> saveSearchHistory(String userId, String query) async {
    try {
      if (query.trim().isEmpty) return;

      await _firestore.collection('search_history').add({
        'userId': userId,
        'query': query.toLowerCase().trim(),
        'searchedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      // Ignore errors for search history
    }
  }

  // Get user search history
  Stream<List<String>> getUserSearchHistory(String userId, {int limit = 10}) {
    try {
      return _firestore
          .collection('search_history')
          .where('userId', isEqualTo: userId)
          .orderBy('searchedAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => doc.data()['query'] as String)
            .toList();
      });
    } catch (e) {
      return Stream.value([]);
    }
  }
}

