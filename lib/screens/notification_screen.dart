import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:user/modules/app_theme.dart';
import 'package:user/backend_processes/notifications_box.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          "通知",
          style: TextStyle(
            letterSpacing: 3,
          ),
        ),
      ),
      body: notificationsBox.hasNotifications()
      ? Scrollbar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: notificationsBox.getNumNotifications(),
            itemBuilder: (context, index) {
              final notification = notificationsBox.getNotificationByIndex(index);
              return Card(
                child: ExpansionTile(
                  title: Text(notification.title),
                  subtitle: notification.isNew
                      ? const Text(
                        "新訊息",
                        style: TextStyle(color: Colors.redAccent),
                      )
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  childrenPadding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    Text(
                      notification.content,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                  onExpansionChanged: (isExpanded) {
                    if(isExpanded && notification.isNew){
                      setState(() {
                        notification.pickUp();
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),
      )
      : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: Lottie.asset(
                "assets/lotties/empty_box.json",
                width: 100,
                height: 100,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "無通知",
                style: TextStyle(
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}