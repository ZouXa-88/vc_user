import 'package:flutter/material.dart';

import 'package:user/modules/dialog_presenter.dart';
import 'package:user/backend_processes/storage.dart';
import 'package:user/pages/login_page.dart';
import 'package:user/pages/main_page.dart';


class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<StatefulWidget> createState() => _SetupPage();
}

class _SetupPage extends State<SetupPage> {

  Future<void> _routePage() async {
    if(storage.hasCredentials()){
      if(context.mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      }
    }
    else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  Future<void> _setup() async {
    final storageInitializeSuccess = await storage.initialize();

    if(context.mounted){
      if(storageInitializeSuccess){
        _routePage();
      }
      else{
        DialogPresenter.showInformDialog(context, "Failed to set your storage.", description: "Please restart this app.")
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
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("Setting."),
            ),
          ],
        ),
      ),
    );
  }
}