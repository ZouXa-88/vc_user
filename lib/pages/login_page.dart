import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:user/backend_processes/connector.dart';
import 'package:user/backend_processes/storage.dart';
import 'package:user/modules/app_theme.dart';
import 'package:user/modules/account_handler.dart';
import 'package:user/modules/dialog_presenter.dart';
import 'package:user/pages/create_account_page.dart';
import 'package:user/pages/main_page.dart';
import 'package:user/objects/account.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _isLogging = false;

  String _email = "";
  String _password = "";


  Future<void> _login() async {
    setState(() {
      _isLogging = true;
    });

    ConnectResponse response = await connector.login(email: _email, password: _password);
    ConnectResponse userDataResponse = await connector.getUserData();

    if (context.mounted) {
      if (response.isOk() && userDataResponse.isOk()) {
        AccountHandler.setAccount(userDataResponse.data["userName"]);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      }
      else if (response.isOk() && !userDataResponse.isOk()) {
        DialogPresenter.showInformDialog(context, "登入成功，但無法取得資料", description: userDataResponse.data["detail"]?? "");
      }
      else {
        DialogPresenter.showInformDialog(context, "登入失敗", description: response.data["detail"]?? "");
      }
    }

    setState(() {
      _isLogging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.veryLightGreen,
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: null,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "登入帳號",
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3,
                  ),
                ),
                Lottie.asset(
                  "assets/lotties/login.json",
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.width / 2,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: TextFormField(
                          initialValue: "",
                          keyboardType: TextInputType.emailAddress,
                          decoration: AppTheme.getEllipseInputDecoration(
                            labelText: "帳號",
                            prefixIcon: const Icon(Icons.email),
                          ),
                          onChanged: (text) {
                            _email = text;
                          },
                          validator: (text) {
                            return (text == null || text.isEmpty) ? "請輸入帳號" : null;
                          },
                          ),
                      ),
                      SizedBox(
                        height: 100,
                        child: TextFormField(
                          initialValue: "",
                          scrollPadding: const EdgeInsets.only(top: 20),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_passwordVisible,
                          decoration: AppTheme.getEllipseInputDecoration(
                            labelText: "密碼",
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                              icon: _passwordVisible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          onChanged: (text) {
                            _password = text;
                          },
                          validator: (text) {
                            return (text == null || text.isEmpty) ? "請輸入密碼" : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            if(_formKey.currentState!.validate()){
                              _login();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fixedSize: const Size(200, 50),
                          ),
                          child: _isLogging
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("登入"),
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fixedSize: const Size(200, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateAccountPage())
                    );
                  },
                  child: const Text("註冊帳號"),
                ),
                TextButton(
                  child: const Text("server's IP"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Set Server's IP"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  initialValue: connector.getServerAddress(),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "IPv4",
                                  ),
                                  onChanged: (text) {
                                    connector.setServerAddress(text);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  initialValue: connector.getPort().toString(),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Port",
                                  ),
                                  onChanged: (text) {
                                    connector.setPort(int.parse(text));
                                  },
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                TextButton(
                  child: const Text("使用預設帳號登入"),
                  onPressed: () {
                    AccountHandler.setDefaultAccount();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
