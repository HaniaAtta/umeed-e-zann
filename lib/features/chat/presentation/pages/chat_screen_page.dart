import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../../../contents/colors.dart';
import '../../../../core/responsive/responsive.dart';
import '../../domain/entities/chat_thread.dart';
import '../../domain/entities/chat_message.dart';
import '../providers/chat_provider.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../widgets/message_bubble.dart';

class ChatScreenPage extends StatelessWidget {
  final ChatThread chat;

  const ChatScreenPage({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final myId = FirebaseAuth.instance.currentUser?.uid;
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    // Initialize on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatProvider.markAsRead(chat.id);
      if (myId != null) {
        chatProvider.loadParticipantInfo(chat, myId);
      }
    });

    return Consumer<ChatProvider>(
      builder: (context, provider, _) => Scaffold(
        appBar: CustomAppBar(
          title: provider.peerName ?? 'Chat',
          showBackButton: true,
          showLogo: false,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline, color: AppColors.white),
              onPressed: () {},
            ),
          ],
        ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: chatProvider.watchMessages(chat.id),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Start the conversation!'),
                  );
                }

                return ListView.builder(
                  padding: responsive.getPadding(),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMine = message.senderId == myId;
                    return Column(
                      key: ValueKey(message.id),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_shouldShowDateHeader(messages, index))
                          _DateHeader(
                            label: _dateLabelFor(messages[index].createdAt, context),
                            responsive: responsive,
                          ),
                        MessageBubble(
                          message: message,
                          responsive: responsive,
                          isMine: isMine,
                          timeLabel: _formatTime(context, message.createdAt),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _MessageInput(chatId: chat.id, responsive: responsive),
        ],
      ),
      ),
    );
  }

  bool _shouldShowDateHeader(List<ChatMessage> messages, int index) {
    if (index == 0) return true;
    final prev = messages[index - 1].createdAt;
    final current = messages[index].createdAt;
    return prev.day != current.day ||
        prev.month != current.month ||
        prev.year != current.year;
  }

  String _dateLabelFor(DateTime time, BuildContext context) {
    final today = DateTime.now();
    final diff = today.difference(DateTime(time.year, time.month, time.day));
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${time.day}/${time.month}/${time.year}';
  }

  String _formatTime(BuildContext context, DateTime time) {
    final timeOfDay = TimeOfDay.fromDateTime(time);
    return timeOfDay.format(context);
  }
}

class _MessageInput extends StatefulWidget {
  final String chatId;
  final Responsive responsive;

  const _MessageInput({
    required this.chatId,
    required this.responsive,
  });

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final List<String> _smartReplies = const [
    'Sounds great!',
    'Can you share photos?',
    'When can you deliver?',
    'What is the price?',
  ];

  void _sendMessage({String? preset}) {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    final text = preset ?? provider.messageController.text.trim();
    if (text.isEmpty) return;

    provider.sendMessage(chatId: widget.chatId, text: text);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, _) => Column(
        children: [
          if (provider.showEmojiPicker) _buildEmojiPicker(provider),
          if (_smartReplies.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: AppColors.surface,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _smartReplies
                      .map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(r),
                            selected: false,
                            backgroundColor: AppColors.white,
                            labelStyle: TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: widget.responsive.getFontSize(12, 13, 14),
                            ),
                            shape: StadiumBorder(
                              side: BorderSide(color: AppColors.lightGrey),
                            ),
                            onSelected: (_) => _sendMessage(preset: r),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          Container(
            padding: widget.responsive.getPadding(),
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
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.primaryDark),
                    onPressed: () => _showAttachmentSheet(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: provider.messageController,
                      focusNode: provider.focusNode,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Type a message…',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: AppColors.lightGrey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: AppColors.lightGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: AppColors.primaryPink, width: 2),
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(
                            provider.showEmojiPicker
                                ? Icons.keyboard
                                : Icons.emoji_emotions_outlined,
                            color: AppColors.primaryPink,
                          ),
                          onPressed: () {
                            provider.toggleEmojiPicker();
                          },
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _sendMessage();
                        }
                      },
                      onTap: () {
                        if (provider.showEmojiPicker) {
                          provider.setEmojiPicker(false);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: AppColors.white),
                      onPressed: () {
                        if (provider.messageController.text.trim().isNotEmpty) {
                          _sendMessage();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker(ChatProvider provider) {
    const commonEmojis = [
      '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃',
      '😉', '😊', '😇', '🥰', '😍', '🤩', '😘', '😗', '😚', '😙',
      '😋', '😛', '😜', '🤪', '😝', '🤑', '🤗', '🤭', '🤫', '🤔',
      '🤐', '🤨', '😐', '😑', '😶', '😏', '😒', '🙄', '😬', '🤥',
      '😌', '😔', '😪', '🤤', '😴', '😷', '🤒', '🤕', '🤢', '🤮',
      '👍', '👎', '👌', '✌️', '🤞', '🤟', '🤘', '👏', '🙌', '👐',
      '💪', '🙏', '✍️', '💅', '🤳', '💃', '🕺', '👯', '👶', '👧',
      '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💔',
    ];

    return Container(
      height: 250,
      color: AppColors.surface,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: 1,
        ),
        itemCount: commonEmojis.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              final provider = Provider.of<ChatProvider>(context, listen: false);
              provider.insertEmoji(commonEmojis[index]);
            },
            child: Center(
              child: Text(
                commonEmojis[index],
                style: const TextStyle(fontSize: 28),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAttachmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AttachmentButton(
                icon: Icons.photo_camera,
                label: 'Camera',
                onTap: () => Navigator.pop(context),
              ),
              _AttachmentButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () => Navigator.pop(context),
              ),
              _AttachmentButton(
                icon: Icons.insert_drive_file,
                label: 'Document',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  final Responsive responsive;

  const _DateHeader({
    required this.label,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.lightGrey,
              thickness: 1,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
                fontSize: responsive.getFontSize(12, 13, 14),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColors.lightGrey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AttachmentButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primaryLightPink,
          child: IconButton(
            icon: Icon(icon, color: AppColors.primaryDark),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

