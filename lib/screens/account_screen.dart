import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:user/modules/dialog_presenter.dart';
import 'package:user/modules/app_theme.dart';
import 'package:user/objects/account.dart';
import 'package:user/backend_processes/connector.dart';
import 'package:user/pages/login_page.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreen();
}

class _AccountScreen extends State<AccountScreen> {

  Future<void> _deleteAccount() async {
    DialogPresenter.showProcessingDialog(context, "傳送中");

    ConnectResponse response = await connector.deleteAccount();

    if(context.mounted){
      DialogPresenter.closeDialog(context);
      if(response.isOk()){
        DialogPresenter.showInformDialog(context, "傳送成功");
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.connectionError:
            errorDescription = "無法連線";
            break;
          case StatusType.notAuthenticatedError:
            DialogPresenter.showRequireLoginDialog(context);
            return;
          case StatusType.unknownError:
            errorDescription = response.data["reason"];
            break;
          default:
            errorDescription = "";
        }
        DialogPresenter.showInformDialog(context, "傳送失敗", description: errorDescription);
      }
    }
  }

  Widget _optionButton({
    required String label,
    required IconData iconData,
    required Color backgroundColor,
    required void Function() onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: InkWell(
        onTap: onPressed,
        child: Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset.fromDirection(45, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.5,
                    ),
                  ),
                  Icon(
                    iconData,
                    color: Colors.white,
                    size: 25,
                  ),
                ],
              ),
            )
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          "帳號",
          style: TextStyle(
            letterSpacing: 3,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(
            flex: 1,
            child: Icon(
              Icons.account_circle_rounded,
              color: Colors.grey,
              size: 100,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                account.getName(),
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Scrollbar(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _optionButton(
                      label: "登出",
                      iconData: Icons.logout,
                      backgroundColor: CupertinoColors.systemGreen,
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      ),
                    ),
                    _optionButton(
                      label: "刪除帳號",
                      iconData: Icons.delete,
                      backgroundColor: CupertinoColors.systemRed,
                      onPressed: () {
                        DialogPresenter.showConfirmDialog(
                          context,
                          "刪除帳號",
                          description: "確定要刪除此帳號?",
                        ).then((confirm) {
                          if(confirm){
                            _deleteAccount();
                          }
                        });
                      },
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