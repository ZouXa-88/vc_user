import 'package:flutter/material.dart';

import 'package:user/main.dart';
import 'package:user/accounts.dart';
import 'package:user/connector.dart';

// ==========LoginPage==========

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _passwordVisible = false;


  void _login(BuildContext context, {required String email, required String password}) async {
    // Show processing dialog.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text("登入中..."),
                ),
              ],
            ),
          ),
        );
      },
    );

    ConnectorResponse response = await connector.sendLogin(email: email, password: password);

    if(context.mounted) {
      Navigator.of(context).pop();
      if(response.ok){
        // Login successful.
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(account: accounts.getAccount("001")!,),
          ),
              (route) => false,
        );
      }
      else{
        // Login failed.
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              title: const Text("登入失敗"),
              content: Text(response.errorMessage),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("登入帳號"),
          automaticallyImplyLeading: false,
        ),
        body: Column(
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
                        border: OutlineInputBorder(),
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
                        border: const OutlineInputBorder(),
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
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
              ),
              onPressed: () {
                // TODO: Register a new account.
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateAccount())
                );
              },
              child: const Text("註冊帳號"),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========LoginPage==========

// ==========CreateAccount==========

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccount();
}

class _CreateAccount extends State<CreateAccount> {

  final _formKey = GlobalKey<FormState>();
  String _userName = "";
  String _email = "";
  String _password = "";


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("註冊帳號"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  initialValue: "",
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "使用者名稱",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _userName = text;
                    });
                  },
                  validator: (text) {
                    return (text == null || text.isEmpty) ? "請輸入使用者名稱" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  initialValue: "",
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: "信箱",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _email = text;
                    });
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
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: "密碼",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _password = text;
                    });
                  },
                  validator: (text) {
                    return (text == null || text.isEmpty) ? "請輸入密碼" : null;
                  },
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("傳送"),
                onPressed: () {
                  if(_formKey.currentState!.validate()){

                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}

// ==========CreateAccount==========