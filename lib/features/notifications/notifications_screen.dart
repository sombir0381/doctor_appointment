import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/notification.dart';
import '../../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  static const String patientId =
      'patient_001';

  List<AppNotification> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // ============================================================
  // LOAD NOTIFICATIONS
  // ============================================================

  void _loadNotifications() {
    notifications =
        NotificationService.getNotifications(
          patientId,
        );
  }

  // ============================================================
  // MARK ONE AS READ
  // ============================================================

  void markAsRead(
      String notificationId,
      ) {
    final bool updated =
    NotificationService.markAsRead(
      notificationId,
    );

    if (!updated) {
      return;
    }

    setState(() {
      _loadNotifications();
    });
  }

  // ============================================================
  // MARK ALL AS READ
  // ============================================================

  void markAllAsRead() {
    NotificationService.markAllAsRead(
      patientId,
    );

    setState(() {
      _loadNotifications();
    });
  }

  // ============================================================
  // UNREAD COUNT
  // ============================================================

  int get unreadCount {
    return NotificationService.getUnreadCount(
      patientId,
    );
  }

  // ============================================================
  // TIME FORMAT
  // ============================================================

  String _formatTime(
      DateTime createdAt,
      ) {
    final Duration difference =
    DateTime.now().difference(
      createdAt,
    );

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    return '${difference.inDays} days ago';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: markAllAsRead,
              child: const Text(
                'Mark all read',
              ),
            ),
        ],
      ),

      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding:
        const EdgeInsets.all(16),
        itemCount:
        notifications.length,
        itemBuilder:
            (context, index) {
          final AppNotification
          notification =
          notifications[index];

          return _buildNotificationCard(
            notification,
          );
        },
      ),
    );
  }

  // ============================================================
  // NOTIFICATION CARD
  // ============================================================

  Widget _buildNotificationCard(
      AppNotification notification,
      ) {
    final bool isRead =
        notification.read;

    return GestureDetector(
      onTap: () {
        markAsRead(
          notification.id,
        );
      },
      child: Container(
        margin:
        const EdgeInsets.only(
          bottom: 12,
        ),
        padding:
        const EdgeInsets.all(16),
        decoration:
        BoxDecoration(
          color: isRead
              ? Colors.white
              : AppTheme.primaryColor
              .withOpacity(0.06),
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: isRead
                ? Colors.transparent
                : AppTheme.primaryColor
                .withOpacity(0.15),
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _buildNotificationIcon(
              notification.type,
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style:
                          const TextStyle(
                            fontSize: 15,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ),

                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration:
                          const BoxDecoration(
                            color: AppTheme
                                .primaryColor,
                            shape:
                            BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppTheme
                          .secondaryTextColor,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    _formatTime(
                      notification.createdAt,
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme
                          .secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NOTIFICATION ICON
  // ============================================================

  Widget _buildNotificationIcon(
      String type,
      ) {
    late IconData icon;
    late Color iconColor;

    switch (type) {
      case 'success':
        icon =
            Icons.check_circle_outline_rounded;
        iconColor = Colors.green;
        break;

      case 'appointment':
        icon =
            Icons.calendar_today_outlined;
        iconColor =
            AppTheme.primaryColor;
        break;

      case 'pending':
        icon = Icons.access_time_rounded;
        iconColor = Colors.orange;
        break;

      case 'cancelled':
        icon = Icons.cancel_outlined;
        iconColor = Colors.red;
        break;

      case 'completed':
        icon = Icons.task_alt_rounded;
        iconColor = Colors.teal;
        break;

      default:
        icon =
            Icons.notifications_outlined;
        iconColor =
            AppTheme.primaryColor;
    }

    return Container(
      width: 48,
      height: 48,
      decoration:
      BoxDecoration(
        color:
        iconColor.withOpacity(0.1),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 25,
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration:
              BoxDecoration(
                color: AppTheme
                    .primaryColor
                    .withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons
                    .notifications_none_rounded,
                size: 45,
                color:
                AppTheme.primaryColor,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'You are all caught up!',
              style: TextStyle(
                color: AppTheme
                    .secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}