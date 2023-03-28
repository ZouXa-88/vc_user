import 'package:flutter/material.dart';
import 'package:user/pages/login_page.dart';

class DialogPresenter {

  void showProcessingDialog(BuildContext context, String processingDescription) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(processingDescription),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void closeDialog(BuildContext context) {
    if(context.mounted){
      Navigator.of(context).pop();
    }
  }

  void showProcessResultDialog(BuildContext context, String title, String? description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: (description == null) ? null : Text(description),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void showRequireLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text("請登入"),
            actions: [
              TextButton(
                child: const Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("登入"),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      )
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}