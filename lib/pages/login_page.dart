import 'package:flutter/material.dart';

import 'package:user/utilities/connector.dart';
import 'package:user/utilities/dialog_presenter.dart';
import 'package:user/pages/create_account_page.dart';
import 'package:user/pages/main_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with DialogPresenter {

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  String _email = "";
  String _password = "";


  Future<void> _login(BuildContext context, {required String email, required String password}) async {
    showProcessingDialog(context, "登入中...");

    ConnectResponse response = await connector.login(email: email, password: password);

    if(context.mounted) {
      closeDialog(context);
      if(response.isOk()){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.emailPasswordIncorrectError:
            errorDescription = "信箱或密碼不正確";
            break;
          case StatusType.connectionError:
            errorDescription = "無法連線";
            break;
          case StatusType.unknownError:
            errorDescription = response.data["reason"];
            break;
          default:
            errorDescription = "";
        }
        showProcessResultDialog(context, "登入失敗", errorDescription);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("登入帳號"),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: null,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Padding> [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        initialValue: "",
                        scrollPadding: const EdgeInsets.only(top: 20),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "信箱",
                          prefixIcon: Icon(Icons.email),
                        ),
                        onChanged: (text) {
                          _email = text;
                        },
                        validator: (text) {
                          return (text == null || text.isEmpty) ? "請輸入信箱" : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        initialValue: "",
                        scrollPadding: const EdgeInsets.only(top: 20),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
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
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text("登入"),
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            _login(context, email: _email, password: _password);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fixedSize: const Size(200, 50),
                        ),
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
                child: const Text("Skip"),
                onPressed: () {
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
        ],
      ),
    );
  }
}
