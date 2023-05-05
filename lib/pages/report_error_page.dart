import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:user/modules/app_theme.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("通報為黑名單"),
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

        ],
      ),
    );
  }
}