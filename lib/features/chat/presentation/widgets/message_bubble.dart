import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../contents/colors.dart';
import '../../domain/entities/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;
  final String timeLabel;
  final Responsive responsive;

  const MessageBubble({
    super.key,
    required this.message,
    required this.responsive,
    required this.isMine,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryLightPink,
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isMine
                    ? AppColors.buttonGradient
                    : LinearGradient(
                        colors: [
                          AppColors.surface,
                          AppColors.surfaceVariant,
                        ],
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMine ? 16 : 4),
                  bottomRight: Radius.circular(isMine ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.replyToText != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMine
                            ? AppColors.white.withValues(alpha: 0.15)
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message.replyToText!,
                        style: TextStyle(
                          fontSize: responsive.getFontSize(12, 13, 14),
                          color: isMine
                              ? AppColors.white.withValues(alpha: 0.9)
                              : AppColors.primaryDark,
                        ),
                      ),
                    ),
                  if (message.imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          message.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 140,
                            color: AppColors.lightGrey,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    ),
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: responsive.getFontSize(14, 15, 16),
                      color: isMine ? AppColors.white : AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeLabel,
                        style: TextStyle(
                          fontSize: responsive.getFontSize(10, 11, 12),
                          color: isMine
                              ? AppColors.white.withValues(alpha: 0.8)
                              : AppColors.grey,
                        ),
                      ),
                      if (isMine) ...[
                        const SizedBox(width: 6),
                        _StatusIcon(status: message.status),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final ChatMessageStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.done;
    Color color = AppColors.white.withValues(alpha: 0.8);

    switch (status) {
      case ChatMessageStatus.sending:
        icon = Icons.schedule;
        color = AppColors.white.withValues(alpha: 0.7);
        break;
      case ChatMessageStatus.sent:
        icon = Icons.done;
        break;
      case ChatMessageStatus.delivered:
        icon = Icons.done_all;
        color = AppColors.white.withValues(alpha: 0.8);
        break;
      case ChatMessageStatus.read:
        icon = Icons.done_all;
        color = AppColors.success;
        break;
    }

    return Icon(icon, size: 16, color: color);
  }
}