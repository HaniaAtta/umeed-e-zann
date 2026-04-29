import '../../domain/entities/product.dart';
import '../../domain/repositories/marketplace_repository.dart';
import '../datasources/marketplace_remote_datasource.dart';
import '../models/product_model.dart';

/// Repository implementation for marketplace
class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final MarketplaceRemoteDataSource remoteDataSource;

  MarketplaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductEntity>> getProducts({
    String? category,
    int? limit,
  }) async {
    try {
      final products = await remoteDataSource
          .getAllProductsStream(category: category, limit: limit)
          .first;
      return products.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Stream<List<ProductEntity>> getProductsStream({
    String? category,
    int? limit,
  }) {
    try {
      return remoteDataSource
          .getAllProductsStream(category: category, limit: limit)
          .map((models) => models.map((model) => model.toEntity()).toList());
    } catch (e) {
      throw Exception('Failed to get products stream: $e');
    }
  }

  @override
  Future<ProductEntity?> getProductById(String productId) async {
    try {
      final product = await remoteDataSource.getProductById(productId);
      return product?.toEntity();
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    try {
      final products = await remoteDataSource.searchProducts(query: query);
      return products.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getProductsBySeller(String sellerId) async {
    try {
      final products = await remoteDataSource.getProductsBySeller(sellerId).first;
      return products.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get seller products: $e');
    }
  }

  @override
  Future<String> createProduct(ProductEntity product) async {
    try {
      final model = ProductModel.fromEntity(product);
      return await remoteDataSource.createProduct(model);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final data = model.toJson();
      data.remove('id');
      await remoteDataSource.updateProduct(product.id, data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await remoteDataSource.deleteProduct(productId);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}












