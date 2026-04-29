import 'package:flutter/material.dart';
import '../../core/services/notification_service.dart';

class NotificationBadge extends StatefulWidget {
  final Widget child;
  final int? count;

  const NotificationBadge({
    super.key,
    required this.child,
    this.count,
  });

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.addListener(_onNotificationChanged);
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onNotificationChanged);
    super.dispose();
  }

  void _onNotificationChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = widget.count ?? _notificationService.unreadCount;

    if (unreadCount <= 0) {
      return widget.child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        Positioned(
          right: 2,
          top: 2,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: unreadCount > 9 ? 4 : 5,
              vertical: 2,
            ),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(
              minWidth: unreadCount > 9 ? 20 : 18,
              minHeight: 18,
              maxWidth: unreadCount > 99 ? 28 : 32,
              maxHeight: 18,
            ),
            child: Center(
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: unreadCount > 99 ? 8 : 9,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
