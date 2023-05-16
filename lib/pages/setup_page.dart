import 'package:flutter/material.dart';
import 'package:user/modules/account_handler.dart';
import 'package:user/modules/dialog_presenter.dart';

import 'package:user/objects/account.dart';
import 'package:user/backend_processes/storage.dart';
import 'package:user/pages/login_page.dart';


class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  Future<void> _setup(BuildContext context) async {
    final storageInitializeSuccess = await storage.initialize();

    if(context.mounted) {
      if(storageInitializeSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
      else{
        DialogPresenter.showInformDialog(context, "儲存空間設置失敗", description: "請重新啟動程式");
      }
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
              child: Text("正在設置儲存空間"),
            ),
          ],
        ),
      ),
    );
  }
}