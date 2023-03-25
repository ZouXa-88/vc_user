import 'package:flutter/material.dart';

class DialogPresenter {

  void showProcessingDialog(BuildContext context, String processingDescription) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
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

  void showFailureDialog(BuildContext context, String failureTitle, String failureDescription) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Text(failureTitle),
          content: Text(failureDescription),
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
}