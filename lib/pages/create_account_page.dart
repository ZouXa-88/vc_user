import 'package:flutter/material.dart';

import 'package:user/pages/validate_page.dart';
import 'package:user/backend_processes/connector.dart';
import 'package:user/modules/app_theme.dart';
import 'package:user/modules/dialog_presenter.dart';


class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPage();
}

class _CreateAccountPage extends State<CreateAccountPage> {

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  String _userName = "";
  String _email = "";
  String _password = "";


  Future<void> _create() async {
    DialogPresenter.showProcessingDialog(context, "註冊中...");

    ConnectResponse response = await connector.createAccount(userName: _userName, email: _email, password: _password);

    if(context.mounted) {
      DialogPresenter.closeDialog(context);
      if(response.isOk()){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ValidatePage())
        );
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
        DialogPresenter.showInformDialog(context, "傳送失敗", description: errorDescription);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("註冊帳號"),
        backgroundColor: AppTheme.veryLightOrange,
        actions: [
          TextButton(
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Colors.orange,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ValidatePage(),
                ),
              );
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.veryLightOrange,
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      initialValue: "",
                      keyboardType: TextInputType.text,
                      decoration: AppTheme.getEllipseInputDecoration(
                        labelText: "使用者名稱",
                        prefixIcon: const Icon(Icons.person),
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
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      initialValue: "",
                      keyboardType: TextInputType.emailAddress,
                      decoration: AppTheme.getEllipseInputDecoration(
                        labelText: "信箱",
                        prefixIcon: const Icon(Icons.email),
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
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      initialValue: "",
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
                        setState(() {
                          _password = text;
                        });
                      },
                      validator: (text) {
                        return (text == null || text.isEmpty) ? "請輸入密碼" : null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      initialValue: "",
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !_passwordVisible,
                      decoration: AppTheme.getEllipseInputDecoration(
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      fixedSize: const Size(100, 40),
                    ),
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _create();
                      }
                    },
                    child: const Text("傳送"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}