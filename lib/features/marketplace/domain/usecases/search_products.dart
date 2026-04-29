import '../entities/product.dart';
import '../repositories/marketplace_repository.dart';

/// Use case to search products by query
class SearchProducts {
  final MarketplaceRepository repository;

  SearchProducts(this.repository);

  Future<List<ProductEntity>> execute(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await repository.searchProducts(query.trim());
  }
}












