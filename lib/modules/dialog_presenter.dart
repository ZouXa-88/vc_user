import 'package:flutter/material.dart';

class DialogPresenter {

  DialogPresenter._();

  static void showProcessingDialog(BuildContext context, String processingDescription) {
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

  static void showInformDialog(BuildContext context, String title, {String description = ""}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
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

  static Future<bool> showConfirmDialog(BuildContext context, String title, {String description = ""}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              TextButton(
                child: const Text("取消", style: TextStyle(color: Colors.black45)),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
      },
    );
  }

  static void closeDialog(BuildContext context) {
    if(context.mounted){
      Navigator.of(context).pop();
    }
  }
}