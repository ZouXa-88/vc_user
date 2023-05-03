import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:user/modules/app_theme.dart';


class InformBlacklistPage extends StatefulWidget {
  const InformBlacklistPage({super.key});

  @override
  State<StatefulWidget> createState() => _InformBlacklistPage();
}

class _InformBlacklistPage extends State<InformBlacklistPage> {

  bool _warningTextVisible = true;
  late final Timer _warningTextVisibleTimer;


  @override
  void initState() {
    _warningTextVisibleTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          _warningTextVisible = !_warningTextVisible;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _warningTextVisibleTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("通報為黑名單"),
      ),
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  Lottie.asset(
                    "assets/lotties/alert.json",
                    width: 80,
                    height: 80,
                  ),
                  AnimatedOpacity(
                    opacity: _warningTextVisible ? 1.0 : 0.5,
                    duration: const Duration(seconds: 1),
                    child: const Text(
                      "此帳號將被通報為黑名單",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppTheme.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Delete all keys.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                fixedSize: const Size(130, 50),
              ),
              child: const Text("確定通報"),
            ),
          ],
        ),
      ),
    );
  }
}