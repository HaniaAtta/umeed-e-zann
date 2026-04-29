import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';

/// Data Transfer Object (DTO) for Product with Firestore serialization
class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.sellerId,
    required super.sellerName,
    required super.category,
    required super.images,
    super.rating,
    super.reviewCount,
    super.verified,
    required super.createdAt,
    super.updatedAt,
    super.specifications,
    super.stock,
    super.isActive,
  });

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'category': category,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'verified': verified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'specifications': specifications ?? {},
      'stock': stock,
      'isActive': isActive,
    };
  }

  /// Create from Firestore document
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel.fromJson({...data, 'id': doc.id});
  }

  /// Create from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      category: json['category'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      verified: json['verified'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
      specifications: json['specifications'] as Map<String, dynamic>?,
      stock: json['stock'] as int? ?? 1,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Convert entity to model
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      sellerId: entity.sellerId,
      sellerName: entity.sellerName,
      category: entity.category,
      images: entity.images,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      verified: entity.verified,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      specifications: entity.specifications,
      stock: entity.stock,
      isActive: entity.isActive,
    );
  }

  /// Convert model to entity
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      description: description,
      price: price,
      sellerId: sellerId,
      sellerName: sellerName,
      category: category,
      images: images,
      rating: rating,
      reviewCount: reviewCount,
      verified: verified,
      createdAt: createdAt,
      updatedAt: updatedAt,
      specifications: specifications,
      stock: stock,
      isActive: isActive,
    );
  }
}












