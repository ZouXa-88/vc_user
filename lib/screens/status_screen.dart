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
  String _pingFailedMessage = "";
  String _updateFailedMessage = "";
  bool _isAuthenticated = true;


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
    String pingFailMessage = await connector.pingTest();

    if(_trackUpdateStatusTimer.isActive){
      setState(() {
        _pingFailedMessage = pingFailMessage;
        _updateFailedMessage = updater.getFailedMessage();
        _isAuthenticated = connector.getAuthenticationStatus();
      });
    }
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
          DialogPresenter.showInformDialog(context, "message", description: description);
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
          "Status",
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
              title: "Connection",
              color: _pingFailedMessage.isEmpty ? Colors.green : Colors.red,
              status: _pingFailedMessage.isEmpty ? "Success" : "Failed",
              description: _pingFailedMessage.isEmpty ? null : _pingFailedMessage,
            ),
            _getStatusBar(
              lottiePath: "assets/lotties/cloud_server.json",
              title: "Update Data",
              color: _updateFailedMessage.isEmpty ? Colors.green : Colors.red,
              status: _updateFailedMessage.isEmpty ? "Success" : "Failed",
              description: _updateFailedMessage.isEmpty ? null : _updateFailedMessage,
            ),
            _getStatusBar(
              lottiePath: "assets/lotties/fingerprint.json",
              title: "Authentication",
              color: _isAuthenticated ? Colors.green : Colors.red,
              status: _isAuthenticated ? "Success" : "Invalid",
            ),
          ],
        ),
      ),
    );
  }
}