/// Domain entity for Product (pure Dart, no dependencies)
class ProductEntity {
  final String id;
  final String title;
  final String description;
  final double price;
  final String sellerId;
  final String sellerName;
  final String category;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final bool verified;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? specifications;
  final int stock;
  final bool isActive;

  ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.sellerId,
    required this.sellerName,
    required this.category,
    required this.images,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.verified = false,
    required this.createdAt,
    this.updatedAt,
    this.specifications,
    this.stock = 1,
    this.isActive = true,
  });

  ProductEntity copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? sellerId,
    String? sellerName,
    String? category,
    List<String>? images,
    double? rating,
    int? reviewCount,
    bool? verified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? specifications,
    int? stock,
    bool? isActive,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      category: category ?? this.category,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      verified: verified ?? this.verified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      specifications: specifications ?? this.specifications,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
    );
  }
}












