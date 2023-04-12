import 'package:flutter/material.dart';

import 'package:user/abstract_classes/dialog_presenter.dart';
import 'package:user/abstract_classes/my_theme.dart';
import 'package:user/utilities/account.dart';
import 'package:user/utilities/connector.dart';


class FunctionScreen extends StatefulWidget {
  const FunctionScreen({super.key});

  @override
  State<FunctionScreen> createState() => _FunctionScreen();
}

class _FunctionScreen extends State<FunctionScreen> with DialogPresenter {

  Future<void> _deleteAccount(BuildContext context) async {
    showProcessingDialog(context, "傳送中");

    ConnectResponse response = await connector.deleteAccount();

    if(context.mounted){
      closeDialog(context);
      if(response.isOk()){
        showProcessResultDialog(context, "傳送成功");
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.connectionError:
            errorDescription = "無法連線";
            break;
          case StatusType.notAuthenticatedError:
            showRequireLoginDialog(context);
            return;
          case StatusType.unknownError:
            errorDescription = response.data["reason"];
            break;
          default:
            errorDescription = "";
        }
        showProcessResultDialog(context, "傳送失敗", description: errorDescription);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.background,
      body: Column(
        children: [
          const Expanded(
            flex: 2,
            child: Icon(
              Icons.account_circle_rounded,
              color: Colors.grey,
              size: 100,
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                account.getName(),
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Scrollbar(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <ElevatedButton>[
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                      ),
                      onPressed: () {
                        showConfirmDialog(context, "刪除帳號", description: "確定要刪除此帳號?")
                            .then((confirm) {
                          if(confirm){
                            _deleteAccount(context);
                          }
                        });
                      },
                      child: const Text("刪除帳號"),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}