part of 'package:user/backend_processes/notifications_box.dart';

class UpdateNotification {

  NotificationType type;
  String content;
  bool isNew = true;

  UpdateNotification({required this.type, required this.content});

  void pickUp() {
    isNew = false;
  }
}

enum NotificationType {
  newKey,
  deleteKey,
}