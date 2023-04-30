part of 'package:user/backend_processes/notifications_box.dart';

class Notification {

  NotificationType type;
  String title;
  String content;
  bool isNew = true;

  Notification({required this.type, required this.title, required this.content});

  void pickUp() {
    isNew = false;
  }
}

enum NotificationType {
  newKey,
  deleteKey,
}