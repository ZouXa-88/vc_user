import 'dart:async';

import 'package:flutter/material.dart';

import 'package:user/modules/app_theme.dart';
import 'package:user/modules/dialog_presenter.dart';
import 'package:user/modules/snack_bar_presenter.dart';
import 'package:user/objects/key_list.dart';
import 'package:user/backend_processes/connector.dart';


class KeyExchangePage extends StatefulWidget {
  const KeyExchangePage({super.key});

  @override
  State<StatefulWidget> createState() => _KeyExchangePage();
}

class _KeyExchangePage extends State<KeyExchangePage> {

  late final List<String> _registeredDoorsName;
  bool _hintTextVisible = true;
  late Timer _hintTextVisibleTimer;


  Future<void> _exchange({required String doorName}) async {
    DialogPresenter.showProcessingDialog(context, "傳送中...");

    final response = await connector.requestUpdateKey(doorName: doorName);

    if(context.mounted){
      DialogPresenter.closeDialog(context);
      if(response.isOk()){
        SnackBarPresenter.showSnackBar(context, "傳送成功");
      }
      else{
        DialogPresenter.showInformDialog(context, "傳送失敗", description: response.getErrorMessage());
      }
    }
  }

  @override
  initState() {
    _registeredDoorsName = keyList.getAllKeys();
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
        title: const Text("鑰匙換新"),
        actions: [
          IconButton(
            onPressed: () {
              DialogPresenter.showInformDialog(
                context,
                "鑰匙換新是什麼?",
                description: "若您覺得當前鑰匙已經暴露在危險中，可傳送舊鑰匙給伺服器。經驗證成功後，下一次更新鑰匙時即可得到新版本的鑰匙。",
              );
            },
            icon: const Icon(Icons.question_mark),
          ),
        ],
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
                child: const Text("點選要換新的鑰匙"),
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: keyList.getNumKeys(),
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
                              "鑰匙換新",
                              description: "確定要換新 ${_registeredDoorsName[index]} 的鑰匙?",
                            ).then((confirm) {
                              if(confirm){
                                _exchange(doorName: _registeredDoorsName[index]);
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