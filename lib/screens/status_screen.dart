import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:user/backend_processes/updater.dart';
import 'package:user/backend_processes/connector.dart';
import 'package:user/modules/dialog_presenter.dart';
import 'package:user/modules/app_theme.dart';


class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreen();
}

class _StatusScreen extends State<StatusScreen> {

  late Timer _trackUpdateStatusTimer;
  bool _hasConnection = false;
  String _failedMessage = "";


  @override
  void initState() {
    _getUpdateStatus();
    _trackUpdateStatusTimer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        _getUpdateStatus();
      },
    );
    super.initState();
  }

  Future<void> _getUpdateStatus() async {
    bool hasConnection = await connector.pingTest();
    setState(() {
      _hasConnection = hasConnection;
      _failedMessage = updater.getFailedMessage();
    });
  }

  @override
  void dispose() {
    _trackUpdateStatusTimer.cancel();
    super.dispose();
  }

  Widget _getStatusBar({
    required String lottiePath,
    required String title,
    required Color color,
    required String status,
    String? description,
  }) {
    return Container(
      margin: const EdgeInsets.all(15),
      height: 100,
      child: InkWell(
        onTap: description == null ? null : () {
          DialogPresenter.showInformDialog(context, "更新失敗", description: description);
        },
        child: Card(
          color: color.withOpacity(0.1),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: color.withOpacity(0.6),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Lottie.asset(lottiePath),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        title,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: color,
                    ),
                    child: Center(
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          "伺服器狀態",
          style: TextStyle(
            letterSpacing: 3,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _getStatusBar(
              lottiePath: "assets/lotties/satellite_antenna.json",
              title: "連線狀態",
              color: _hasConnection ? Colors.green : Colors.red,
              status: _hasConnection ? "連線成功" : "無法連線",
            ),
            _getStatusBar(
              lottiePath: "assets/lotties/cloud_server.json",
              title: "更新狀態",
              color: _failedMessage.isEmpty ? Colors.green : Colors.red,
              status: _failedMessage.isEmpty ? "更新成功" : "更新失敗",
              description: _failedMessage.isEmpty ? null : _failedMessage,
            ),
          ],
        ),
      ),
    );
  }
}