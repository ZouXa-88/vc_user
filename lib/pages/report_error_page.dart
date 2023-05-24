import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:user/modules/app_theme.dart';
import 'package:user/pages/key_exchange_page.dart';


class ReportErrorPage extends StatefulWidget {
  const ReportErrorPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReportErrorPage();
}

class _ReportErrorPage extends State<ReportErrorPage> {

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

  Widget _button({
    required String lottiePath,
    required String label,
    required Function() onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Card(
        color: Colors.orangeAccent.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.black12,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.transparent,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Expanded> [
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Lottie.asset(
                        lottiePath,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("問題通報"),
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _button(
            lottiePath: "assets/lotties/transaction.json",
            label: "鑰匙換新",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KeyExchangePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}