import '../repositories/marketplace_repository.dart';

/// Use case to delete a product
class DeleteProduct {
  final MarketplaceRepository repository;

  DeleteProduct(this.repository);

  Future<void> execute(String productId) async {
    if (productId.isEmpty) {
      throw Exception('Product ID cannot be empty');
    }
    return await repository.deleteProduct(productId);
  }
}












