import 'package:flutter/material.dart';

import 'package:user/modules/dialog_presenter.dart';
import 'package:user/modules/snack_bar_presenter.dart';
import 'package:user/modules/app_theme.dart';
import 'package:user/objects/key_list.dart';
import 'package:user/backend_processes/connector.dart';
import 'package:user/backend_processes/account_handler.dart';
import 'package:user/pages/login_page.dart';
import 'package:user/pages/setting_page.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreen();
}

class _AccountScreen extends State<AccountScreen> {

  Future<void> _deleteAccount() async {
    DialogPresenter.showProcessingDialog(context, "Sending...");

    ConnectResponse response = await connector.deleteUser();

    if(context.mounted){
      DialogPresenter.closeDialog(context);
      if(response.isOk()){
        SnackBarPresenter.showSnackBar(context, "Delete the account successfully.");

        accountHandler.resetAccount();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
      else{
        DialogPresenter.showInformDialog(context, "Failed", description: response.getErrorMessage());
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
          ),
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
          "Account",
          style: TextStyle(
            letterSpacing: 3,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              "assets/images/user.png",
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
                      label: "Setting",
                      iconData: Icons.settings,
                      backgroundColor: Colors.grey,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingPage()),
                      ),
                    ),
                    _optionButton(
                      label: "Sign out",
                      iconData: Icons.logout,
                      backgroundColor: Colors.blueAccent,
                      onPressed: () {
                        accountHandler.resetAccount();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                    ),
                    _optionButton(
                      label: "Delete account",
                      iconData: Icons.delete,
                      backgroundColor: Colors.redAccent,
                      onPressed: () {
                        DialogPresenter.showConfirmDialog(
                          context,
                          "Delete Account",
                          description: "Are you sure?",
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