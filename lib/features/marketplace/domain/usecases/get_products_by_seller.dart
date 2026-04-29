import '../entities/product.dart';
import '../repositories/marketplace_repository.dart';

/// Use case to get products by seller ID
class GetProductsBySeller {
  final MarketplaceRepository repository;

  GetProductsBySeller(this.repository);

  Future<List<ProductEntity>> execute(String sellerId) async {
    if (sellerId.isEmpty) {
      throw Exception('Seller ID cannot be empty');
    }
    return await repository.getProductsBySeller(sellerId);
  }
}












