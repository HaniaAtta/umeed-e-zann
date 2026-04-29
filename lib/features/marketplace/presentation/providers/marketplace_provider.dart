import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/marketplace_repository.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../domain/usecases/get_products_by_seller.dart';
import '../../data/datasources/marketplace_remote_datasource.dart';
import '../../data/repositories/marketplace_repository_impl.dart';

/// Provider for Marketplace module using Clean Architecture
class MarketplaceProvider with ChangeNotifier {
  final MarketplaceRepository _repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Use cases
  late final GetProducts _getProducts;
  late final CreateProduct _createProduct;
  late final UpdateProduct _updateProduct;
  late final DeleteProduct _deleteProduct;
  late final SearchProducts _searchProducts;
  late final GetProductById _getProductById;
  late final GetProductsBySeller _getProductsBySeller;

  List<ProductEntity> _products = [];
  List<ProductEntity> _myProducts = [];
  String? _selectedCategory;
  bool _isLoading = false;
  String? _error;

  List<ProductEntity> get products => _products;
  List<ProductEntity> get myProducts => _myProducts;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? get _userId => _auth.currentUser?.uid;

  MarketplaceProvider({MarketplaceRepository? repository})
      : _repository = repository ??
            MarketplaceRepositoryImpl(
              remoteDataSource: MarketplaceRemoteDataSourceImpl(),
            ) {
    // Initialize use cases
    _getProducts = GetProducts(_repository);
    _createProduct = CreateProduct(_repository);
    _updateProduct = UpdateProduct(_repository);
    _deleteProduct = DeleteProduct(_repository);
    _searchProducts = SearchProducts(_repository);
    _getProductById = GetProductById(_repository);
    _getProductsBySeller = GetProductsBySeller(_repository);
  }

  /// Load products with optional category filter
  Future<void> loadProducts({String? category, int? limit}) async {
    _setLoading(true);
    _error = null;
    _selectedCategory = category;

    try {
      _products = await _getProducts.execute(
        category: category,
        limit: limit,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load products stream for real-time updates
  void loadProductsStream({String? category, int? limit}) {
    _setLoading(true);
    _error = null;
    _selectedCategory = category;

    _repository
        .getProductsStream(category: category, limit: limit)
        .listen((productList) {
      _products = productList;
      _setLoading(false);
      notifyListeners();
    }, onError: (error) {
      _error = error.toString();
      _setLoading(false);
      notifyListeners();
    });
  }

  /// Create product
  Future<String?> createProduct(ProductEntity product) async {
    _setLoading(true);
    _error = null;

    try {
      final productId = await _createProduct.execute(product);
      await loadProducts(category: _selectedCategory);
      if (_userId != null) {
        await loadMyProducts();
      }
      return productId;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Update product
  Future<bool> updateProduct(ProductEntity product) async {
    _setLoading(true);
    _error = null;

    try {
      await _updateProduct.execute(product);
      await loadProducts(category: _selectedCategory);
      if (_userId != null) {
        await loadMyProducts();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete product
  Future<bool> deleteProduct(String productId) async {
    _setLoading(true);
    _error = null;

    try {
      await _deleteProduct.execute(productId);
      await loadProducts(category: _selectedCategory);
      if (_userId != null) {
        await loadMyProducts();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get product by ID
  Future<ProductEntity?> getProduct(String productId) async {
    _setLoading(true);
    _error = null;

    try {
      final product = await _getProductById.execute(productId);
      _setLoading(false);
      return product;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return null;
    }
  }

  /// Search products
  Future<void> searchProducts(String query) async {
    _setLoading(true);
    _error = null;

    try {
      _products = await _searchProducts.execute(query);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load my products (products by current seller)
  Future<void> loadMyProducts() async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      _myProducts = await _getProductsBySeller.execute(_userId!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}












