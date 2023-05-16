import 'dart:async';

import 'package:flutter/material.dart';

import 'package:user/objects/account.dart';
import 'package:user/backend_processes/connector.dart';
import 'package:user/modules/dialog_presenter.dart';
import 'package:user/modules/snack_bar_presenter.dart';
import 'package:user/modules/app_theme.dart';


class DeleteKeyPage extends StatefulWidget {
  const DeleteKeyPage({super.key});

  @override
  State<DeleteKeyPage> createState() => _DeleteKeyPage();
}

class _DeleteKeyPage extends State<DeleteKeyPage> {

  late final List<String> _registeredDoorsName;
  bool _hintTextVisible = true;
  late Timer _hintTextVisibleTimer;

  Future<void> _delete({required String doorName}) async {
    DialogPresenter.showProcessingDialog(context, "傳送中...");

    final response = await connector.deleteKey(doorName: doorName);

    if(context.mounted){
      DialogPresenter.closeDialog(context);
      if(response.isOk()){
        SnackBarPresenter.showSnackBar(context, "傳送成功");
      }
      else{
        DialogPresenter.showInformDialog(context, "傳送失敗", description: response.data["detail"]);
      }
    }
  }

  @override
  initState() {
    _registeredDoorsName = account.getAllKeys();
    _hintTextVisibleTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          _hintTextVisible = !_hintTextVisible;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _hintTextVisibleTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("刪除特定鑰匙"),
      ),
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: AnimatedOpacity(
                opacity: _hintTextVisible ? 1.0 : 0.2,
                duration: const Duration(seconds: 1),
                child: const Text("點選要刪除的鑰匙"),
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: account.getNumKeys(),
                  itemBuilder: (BuildContext buildContext, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.key),
                          title: Text(_registeredDoorsName[index]),
                          onTap: () {
                            DialogPresenter.showConfirmDialog(
                              context,
                              "刪除鑰匙",
                              description: "確定要刪除 ${_registeredDoorsName[index]}?",
                            ).then((confirm) {
                              if(confirm){
                                _delete(doorName: _registeredDoorsName[index]);
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
