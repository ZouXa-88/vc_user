import 'package:flutter/material.dart';
import 'package:user/abstract_class/dialog_presenter.dart';

import 'package:user/utilities/account.dart';
import 'package:user/utilities/storage.dart';
import 'package:user/pages/main_page.dart';
import 'package:user/pages/login_page.dart';


class SetupPage extends StatelessWidget with DialogPresenter {
  const SetupPage({super.key});

  Future<void> _setup(BuildContext context) async {
    String? encodedAccountData = await storage.loadAccountData();

    // TODO: Remove test version.
    // Test version.
    // --------------------
    if(encodedAccountData != null){
      account = Account.from(encodedAccountData);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
    // --------------------

    // General version.
    // --------------------
    /*
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
    }
    */
    // --------------------
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