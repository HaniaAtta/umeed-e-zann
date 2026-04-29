import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../contents/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/gradient_card.dart';

class PostDetailsPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailsPage({
    super.key,
    required this.post,
  });

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final TextEditingController _replyController = TextEditingController();
  bool _isLiked = false;
  int _likeCount = 0;

  // Mock replies data
  final List<Map<String, dynamic>> _replies = [
    {
      'id': '1',
      'author': 'Anonymous User',
      'content': 'I\'ve been through something similar. Feel free to reach out if you need someone to talk to.',
      'timestamp': '1 hour ago',
      'likes': 12,
      'isAnonymous': true,
    },
    {
      'id': '2',
      'author': 'Anonymous User',
      'content': 'Thank you for sharing your story. You\'re not alone in this.',
      'timestamp': '2 hours ago',
      'likes': 8,
      'isAnonymous': true,
    },
    {
      'id': '3',
      'author': 'Anonymous User',
      'content': 'I recommend checking out this resource: [link]. It helped me a lot.',
      'timestamp': '3 hours ago',
      'likes': 15,
      'isAnonymous': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post['likes'] as int;
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discussion',
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            onPressed: () {
              // Report post
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: responsive.getPadding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post content
                  GradientCard(
                    accentColor: AppColors.primaryPink,
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
                            widget.post['category'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryPink,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Title
                        Text(
                          widget.post['title'] as String,
                          style: TextStyle(
                            fontSize: responsive.getFontSize(20, 22, 24),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Author and timestamp
                        Row(
                          children: [
                            if (widget.post['isAnonymous'] as bool)
                              Icon(
                                Icons.visibility_off,
                                size: 16,
                                color: AppColors.grey,
                              ),
                            if (widget.post['isAnonymous'] as bool) const SizedBox(width: 4),
                            Text(
                              widget.post['author'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.post['timestamp'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Content
                        Text(
                          widget.post['content'] as String,
                          style: TextStyle(
                            fontSize: responsive.getFontSize(15, 16, 17),
                            color: AppColors.primaryDark,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Actions
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _isLiked ? Icons.favorite : Icons.favorite_border,
                                color: _isLiked ? AppColors.primaryPink : AppColors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isLiked = !_isLiked;
                                  _likeCount += _isLiked ? 1 : -1;
                                });
                              },
                            ),
                            Text(
                              _likeCount.toString(),
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.comment,
                              color: AppColors.primaryPurple,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _replies.length.toString(),
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(Icons.share, color: AppColors.primaryPurple),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Replies section
                  Text(
                    'Replies (${_replies.length})',
                    style: TextStyle(
                      fontSize: responsive.getFontSize(18, 20, 22),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Replies list
                  ..._replies.map((reply) => _buildReplyCard(reply, responsive)),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Reply input
          Container(
            padding: responsive.getPadding(),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: const InputDecoration(
                      hintText: 'Write a reply...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primaryPink),
                  onPressed: () {
                    if (_replyController.text.isNotEmpty) {
                      // Add reply
                      _replyController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyCard(Map<String, dynamic> reply, Responsive responsive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (reply['isAnonymous'] as bool)
                const Icon(
                  Icons.visibility_off,
                  size: 16,
                  color: AppColors.grey,
                ),
              if (reply['isAnonymous'] as bool) const SizedBox(width: 4),
              Text(
                reply['author'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                reply['timestamp'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reply['content'] as String,
            style: TextStyle(
              fontSize: responsive.getFontSize(14, 15, 16),
              color: AppColors.primaryDark,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border, size: 18),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                reply['likes'].toString(),
                style: const TextStyle(fontSize: 12, color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

