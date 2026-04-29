import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../../../../core/extensions/extensions.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'General';
  bool _isAnonymous = true;

  final List<String> _categories = [
    'Support',
    'Health',
    'Legal',
    'Career',
    'Relationships',
    'General',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(currentModule: 'community'),
      appBar: const CustomAppBar(
        title: 'New Post',
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.responsive(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Anonymous toggle
              Card(
                child: SwitchListTile(
                  title: const Text('Post Anonymously'),
                  subtitle: const Text(
                    'Your identity will be hidden from other users',
                  ),
                  value: _isAnonymous,
                  onChanged: (value) {
                    setState(() {
                      _isAnonymous = value;
                    });
                  },
                  activeThumbColor: AppColors.primaryPink,
                ),
              ),

              const SizedBox(height: 24),

              // Category
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  helperText: 'Select the most appropriate category',
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

              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter a clear and descriptive title',
                ),
                validator: (value) => Validators.validateRequired(value, fieldName: 'Title'),
                maxLength: 200,
              ),

              const SizedBox(height: 16),

              // Content
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  hintText: 'Share your thoughts, questions, or experiences...',
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                maxLength: 5000,
                validator: (value) => Validators.validateRequired(value, fieldName: 'Content'),
              ),

              const SizedBox(height: 24),

              // Guidelines card
              Card(
                color: AppColors.primaryVeryLightPink.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryPurple,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Community Guidelines',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Be respectful and supportive\n'
                        '• No hate speech or discrimination\n'
                        '• Keep discussions relevant\n'
                        '• Report inappropriate content',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post published successfully!'),
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
                    const Text(
                      'Publish Post',
                      style: TextStyle(color: AppColors.white),
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
}

