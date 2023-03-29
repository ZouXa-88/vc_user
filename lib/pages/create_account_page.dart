import 'package:flutter/material.dart';

import 'package:user/utilities/connector.dart';
import 'package:user/pages/extendable/dialog_presenter.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPage();
}

class _CreateAccountPage extends State<CreateAccountPage> with DialogPresenter {

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  String _userName = "";
  String _email = "";
  String _password = "";


  Future<void> _create(BuildContext context, {required String userName, required String email, required String password}) async {
    showProcessingDialog(context, "註冊中...");

    ConnectResponse response = await connector.createAccount(userName: userName, email: email, password: password);

    if(context.mounted) {
      closeDialog(context);
      if(response.isOk()){
        showProcessResultDialog(context, "傳送成功", description: "已寄驗證碼到 $_email");
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.parameterInUsedError:
            errorDescription = "使用者名稱或信箱已被使用";
            break;
          case StatusType.namePasswordInvalidError:
            errorDescription = "使用者名稱或密碼不符標準";
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
        showProcessResultDialog(context, "註冊失敗", description: errorDescription);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("註冊帳號"),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: null,
          ),
          Form(
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
                      prefixIcon: Icon(Icons.person),
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "信箱",
                      prefixIcon: Icon(Icons.email),
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
                      setState(() {
                        _password = text;
                      });
                    },
                    validator: (text) {
                      return (text == null || text.isEmpty) ? "請輸入密碼" : null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    initialValue: "",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: "確認密碼",
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
                    validator: (text) {
                      if(text == null || text.isEmpty) {
                        return "請再次輸入密碼";
                      }
                      if(text != _password){
                        return "密碼不一致";
                      }
                      return null;
                    },
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text("傳送"),
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      _create(context, userName: _userName, email: _email, password: _password);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}