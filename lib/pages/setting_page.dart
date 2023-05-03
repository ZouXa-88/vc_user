import 'package:flutter/material.dart';
import 'package:user/backend_processes/updater.dart';

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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text("自動更新情形"),
                trailing: updater.isSuccessful() ? const Text("成功") : const Text("失敗"),
                subtitle: updater.isSuccessful() ? const Text("") : Text(updater.getFailedMessage()),
              ),
            )
          ],
        ),
      )
    );
  }
}