import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/responsive/responsive.dart';
import '../../../../contents/colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  String _selectedCategory = 'Handmade';
  bool _isService = false;
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'Handmade',
    'Clothing',
    'Accessories',
    'Beauty',
    'Home Decor',
    'Services',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const SideDrawer(currentModule: 'marketplace'),
      appBar: CustomAppBar(
        title: l10n.newListing,
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: responsive.getPadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product/Service toggle
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: Text(l10n.product),
                      selected: !_isService,
                      onSelected: (selected) {
                        setState(() {
                          _isService = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ChoiceChip(
                      label: Text(l10n.service),
                      selected: _isService,
                      onSelected: (selected) {
                        setState(() {
                          _isService = true;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Images section
              Text(
                l10n.imagesMax5,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _images.length && _images.length < 5) {
                      return _buildAddImageButton();
                    }
                    return _buildImagePreview(index);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.titleLabel,
                  hintText: l10n.enterTitleHint,
                ),
                validator: (value) => Validators.validateRequired(value, fieldName: 'Title'),
                maxLength: 100,
              ),

              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: l10n.categoryLabel,
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Price
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: l10n.priceLabel,
                  hintText: '0.00',
                  prefixText: '\$',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: Validators.validatePrice,
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.descriptionLabel,
                  hintText: l10n.describeProductHint,
                ),
                maxLines: 6,
                maxLength: 1000,
                validator: (value) => Validators.validateRequired(value, fieldName: 'Description'),
              ),

              const SizedBox(height: 32),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.listingCreatedSuccess),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mediumPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.publish, color: AppColors.white),
                    const SizedBox(width: 8),
                    Text(
                      l10n.publishListing,
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null && _images.length < 5) {
        setState(() {
          _images.add(image);
        });
      } else if (_images.length >= 5) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.maxImagesAllowed),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorPickingImage(e.toString())),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    }
  }

  Widget _buildAddImageButton() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey, width: 2, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate, size: 40, color: AppColors.grey),
              SizedBox(height: 8),
              Text(
                l10n.addImage,
                style: const TextStyle(color: AppColors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(int index) {
    final image = _images[index];
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
        image: image.path.isNotEmpty
            ? DecorationImage(
                image: FileImage(File(image.path)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          if (image.path.isEmpty)
            const Center(
              child: Icon(
                Icons.image,
                size: 40,
                color: AppColors.grey,
              ),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                setState(() {
                  _images.removeAt(index);
                });
              },
              style: IconButton.styleFrom(
                backgroundColor: AppColors.white,
                padding: const EdgeInsets.all(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

