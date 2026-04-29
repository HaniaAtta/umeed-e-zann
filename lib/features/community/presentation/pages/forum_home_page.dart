import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../contents/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import 'create_post_page.dart';
import 'post_details_page.dart';

class ForumHomePage extends StatefulWidget {
  const ForumHomePage({super.key});

  @override
  State<ForumHomePage> createState() => _ForumHomePageState();
}

class _ForumHomePageState extends State<ForumHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Support',
    'Health',
    'Legal',
    'Career',
    'Relationships',
    'General',
  ];

  // Mock posts data
  final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'title': 'Looking for advice on work-life balance',
      'content': 'I\'m struggling to balance my career and personal life...',
      'author': 'Anonymous User',
      'category': 'Career',
      'replies': 12,
      'likes': 45,
      'isAnonymous': true,
      'timestamp': '2 hours ago',
    },
    {
      'id': '2',
      'title': 'Health concerns - need support',
      'content': 'Has anyone experienced similar symptoms?',
      'author': 'Anonymous User',
      'category': 'Health',
      'replies': 8,
      'likes': 23,
      'isAnonymous': true,
      'timestamp': '5 hours ago',
    },
    {
      'id': '3',
      'title': 'Legal advice needed',
      'content': 'I need guidance on a legal matter...',
      'author': 'Anonymous User',
      'category': 'Legal',
      'replies': 15,
      'likes': 67,
      'isAnonymous': true,
      'timestamp': '1 day ago',
    },
    {
      'id': '4',
      'title': 'Success story - wanted to share',
      'content': 'After months of struggle, I finally...',
      'author': 'Anonymous User',
      'category': 'Support',
      'replies': 34,
      'likes': 120,
      'isAnonymous': true,
      'timestamp': '2 days ago',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      drawer: const SideDrawer(currentModule: 'community'),
      appBar: const CustomAppBar(
        title: 'Community',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: responsive.getPadding(),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search discussions...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ),

          // Category chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.primaryLightPink,
                    checkmarkColor: AppColors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.primaryDark,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Posts list
          Expanded(
            child: _posts.isEmpty
                ? const EmptyState(
                    message: 'No discussions found',
                    icon: Icons.forum_outlined,
                  )
                : ListView.builder(
                    padding: responsive.getPadding(),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      return _buildPostCard(context, _posts[index], responsive);
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
              builder: (context) => const CreatePostPage(),
            ),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text('New Post'),
        backgroundColor: AppColors.primaryPink,
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    Map<String, dynamic> post,
    Responsive responsive,
  ) {
    return GradientCard(
      margin: const EdgeInsets.only(bottom: 16),
      accentColor: AppColors.primaryPink,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailsPage(post: post),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryLightPink.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              post['category'] as String,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryPink,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            post['title'] as String,
            style: TextStyle(
              fontSize: responsive.getFontSize(16, 18, 20),
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Content preview
          Text(
            post['content'] as String,
            style: TextStyle(
              fontSize: responsive.getFontSize(14, 15, 16),
              color: AppColors.darkGrey,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // Footer info
          Row(
            children: [
              // Anonymous icon
              if (post['isAnonymous'] as bool)
                Icon(
                  Icons.visibility_off,
                  size: 16,
                  color: AppColors.grey,
                ),
              if (post['isAnonymous'] as bool) const SizedBox(width: 4),
              Text(
                post['author'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
              const Spacer(),
              Text(
                post['timestamp'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Stats
          Row(
            children: [
              _buildStatIcon(Icons.comment, post['replies'] as int),
              const SizedBox(width: 16),
              _buildStatIcon(Icons.favorite, post['likes'] as int),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryPink),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 12,
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

