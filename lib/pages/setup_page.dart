import 'package:flutter/material.dart';

import 'package:user/utilities/account.dart';
import 'package:user/utilities/storage.dart';
import 'package:user/pages/main_page.dart';
import 'package:user/pages/login_page.dart';


class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  Future<void> _setup(BuildContext context) async {
    String? encodedAccountData = await storage.loadAccountData();
    
    if(context.mounted) {
      if(encodedAccountData != null){
        currentAccount = Account.from(encodedAccountData);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      }
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    _setup(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("正在載入資料"),
            ),
          ],
        ),
      ),
    );
  }
}