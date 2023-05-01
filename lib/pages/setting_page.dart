import 'package:flutter/material.dart';

import 'package:user/modules/app_theme.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        children: [

        ],
      ),
    );
  }
}