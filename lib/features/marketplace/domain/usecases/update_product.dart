import '../entities/product.dart';
import '../repositories/marketplace_repository.dart';

/// Use case to update an existing product
class UpdateProduct {
  final MarketplaceRepository repository;

  UpdateProduct(this.repository);

  Future<void> execute(ProductEntity product) async {
    // Validate product before updating
    if (product.id.isEmpty) {
      throw Exception('Product ID cannot be empty');
    }
    if (product.title.isEmpty) {
      throw Exception('Product title cannot be empty');
    }
    if (product.price <= 0) {
      throw Exception('Product price must be greater than 0');
    }

    return await repository.updateProduct(product);
  }
}












