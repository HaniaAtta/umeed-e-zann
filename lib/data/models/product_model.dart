import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
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

  Product({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? json['id'] ?? '',
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

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product.fromJson({...data, 'id': doc.id});
  }

  Product copyWith({
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
    return Product(
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

