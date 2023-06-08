import 'package:flutter/material.dart';

import 'package:user/backend_processes/connector.dart';
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
              color: Colors.blue.withOpacity(0.1),
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.blue.withOpacity(0.6),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("伺服器"),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        initialValue: connector.getServerAddress(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "IPv4",
                        ),
                        onChanged: (text) {
                          connector.setServerAddress(text);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        initialValue: connector.getPort().toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Port",
                        ),
                        onChanged: (text) {
                          connector.setPort(int.parse(text));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      )
    );
  }
}