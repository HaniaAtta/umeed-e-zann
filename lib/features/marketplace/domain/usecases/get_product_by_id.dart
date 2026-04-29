import '../entities/product.dart';
import '../repositories/marketplace_repository.dart';

/// Use case to get a product by ID
class GetProductById {
  final MarketplaceRepository repository;

  GetProductById(this.repository);

  Future<ProductEntity?> execute(String productId) async {
    if (productId.isEmpty) {
      throw Exception('Product ID cannot be empty');
    }
    return await repository.getProductById(productId);
  }
}












