// lib/modules/legal/screens/ai_assistant_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../viewmodels/legal_provider.dart';
import '../../data/knowledge_base/legal_knowledge_base.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize provider and load chat history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LegalProvider>(context, listen: false);
      provider.initialize();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final provider = Provider.of<LegalProvider>(context, listen: false);
    final userMessage = _messageController.text.trim();
    _messageController.clear();
    _scrollToBottom();

    // Send message and get response
    final response = await provider.sendChatbotMessage(userMessage);
    
    if (!mounted) return;
    
    if (response == null && provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${provider.error}'),
          backgroundColor: AppColors.dangerColor,
        ),
      );
    }
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _clearChat() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text('Are you sure you want to clear all chat history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final provider = Provider.of<LegalProvider>(context, listen: false);
      await provider.clearChatHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'AI Legal Assistant',
        showLogo: true,
        showBackButton: true,
        backgroundColor: null,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
            tooltip: 'Clear chat history',
          ),
        ],
      ),
      body: Consumer<LegalProvider>(
        builder: (context, provider, _) {
          final messages = provider.chatHistory;
          final isLoading = provider.isChatbotResponding;

          // Show greeting if no messages
          if (messages.isEmpty) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(context.responsive(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: context.responsive(80),
                            height: context.responsive(80),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.accentPurple, AppColors.mediumPurple],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.smart_toy_rounded,
                              color: AppColors.white,
                              size: context.responsive(40),
                            ),
                          ),
                          SizedBox(height: context.responsive(24)),
                          Text(
                            LegalKnowledgeBase.getGreeting(),
                            style: AppTextStyles.bodyMedium1(context),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildInputBar(provider, isLoading),
              ],
            );
          }

          return Column(
            children: [
              // Chat Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(context.responsive(20)),
                  itemCount: messages.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length && isLoading) {
                      return _buildTypingIndicator();
                    }
                    final message = messages[index];
                    return _MessageBubble(
                      message: message.message,
                      response: message.response,
                      isUser: message.isUser,
                      timestamp: message.timestamp,
                    );
                  },
                ),
              ),

              // Input Bar
              _buildInputBar(provider, isLoading),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInputBar(LegalProvider provider, bool isLoading) {
    return Container(
      padding: EdgeInsets.all(context.responsive(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.1),
            blurRadius: context.responsive(10),
            offset: Offset(0, -context.responsive(5)),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(context.responsive(24)),
                  border: Border.all(
                    color: AppColors.accentPurple.withValues(alpha: 0.2),
                    width: context.responsive(1.5),
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    hintText: isLoading ? 'AI is typing...' : 'Ask a legal question...',
                    hintStyle: AppTextStyles.bodyMedium1(context).copyWith(
                      color: AppColors.primaryDark.withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.responsive(20),
                      vertical: context.responsive(12),
                    ),
                  ),
                  style: AppTextStyles.bodyMedium1(context).copyWith(
                    color: AppColors.primaryDark,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: isLoading ? null : (_) => _sendMessage(),
                ),
              ),
            ),
            SizedBox(width: context.responsive(12)),
            Container(
              width: context.responsive(52),
              height: context.responsive(52),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accentPurple, AppColors.mediumPurple],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPurple.withValues(alpha: 0.4),
                    blurRadius: context.responsive(10),
                    offset: Offset(0, context.responsive(4)),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isLoading ? null : _sendMessage,
                  borderRadius: BorderRadius.circular(context.responsive(26)),
                  child: isLoading
                      ? Padding(
                          padding: EdgeInsets.all(context.responsive(14)),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          color: AppColors.white,
                          size: context.responsive(24),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.only(bottom: context.responsive(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: context.responsive(36),
            height: context.responsive(36),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accentPurple, AppColors.mediumPurple],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy_rounded,
              color: AppColors.white,
              size: context.responsive(20),
            ),
          ),
          SizedBox(width: context.responsive(8)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsive(18),
              vertical: context.responsive(14),
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.responsive(20)),
                topRight: Radius.circular(context.responsive(20)),
                bottomLeft: Radius.circular(context.responsive(4)),
                bottomRight: Radius.circular(context.responsive(20)),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.1),
                  blurRadius: context.responsive(10),
                  offset: Offset(0, context.responsive(4)),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                SizedBox(width: context.responsive(4)),
                _buildDot(1),
                SizedBox(width: context.responsive(4)),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animatedValue = ((value + delay) % 1.0);
        return Container(
          width: context.responsive(8),
          height: context.responsive(8),
          decoration: BoxDecoration(
            color: AppColors.accentPurple.withValues(
              alpha: 0.3 + (animatedValue * 0.7),
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final String? response;
  final bool isUser;
  final DateTime timestamp;

  const _MessageBubble({
    required this.message,
    this.response,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final text = isUser ? message : (response ?? message);
    
    return Padding(
      padding: EdgeInsets.only(bottom: context.responsive(16)),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: context.responsive(36),
              height: context.responsive(36),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accentPurple, AppColors.mediumPurple],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                color: AppColors.white,
                size: context.responsive(20),
              ),
            ),
            SizedBox(width: context.responsive(8)),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsive(18),
                vertical: context.responsive(14),
              ),
              decoration: BoxDecoration(
                gradient: isUser
                    ? LinearGradient(
                        colors: [AppColors.accentPurple, AppColors.mediumPurple],
                      )
                    : null,
                color: isUser ? null : AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.responsive(20)),
                  topRight: Radius.circular(context.responsive(20)),
                  bottomLeft: Radius.circular(isUser ? context.responsive(20) : context.responsive(4)),
                  bottomRight: Radius.circular(isUser ? context.responsive(4) : context.responsive(20)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isUser ? AppColors.accentPurple : AppColors.primaryDark)
                        .withValues(alpha: 0.1),
                    blurRadius: context.responsive(10),
                    offset: Offset(0, context.responsive(4)),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    text,
                    style: AppTextStyles.bodyMedium1(context).copyWith(
                      color: isUser ? AppColors.white : AppColors.primaryDark,
                      fontSize: context.responsive(15),
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: context.responsive(4)),
                  Text(
                    _formatTime(timestamp),
                    style: AppTextStyles.bodySmall1(context).copyWith(
                      color: isUser
                          ? AppColors.white.withValues(alpha: 0.7)
                          : AppColors.primaryDark.withValues(alpha: 0.5),
                      fontSize: context.responsive(11),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: context.responsive(8)),
            Container(
              width: context.responsive(36),
              height: context.responsive(36),
              decoration: BoxDecoration(
                color: AppColors.lightPink,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                color: AppColors.white,
                size: context.responsive(20),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
