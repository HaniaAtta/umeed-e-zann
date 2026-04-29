import '../entities/product.dart';
import '../repositories/marketplace_repository.dart';

/// Use case to create a new product
class CreateProduct {
  final MarketplaceRepository repository;

  CreateProduct(this.repository);

  Future<String> execute(ProductEntity product) async {
    // Validate product before creating
    if (product.title.isEmpty) {
      throw Exception('Product title cannot be empty');
    }
    if (product.price <= 0) {
      throw Exception('Product price must be greater than 0');
    }
    if (product.category.isEmpty) {
      throw Exception('Product category cannot be empty');
    }

    return await repository.createProduct(product);
  }
}












