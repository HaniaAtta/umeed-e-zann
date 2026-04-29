import '../entities/product.dart';
import '../repositories/marketplace_repository.dart';

/// Use case to get products with optional filtering
class GetProducts {
  final MarketplaceRepository repository;

  GetProducts(this.repository);

  Future<List<ProductEntity>> execute({
    String? category,
    int? limit,
  }) async {
    return await repository.getProducts(
      category: category,
      limit: limit,
    );
  }
}












