import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/navigation/route_paths.dart';
import '../../../chat/presentation/providers/chat_provider.dart';
import '../../../chat/domain/entities/chat_thread.dart';
import '../../../chat/presentation/pages/chat_screen_page.dart';

class ChatMessagesWidget extends StatelessWidget {
  const ChatMessagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }

    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        return StreamBuilder<List<ChatThread>>(
          stream: chatProvider.watchChatsForCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingCard(context);
            }

            if (snapshot.hasError) {
              return _buildErrorCard(context, snapshot.error.toString());
            }

            final chats = snapshot.data ?? [];
            
            if (chats.isEmpty) {
              return _buildEmptyCard(context);
            }

            // Show top 3 recent chats
            final recentChats = chats.take(3).toList();

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
              ),
              margin: EdgeInsets.all(ThemeHelper.spacingL(context)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryPink,
                          AppColors.accentPink,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ThemeHelper.radiusL),
                        topRight: Radius.circular(ThemeHelper.radiusL),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ThemeHelper.spacingS(context)),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: ThemeHelper.spacingM(context)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recent Messages',
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${chats.length} conversation${chats.length != 1 ? 's' : ''}',
                                style: AppTextStyles.bodySmall1(context).copyWith(
                                  color: AppColors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(RoutePaths.chatList);
                          },
                          child: Text(
                            'View All',
                            style: AppTextStyles.bodySmall1(context).copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Chat List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                    itemCount: recentChats.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: AppColors.lightGrey,
                    ),
                    itemBuilder: (context, index) {
                      final chat = recentChats[index];
                      return _buildChatItem(context, chat, currentUser.uid);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChatItem(BuildContext context, ChatThread chat, String currentUserId) {
    // Get the other participant's ID
    final otherParticipantId = chat.participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => chat.participants.isNotEmpty ? chat.participants.first : '',
    );

    // Get participant name
    final participantName = chat.nameFor(otherParticipantId) ?? 'Unknown User';
    final avatarUrl = chat.avatarFor(otherParticipantId);

    // Get unread count
    final unreadCount = chat.unreadFor(currentUserId);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatScreenPage(chat: chat),
          ),
        );
      },
      borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ThemeHelper.spacingS(context),
          horizontal: ThemeHelper.spacingS(context),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: context.responsive(24),
              backgroundColor: AppColors.primaryPink.withValues(alpha: 0.2),
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
              child: avatarUrl == null
                  ? Text(
                      participantName.isNotEmpty ? participantName[0].toUpperCase() : '?',
                      style: AppTextStyles.bodyMedium1(context).copyWith(
                        color: AppColors.primaryPink,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: ThemeHelper.spacingM(context)),
            // Chat Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          participantName,
                          style: AppTextStyles.bodyMedium1(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ThemeHelper.spacingXS(context),
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPink,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unreadCount > 9 ? '9+' : '$unreadCount',
                            style: AppTextStyles.caption1(context).copyWith(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: ThemeHelper.spacingXS(context) / 2),
                  Text(
                    chat.lastMessage,
                    style: AppTextStyles.bodySmall1(context).copyWith(
                      color: AppColors.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: ThemeHelper.spacingS(context)),
            // Time
            Text(
              _formatTime(chat.updatedAt),
              style: AppTextStyles.bodySmall1(context).copyWith(
                color: AppColors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
      ),
      margin: EdgeInsets.all(ThemeHelper.spacingL(context)),
      child: Container(
        padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
      ),
      margin: EdgeInsets.all(ThemeHelper.spacingL(context)),
      child: Container(
        padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.dangerColor,
              size: context.responsive(32),
            ),
            SizedBox(height: ThemeHelper.spacingS(context)),
            Text(
              'Error loading messages',
              style: AppTextStyles.bodyMedium1(context),
            ),
            SizedBox(height: ThemeHelper.spacingXS(context)),
            Text(
              error,
              style: AppTextStyles.bodySmall1(context).copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
      ),
      margin: EdgeInsets.all(ThemeHelper.spacingL(context)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(RoutePaths.chatList);
        },
        borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
        child: Container(
          padding: EdgeInsets.all(ThemeHelper.spacingXL(context)),
          child: Column(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: context.responsive(48),
                color: AppColors.grey,
              ),
              SizedBox(height: ThemeHelper.spacingM(context)),
              Text(
                'No messages yet',
                style: AppTextStyles.heading4(context),
              ),
              SizedBox(height: ThemeHelper.spacingS(context)),
              Text(
                'Start a conversation with someone',
                style: AppTextStyles.bodySmall1(context).copyWith(
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ThemeHelper.spacingM(context)),
              ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(RoutePaths.chatList);
              },
                icon: const Icon(Icons.add),
                label: const Text('New Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink,
                  foregroundColor: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Today - show time
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}

