import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../contents/colors.dart';
import '../../domain/entities/chat_thread.dart';
import '../providers/chat_provider.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import 'chat_screen_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final me = FirebaseAuth.instance.currentUser;
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return Scaffold(
      drawer: const SideDrawer(currentModule: null),
      appBar: const CustomAppBar(
        title: 'Messages',
        showBackButton: false,
        showLogo: true,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewChatDialog(context, chatProvider),
        backgroundColor: AppColors.primaryPink,
        icon: const Icon(Icons.chat, color: AppColors.white),
        label: const Text(
          'New Chat',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder<List<ChatThread>>(
        stream: chatProvider.watchChatsForCurrentUser(),
        builder: (context, snapshot) {
          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.dangerColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading conversations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(color: AppColors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final chats = snapshot.data ?? [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chats.isEmpty) {
            return Column(
              children: [
                const Expanded(
                  child: EmptyState(
                    message: 'No messages yet\nStart a new conversation!',
                    icon: Icons.chat_bubble_outline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showNewChatDialog(context, chatProvider),
                      icon: const Icon(Icons.add),
                      label: const Text('Start New Chat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPink,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return _ChatItem(
                chat: chats[index],
                myId: me?.uid,
                responsive: responsive,
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showNewChatDialog(
    BuildContext context,
    ChatProvider chatProvider,
  ) async {
    final emailOrPhoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Consumer<ChatProvider>(
            builder: (context, provider, _) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_add, color: AppColors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'New Chat',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter email or phone number to start a conversation',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailOrPhoneController,
                      decoration: InputDecoration(
                        labelText: 'Email or Phone Number',
                        hintText: 'user@example.com or +1234567890',
                        prefixIcon: const Icon(Icons.search, color: AppColors.primaryPink),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.lightGrey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.lightGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.primaryPink, width: 2),
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an email or phone number';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (formKey.currentState!.validate() && !provider.isLoading) {
                          _startChat(context, emailOrPhoneController.text.trim(), provider);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: provider.isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.grey)),
                ),
                ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            _startChat(context, emailOrPhoneController.text.trim(), provider);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                          ),
                        )
                      : const Text('Start Chat'),
                ),
              ],
            ),
          );
        },
      ),
    );

    emailOrPhoneController.dispose();
  }

  Future<void> _startChat(
    BuildContext context,
    String emailOrPhone,
    ChatProvider chatProvider,
  ) async {
    final chatId = await chatProvider.startChatByContact(emailOrPhone);

    if (!context.mounted) return;

    if (chatId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(chatProvider.error ?? 'Failed to start chat'),
            backgroundColor: AppColors.dangerColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
      return;
    }

    final chat = await chatProvider.getChatThread(chatId);

    if (!context.mounted) return;

    if (chat == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chat created but could not be loaded. Please refresh.'),
            backgroundColor: AppColors.dangerColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    Navigator.of(context).pop(); // Close dialog

    if (!context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (navContext) => ChatScreenPage(chat: chat),
      ),
    );
  }
}

class _ChatItem extends StatelessWidget {
  final ChatThread chat;
  final String? myId;
  final Responsive responsive;

  const _ChatItem({
    required this.chat,
    required this.myId,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final peerId = chat.participants.firstWhere(
      (id) => id != myId,
      orElse: () => chat.participants.first,
    );
    final name = chat.nameFor(peerId) ?? 'Conversation';
    final avatar = chat.avatarFor(peerId);
    final unread = chat.unreadFor(myId ?? '');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreenPage(chat: chat),
          ),
        );
      },
      child: Container(
        padding: responsive.getPadding(
          mobile: const EdgeInsets.all(16),
          tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lightGrey, width: 1),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: responsive.getWidth(28, 32, 36),
                  backgroundColor: AppColors.primaryLightPink,
                  backgroundImage: avatar != null ? NetworkImage(avatar) : null,
                  child: avatar == null
                      ? const Icon(
                          Icons.person,
                          color: AppColors.white,
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: responsive.getFontSize(16, 17, 18),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage.isNotEmpty
                              ? chat.lastMessage
                              : 'Say hello 👋',
                          style: TextStyle(
                            fontSize: responsive.getFontSize(14, 15, 16),
                            color: AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unread > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$unread',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _timeAgo(chat.updatedAt),
              style: TextStyle(
                fontSize: responsive.getFontSize(12, 13, 14),
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${time.day}/${time.month}';
  }
}

