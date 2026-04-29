import 'package:flutter/material.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../app.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.addListener(_onNotificationsChanged);
    // Load notifications from Firestore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.loadNotifications();
    });
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onNotificationsChanged);
    super.dispose();
  }

  void _onNotificationsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _notificationService.notifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: null),
      appBar: const CustomAppBar(
        title: 'Notifications',
        showLogo: true,
        showBackButton: false,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: context.responsive(80),
                    color: AppColors.grey,
                  ),
                  SizedBox(height: ThemeHelper.spacingL(context)),
                  Text(
                    'No Notifications',
                    style: AppTextStyles.heading3(context).copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  SizedBox(height: ThemeHelper.spacingS(context)),
                  Text(
                    'You\'re all caught up!',
                    style: AppTextStyles.bodyMedium1(context).copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ThemeHelper.spacingL(context)),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(notification.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: ThemeHelper.spacingL(context)),
                    decoration: BoxDecoration(
                      color: AppColors.dangerColor,
                      borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: AppColors.lightText,
                      size: 28,
                    ),
                  ),
                  onDismissed: (direction) {
                    _notificationService.removeNotification(notification.id);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Notification deleted'),
                          backgroundColor: AppColors.mediumPurple,
                        ),
                      );
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: ThemeHelper.spacingM(context)),
                    elevation: notification.isRead ? 1 : 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ThemeHelper.radiusL),
                    ),
                    color: AppColors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: notification.isRead
                                ? Colors.transparent
                                : notification.color,
                            width: context.responsive(4),
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(context.responsive(10)),
                          decoration: BoxDecoration(
                            color: notification.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(context.responsive(12)),
                          ),
                          child: Icon(
                            notification.icon,
                            color: notification.color,
                            size: context.responsive(24),
                          ),
                        ),
                        title: Text(
                          notification.title,
                          style: AppTextStyles.bodyMedium1(context).copyWith(
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: context.responsive(4)),
                            Text(
                              notification.message,
                              style: AppTextStyles.bodySmall1(context).copyWith(
                                color: AppColors.primaryDark.withValues(alpha: 0.8),
                              ),
                            ),
                            SizedBox(height: context.responsive(4)),
                            Text(
                              notification.time,
                              style: AppTextStyles.caption1(context).copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        onTap: () async {
                          // Store navigation info before async
                          final notificationType = notification.title.toLowerCase();
                          final navigator = Navigator.of(context);
                          final app = App.of(context);
                          
                          // Mark as read
                          if (!notification.isRead) {
                            await _notificationService.markAsRead(notification.id);
                          }
                          
                          // Navigate based on notification type
                          if (!mounted) return;
                          
                          if (notificationType.contains('sos') || notificationType.contains('safety')) {
                            navigator.pushNamed(AppRouter.safety);
                          } else if (notificationType.contains('course')) {
                            app?.changeTab(3);
                          } else if (notificationType.contains('cycle') || notificationType.contains('appointment')) {
                            app?.changeTab(2);
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
