import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class MarketplaceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create product
  Future<String> createProduct(Product product) async {
    try {
      final productData = product.toJson();
      productData.remove('id'); // Remove id as Firestore generates it
      
      final docRef = await _firestore.collection('products').add(productData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  // Get product by ID
  Future<Product?> getProduct(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (!doc.exists) return null;
      return Product.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  // Update product
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await _firestore.collection('products').doc(productId).update(data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Get all products stream
  Stream<List<Product>> getAllProductsStream({
    String? category,
    int? limit,
  }) {
    try {
      Query query = _firestore.collection('products').where('isActive', isEqualTo: true);
      
      // If category filter is applied, we can't use orderBy with multiple where clauses
      // without a composite index. So we'll do client-side sorting instead.
      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
        // Don't use orderBy here - will sort client-side
        return query.snapshots().map((snapshot) {
          var products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
          // Sort by createdAt descending (newest first)
          products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          if (limit != null && limit > 0) {
            products = products.take(limit).toList();
          }
          return products;
        });
      } else {
        // No category filter, so we can use orderBy
        query = query.orderBy('createdAt', descending: true);
        if (limit != null) {
          query = query.limit(limit);
        }
        return query.snapshots().map((snapshot) {
          return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
        });
      }
    } catch (e) {
      throw Exception('Failed to get products stream: $e');
    }
  }

  // Get products by seller
  Stream<List<Product>> getProductsBySeller(String sellerId) {
    try {
      return _firestore
          .collection('products')
          .where('sellerId', isEqualTo: sellerId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
      });
    } catch (e) {
      throw Exception('Failed to get seller products: $e');
    }
  }

  // Search products
  Future<List<Product>> searchProducts({
    required String query,
    String? category,
    int? limit,
  }) async {
    try {
      Query firestoreQuery = _firestore.collection('products').where('isActive', isEqualTo: true);
      
      if (category != null && category != 'All') {
        firestoreQuery = firestoreQuery.where('category', isEqualTo: category);
      }
      
      final snapshot = await firestoreQuery.get();
      final allProducts = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
      
      // Client-side search (for better search, consider Algolia or server-side search)
      final searchLower = query.toLowerCase();
      final filtered = allProducts.where((product) {
        return product.title.toLowerCase().contains(searchLower) ||
            product.description.toLowerCase().contains(searchLower) ||
            product.sellerName.toLowerCase().contains(searchLower) ||
            product.category.toLowerCase().contains(searchLower);
      }).toList();
      
      if (limit != null && limit > 0) {
        return filtered.take(limit).toList();
      }
      return filtered;
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category, {int? limit}) async {
    try {
      // Query without orderBy to avoid composite index requirement
      // We'll sort client-side instead
      Query query = _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true);
      
      final snapshot = await query.get();
      var products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
      
      // Sort by createdAt descending (newest first)
      products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      if (limit != null && limit > 0) {
        products = products.take(limit).toList();
      }
      
      return products;
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }
}

