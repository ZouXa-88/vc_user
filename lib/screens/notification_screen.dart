import 'package:flutter/material.dart';

import 'package:user/abstract_classes/my_theme.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: MyTheme.background,
    );
  }
}