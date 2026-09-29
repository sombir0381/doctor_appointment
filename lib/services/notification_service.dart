import '../models/notification.dart';

class NotificationService {
  static final List<AppNotification> _notifications = [
    AppNotification(
      id: 'notification_001',
      userId: 'patient_001',
      title: 'Appointment Confirmed',
      message:
      'Your appointment with Dr. Sarah Khan has been confirmed.',
      type: 'success',
      read: false,
      createdAt: DateTime.now().subtract(
        const Duration(minutes: 10),
      ),
    ),
    AppNotification(
      id: 'notification_002',
      userId: 'patient_001',
      title: 'Upcoming Appointment',
      message:
      'You have an appointment tomorrow at 10:30 AM.',
      type: 'appointment',
      read: false,
      createdAt: DateTime.now().subtract(
        const Duration(hours: 1),
      ),
    ),
    AppNotification(
      id: 'notification_003',
      userId: 'patient_001',
      title: 'Appointment Pending',
      message:
      'Your appointment request is waiting for confirmation.',
      type: 'pending',
      read: true,
      createdAt: DateTime.now().subtract(
        const Duration(hours: 3),
      ),
    ),
    AppNotification(
      id: 'notification_004',
      userId: 'patient_001',
      title: 'Appointment Cancelled',
      message:
      'Your appointment with Dr. John Smith was cancelled.',
      type: 'cancelled',
      read: true,
      createdAt: DateTime.now().subtract(
        const Duration(days: 1),
      ),
    ),
    AppNotification(
      id: 'notification_005',
      userId: 'patient_001',
      title: 'Appointment Completed',
      message:
      'Your appointment has been marked as completed.',
      type: 'completed',
      read: true,
      createdAt: DateTime.now().subtract(
        const Duration(days: 2),
      ),
    ),
  ];

  // ============================================================
  // GET NOTIFICATIONS
  // ============================================================

  static List<AppNotification> getNotifications(
      String userId,
      ) {
    return _notifications
        .where(
          (notification) =>
      notification.userId == userId,
    )
        .toList();
  }

  // ============================================================
  // GET UNREAD COUNT
  // ============================================================

  static int getUnreadCount(
      String userId,
      ) {
    return _notifications
        .where(
          (notification) =>
      notification.userId == userId &&
          !notification.read,
    )
        .length;
  }

  // ============================================================
  // MARK ONE AS READ
  // ============================================================

  static bool markAsRead(
      String notificationId,
      ) {
    final int index =
    _notifications.indexWhere(
          (notification) =>
      notification.id == notificationId,
    );

    if (index == -1) {
      return false;
    }

    final AppNotification oldNotification =
    _notifications[index];

    _notifications[index] =
        AppNotification(
          id: oldNotification.id,
          userId: oldNotification.userId,
          title: oldNotification.title,
          message: oldNotification.message,
          type: oldNotification.type,
          read: true,
          createdAt: oldNotification.createdAt,
        );

    return true;
  }

  // ============================================================
  // MARK ALL AS READ
  // ============================================================

  static void markAllAsRead(
      String userId,
      ) {
    for (int i = 0;
    i < _notifications.length;
    i++) {
      final AppNotification notification =
      _notifications[i];

      if (notification.userId != userId ||
          notification.read) {
        continue;
      }

      _notifications[i] =
          AppNotification(
            id: notification.id,
            userId: notification.userId,
            title: notification.title,
            message: notification.message,
            type: notification.type,
            read: true,
            createdAt: notification.createdAt,
          );
    }
  }
}