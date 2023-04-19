import 'package:flutter/material.dart';

import 'package:user/pages/setup_page.dart';
import 'package:user/modules/app_theme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme.setSystemTheme();
    return MaterialApp(
      theme: AppTheme.getThemeData(),
      home: const SetupPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
