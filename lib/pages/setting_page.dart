import 'package:flutter/material.dart';

import 'package:user/modules/app_theme.dart';
import 'package:user/objects/configuration.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {

  late bool _autoUpdate;


  @override
  void initState() {
    _autoUpdate = configuration.autoUpdate();
    super.initState();
  }

  @override
  void dispose() {
    configuration.setAutoUpdate(_autoUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          ListTile(
            title: const Text("自動更新"),
            trailing: Switch(
              value: _autoUpdate,
              onChanged: (value) {
                setState(() {
                  _autoUpdate = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}