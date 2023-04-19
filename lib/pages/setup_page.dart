import 'package:flutter/material.dart';
import 'package:user/modules/default_account_handler.dart';

import 'package:user/objects/account.dart';
import 'package:user/backend_processes/storage.dart';
import 'package:user/pages/login_page.dart';


class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  Future<void> _setup(BuildContext context) async {
    await storage.initialize();
    await DefaultAccountHandler.storeDefaultAccount();
    String? encodedAccountData = await storage.loadAccountData();

    if(encodedAccountData != null){
      account = Account.from(encodedAccountData);
    }
    if(context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
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