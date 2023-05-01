import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:user/modules/app_theme.dart';
import 'package:user/backend_processes/notifications_box.dart';
import 'package:user/widgets/toggle_switch.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {

  int _switchBarIndex = 0;

  late Timer _trackNewNotificationTimer;
  late DateTime _lastModifiedTime;
  List<UpdateNotification> _notifications = List.empty();

  
  List<UpdateNotification> _filterNotifications(List<UpdateNotification> notifications) {
    switch(_switchBarIndex){
      case 1:
        return <UpdateNotification> [
          for(UpdateNotification notification in notifications) ...[
            if(notification.type == NotificationType.newKey) ...[
              notification
            ]
          ]
        ];
      case 2:
        return <UpdateNotification> [
          for(UpdateNotification notification in notifications) ...[
            if(notification.type == NotificationType.deleteKey) ...[
              notification
            ]
          ]
        ];
      default:
        return notifications;
    }
  }

  @override
  void initState() {
    _getNotifications();
    _trackNewNotificationTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if(_lastModifiedTime != notificationsBox.getLastModifiedTime()){
          _getNotifications();
        }
      },
    );
    super.initState();
  }

  void _getNotifications() {
    setState(() {
      _lastModifiedTime = notificationsBox.getLastModifiedTime();
      _notifications = notificationsBox.getAllNotifications();
    });
  }

  @override
  void dispose() {
    _trackNewNotificationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _filterNotifications(_notifications);
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
      body: notifications.isNotEmpty
        ? Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: ToggleSwitch(
              width: MediaQuery.of(context).size.width * 0.75,
              initialIndex: _switchBarIndex,
              options: const [
                "全部",
                "新增門鎖",
                "刪除門鎖",
              ],
              onChange: (index) {
                setState(() {
                  _switchBarIndex = index;
                });
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  // Latest notification first.
                  final notification = notifications[notifications.length - index - 1];
                  return Card(
                    child: ExpansionTile(
                      leading: notification.isNew 
                          ? const Text("新訊息", style: TextStyle(color: Colors.redAccent))
                          : const Text(""),
                      title: Text(
                        notification.type == NotificationType.newKey ? "新增鑰匙" : "刪除鑰匙",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
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