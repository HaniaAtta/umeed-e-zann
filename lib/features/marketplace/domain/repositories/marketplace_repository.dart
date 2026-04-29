import '../entities/product.dart';

/// Abstract repository interface for marketplace operations
abstract class MarketplaceRepository {
  /// Get all products with optional filtering
  Future<List<ProductEntity>> getProducts({
    String? category,
    int? limit,
  });

  /// Get products stream for real-time updates
  Stream<List<ProductEntity>> getProductsStream({
    String? category,
    int? limit,
  });

  /// Get product by ID
  Future<ProductEntity?> getProductById(String productId);

  /// Search products by query
  Future<List<ProductEntity>> searchProducts(String query);

  /// Get products by seller ID
  Future<List<ProductEntity>> getProductsBySeller(String sellerId);

  /// Create a new product
  Future<String> createProduct(ProductEntity product);

  /// Update an existing product
  Future<void> updateProduct(ProductEntity product);

  /// Delete a product
  Future<void> deleteProduct(String productId);
}












