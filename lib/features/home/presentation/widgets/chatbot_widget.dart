import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../legal/presentation/viewmodels/legal_provider.dart';
import '../../../legal/domain/entities/chat_message_entity.dart';

class ChatbotWidget extends StatefulWidget {
  const ChatbotWidget({super.key});

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends State<ChatbotWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize legal provider chat history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    if (!mounted) return;
    
    final provider = Provider.of<LegalProvider>(context, listen: false);
    if (!_isInitialized) {
      await provider.initialize();
      _isInitialized = true;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    // Check if user is logged in using FirebaseAuth directly
    // since LegalProvider._userId is private
    // final user = FirebaseAuth.instance.currentUser;
    // if (user == null) { ... } 
    // actually, let's rely on the provider's error handling which checks for null user
    
    final messageText = _messageController.text.trim();
    _messageController.clear();
    _scrollToBottom();

    // Initialize if not done
    if (!_isInitialized) {
      await _initializeChat();
    }

    if (!mounted) return;
    
    final provider = Provider.of<LegalProvider>(context, listen: false);
    
    // Send message to legal chatbot
    final response = await provider.sendChatbotMessage(messageText);
    
    if (!mounted) return;

    if (response == null && provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error!),
          backgroundColor: AppColors.dangerColor,
        ),
      );
    }
    
    // Scroll to bottom after a delay to allow UI to update
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _scrollToBottom();
        }
      });
    }
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

  @override
  Widget build(BuildContext context) {
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
                  AppColors.mediumPurple,
                  AppColors.mediumBluePurple,
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
                    Icons.smart_toy,
                    color: AppColors.lightText,
                    size: 24,
                  ),
                ),
                SizedBox(width: ThemeHelper.spacingM(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Assistant',
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          color: AppColors.lightText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ask me anything!',
                        style: AppTextStyles.bodySmall1(context).copyWith(
                          color: AppColors.lightText.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Messages
          Container(
            constraints: BoxConstraints(
              maxHeight: context.responsive(300),
            ),
            child: Consumer<LegalProvider>(
              builder: (context, provider, child) {
                final messages = provider.chatHistory;
                final isLoading = provider.isChatbotResponding;
                
                // Show welcome message if no chat history
                if (messages.isEmpty && !isLoading) {
                  return Padding(
                    padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                    child: Center(
                      child: Text(
                        'Hello! I\'m your AI Legal Assistant. Ask me about Pakistan Constitution, legal rights, or any legal questions!',
                        style: AppTextStyles.bodyMedium1(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                  shrinkWrap: true,
                  itemCount: messages.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < messages.length) {
                      return _buildMessageFromEntity(messages[index]);
                    } else {
                      // Loading indicator
                      return Padding(
                        padding: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(ThemeHelper.spacingS(context)),
                              decoration: BoxDecoration(
                                color: AppColors.mediumPurple.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.smart_toy,
                                size: context.responsive(20),
                                color: AppColors.mediumPurple,
                              ),
                            ),
                            SizedBox(width: ThemeHelper.spacingS(context)),
                            Container(
                              padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(ThemeHelper.radiusM),
                                  topRight: Radius.circular(ThemeHelper.radiusM),
                                  bottomRight: Radius.circular(ThemeHelper.radiusM),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.mediumPurple,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: ThemeHelper.spacingS(context)),
                                  Text(
                                    'Thinking...',
                                    style: AppTextStyles.bodySmall1(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          // Input
          Container(
            padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(ThemeHelper.radiusL),
                bottomRight: Radius.circular(ThemeHelper.radiusL),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: AppTextStyles.bodySmall1(context).copyWith(
                        color: AppColors.grey,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ThemeHelper.radiusM),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ThemeHelper.spacingM(context),
                        vertical: ThemeHelper.spacingS(context),
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: ThemeHelper.spacingS(context)),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.mediumPurple,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.lightText,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageFromEntity(ChatMessageEntity message) {
    final isUser = message.isUser;
    return Padding(
      padding: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: EdgeInsets.all(ThemeHelper.spacingS(context)),
              decoration: BoxDecoration(
                color: AppColors.mediumPurple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy,
                size: context.responsive(20),
                color: AppColors.mediumPurple,
              ),
            ),
            SizedBox(width: ThemeHelper.spacingS(context)),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(ThemeHelper.spacingM(context)),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.mediumPurple
                    : AppColors.lightGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ThemeHelper.radiusM),
                  topRight: Radius.circular(ThemeHelper.radiusM),
                  bottomLeft: Radius.circular(
                    isUser ? ThemeHelper.radiusM : 0,
                  ),
                  bottomRight: Radius.circular(
                    isUser ? 0 : ThemeHelper.radiusM,
                  ),
                ),
              ),
              child: Text(
                message.message,
                style: AppTextStyles.bodySmall1(context).copyWith(
                  color: isUser
                      ? AppColors.lightText
                      : AppColors.primaryText,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: ThemeHelper.spacingS(context)),
            Container(
              padding: EdgeInsets.all(ThemeHelper.spacingS(context)),
              decoration: BoxDecoration(
                color: AppColors.mediumPurple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: context.responsive(20),
                color: AppColors.mediumPurple,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
