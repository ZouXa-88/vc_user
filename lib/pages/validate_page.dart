import 'package:flutter/material.dart';

import 'package:user/abstract_class/dialog_presenter.dart';

class ValidatePage extends StatefulWidget {
  const ValidatePage({super.key});

  @override
  State<ValidatePage> createState() => _ValidatePage();
}

class _ValidatePage extends State<ValidatePage> with DialogPresenter {

  Future<void> _validate(BuildContext context, {required String code}) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("驗證信箱"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "驗證碼",
              ),
            ),
            ElevatedButton(
              onPressed: () {

              },
              child: const Text("傳送"),
            ),
          ],
        ),
      ),
    );
  }
}