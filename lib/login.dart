import 'package:flutter/material.dart';

import 'package:user/main.dart';
import 'package:user/accounts.dart';

// ==========Login==========

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _passwordVisible = false;


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
                          // TODO: Login.
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage(account: accounts.getAccount("001")!,),
                            ),
                            (route) => false,
                          );
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

// ==========Login==========

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