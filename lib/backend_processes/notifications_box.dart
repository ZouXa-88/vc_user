part 'package:user/objects/update_notification.dart';

NotificationsBox notificationsBox = NotificationsBox();

class NotificationsBox {

  final List<UpdateNotification> _notifications = List.empty(growable: true);
  late DateTime _lastModifiedTime;


  NotificationsBox() {
    _updateModifiedTime();
  }

  List<UpdateNotification> getAllNotifications() {
    return _notifications;
  }

  void addNotification(final UpdateNotification newNotification) {
    _notifications.add(newNotification);
    _updateModifiedTime();
  }

  void clear() {
    _notifications.clear();
    _updateModifiedTime();
  }

  DateTime getLastModifiedTime() {
    return _lastModifiedTime;
  }

  void _updateModifiedTime() {
    _lastModifiedTime = DateTime.now();
  }
}