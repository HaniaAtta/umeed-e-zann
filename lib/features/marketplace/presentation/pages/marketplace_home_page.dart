import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/responsive/responsive_widgets.dart';
import '../../../../contents/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_search_bar.dart';
import '../../../../shared/widgets/banner_carousel.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../providers/marketplace_provider.dart';
import '../../domain/entities/product.dart';
import 'create_listing_page.dart';
import 'product_details_page.dart';

import '../../../../core/widgets_shared/side_drawer.dart';

class MarketplaceHomePage extends StatefulWidget {
  const MarketplaceHomePage({super.key});

  @override
  State<MarketplaceHomePage> createState() => _MarketplaceHomePageState();
}

class _MarketplaceHomePageState extends State<MarketplaceHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MarketplaceProvider>(context, listen: false);
      provider.loadProducts();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query != _searchQuery) {
      setState(() {
        _searchQuery = query;
      });
      final provider = Provider.of<MarketplaceProvider>(context, listen: false);
      if (query.isEmpty) {
        provider.loadProducts(category: _selectedCategory == 'All' ? null : _selectedCategory);
      } else {
        provider.searchProducts(query);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final l10n = AppLocalizations.of(context)!;

    // Localized categories map
    final List<Map<String, String>> categories = [
      {'id': 'All', 'label': l10n.all},
      {'id': 'Handmade', 'label': l10n.handmade},
      {'id': 'Clothing', 'label': l10n.clothing},
      {'id': 'Accessories', 'label': l10n.accessories},
      {'id': 'Beauty', 'label': l10n.beauty},
      {'id': 'Home Decor', 'label': l10n.homeDecor},
      {'id': 'Services', 'label': l10n.services},
    ];

    return Scaffold(
      drawer: const SideDrawer(currentModule: 'marketplace'),
      appBar: CustomAppBar(
        title: l10n.marketplace,
        showLogo: true,
      ),
      body: Column(
        children: [
          // Search bar
          CustomSearchBar(
            controller: _searchController,
            hintText: l10n.searchProducts,
            onFilterTap: () {
              // Show filter dialog
            },
          ),

          // Banner Carousel
          const BannerCarousel(
            images: [
              'assets/images/banner.jpg',
              'assets/images/banner1.png',
            ],
          ),

          // Category chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category['id'] == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category['label']!),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category['id']!;
                      });
                      final provider = Provider.of<MarketplaceProvider>(context, listen: false);
                      provider.loadProducts(category: category['id'] == 'All' ? null : category['id']);
                    },
                    selectedColor: AppColors.primaryPink,
                    checkmarkColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.primaryDark,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected 
                          ? AppColors.primaryPink 
                          : AppColors.primaryLightPink.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Products grid
          Expanded(
            child: Consumer<MarketplaceProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: AppColors.dangerColor),
                        const SizedBox(height: 16),
                        Text(provider.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.loadProducts(category: _selectedCategory == 'All' ? null : _selectedCategory),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  );
                }
                
                final products = provider.products;
                
                if (products.isEmpty) {
                  return EmptyState(
                    message: l10n.noProductsFound,
                    icon: Icons.shopping_bag_outlined,
                  );
                }
                
                return ResponsiveGridView(
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: responsive.getWidth(0.75, 0.7, 0.65),
                  children: [
                    ...products.map((product) {
                      return _buildProductCard(context, product, responsive);
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateListingPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.sellItem),
        backgroundColor: AppColors.primaryPink,
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductEntity product,
    Responsive responsive,
  ) {
    return GradientCard(
      accentColor: AppColors.primaryLightPink,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              product: {
                'id': product.id,
                'title': product.title,
                'description': product.description,
                'price': product.price,
                'seller': product.sellerName,
                'rating': product.rating,
                'verified': product.verified,
                'images': product.images,
              },
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 60,
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Product title
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Seller info
          Row(
            children: [
              Expanded(
                child: Text(
                  product.sellerName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (product.verified)
                const Icon(
                  Icons.verified,
                  size: 16,
                  color: AppColors.primaryPurple,
                ),
            ],
          ),
          const SizedBox(height: 4),
          // Price and rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rs ${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPink,
                ),
              ),
              if (product.rating > 0)
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

