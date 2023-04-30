part 'package:user/objects/notification.dart';

NotificationsBox notificationsBox = NotificationsBox();

class NotificationsBox {

  final List<Notification> _notifications = List.empty(growable: true);


  bool hasNotifications() {
    return _notifications.isNotEmpty;
  }

  int getNumNotifications() {
    return _notifications.length;
  }

  Notification getNotificationByIndex(int index) {
    return _notifications[_notifications.length - index - 1];
  }

  void addNotification(final Notification newNotification) {
    _notifications.add(newNotification);
  }

  void clear() {
    _notifications.clear();
  }
}