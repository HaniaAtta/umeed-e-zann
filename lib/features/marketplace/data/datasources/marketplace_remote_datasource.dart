import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

/// Remote data source for marketplace (Firebase Firestore implementation)
abstract class MarketplaceRemoteDataSource {
  Future<String> createProduct(ProductModel product);
  Future<ProductModel?> getProductById(String productId);
  Future<void> updateProduct(String productId, Map<String, dynamic> data);
  Future<void> deleteProduct(String productId);
  Stream<List<ProductModel>> getAllProductsStream({
    String? category,
    int? limit,
  });
  Stream<List<ProductModel>> getProductsBySeller(String sellerId);
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? category,
    int? limit,
  });
}

class MarketplaceRemoteDataSourceImpl implements MarketplaceRemoteDataSource {
  final FirebaseFirestore firestore;

  MarketplaceRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<String> createProduct(ProductModel product) async {
    try {
      final productData = product.toJson();
      productData.remove('id'); // Remove id as Firestore generates it
      
      final docRef = await firestore.collection('products').add(productData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await firestore.collection('products').doc(productId).get();
      if (!doc.exists) return null;
      return ProductModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  @override
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await firestore.collection('products').doc(productId).update(data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  @override
  Stream<List<ProductModel>> getAllProductsStream({
    String? category,
    int? limit,
  }) {
    try {
      Query query = firestore.collection('products').where('isActive', isEqualTo: true);
      
      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
        return query.snapshots().map((snapshot) {
          var products = snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
          products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          if (limit != null && limit > 0) {
            products = products.take(limit).toList();
          }
          return products;
        });
      } else {
        query = query.orderBy('createdAt', descending: true);
        if (limit != null) {
          query = query.limit(limit);
        }
        return query.snapshots().map((snapshot) {
          return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
        });
      }
    } catch (e) {
      throw Exception('Failed to get products stream: $e');
    }
  }

  @override
  Stream<List<ProductModel>> getProductsBySeller(String sellerId) {
    try {
      return firestore
          .collection('products')
          .where('sellerId', isEqualTo: sellerId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
      });
    } catch (e) {
      throw Exception('Failed to get seller products: $e');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? category,
    int? limit,
  }) async {
    try {
      Query firestoreQuery = firestore.collection('products').where('isActive', isEqualTo: true);
      
      if (category != null && category != 'All') {
        firestoreQuery = firestoreQuery.where('category', isEqualTo: category);
      }
      
      final snapshot = await firestoreQuery.get();
      final allProducts = snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
      
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
}












