import 'package:flutter/material.dart';

import 'package:user/backend_processes/account_handler.dart';
import 'package:user/modules/dialog_presenter.dart';
import 'package:user/backend_processes/storage.dart';
import 'package:user/backend_processes/connector.dart';
import 'package:user/pages/login_page.dart';
import 'package:user/pages/main_page.dart';


class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<StatefulWidget> createState() => _SetupPage();
}

class _SetupPage extends State<SetupPage> {

  void _toMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }

  void _toLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  Future<void> _connectToServer() async {
    final String settingUserErrorMessage = await accountHandler.setAccount();

    if(context.mounted){
      if(settingUserErrorMessage.isEmpty){
        _toMainPage();
      }
      else{
        DialogPresenter.showInformDialog(context, "請重新登入", description: settingUserErrorMessage)
          .then((_) {
             _toLoginPage();
        });
      }
    }
  }

  Future<void> _setup() async {
    final storageInitializeSuccess = await storage.initialize();
    await connector.initialize();

    if(context.mounted){
      if(storageInitializeSuccess) {
        if(connector.hasCookie()){
          _connectToServer();
        }
        else{
          _toLoginPage();
        }
      }
      else{
        DialogPresenter.showInformDialog(context, "儲存空間設置失敗", description: "請重新啟動程式")
          .then((_) {
            Navigator.pop(context);
        });
      }
    }
  }

  @override
  void initState() {
    _setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("正在設置程式"),
            ),
          ],
        ),
      ),
    );
  }
}