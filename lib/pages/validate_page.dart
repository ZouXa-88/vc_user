import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:user/modules/dialog_presenter.dart';
import 'package:user/modules/app_theme.dart';
import 'package:user/backend_processes/connector.dart';


class ValidatePage extends StatefulWidget {
  const ValidatePage({super.key});

  @override
  State<ValidatePage> createState() => _ValidatePage();
}

class _ValidatePage extends State<ValidatePage> {

  final _formKey = GlobalKey<FormState>();
  String _code = "";


  Future<void> _validate() async {
    DialogPresenter.showProcessingDialog(context, "傳送中");

    ConnectResponse response = await connector.validate(code: _code);

    if(context.mounted){
      DialogPresenter.closeDialog(context);
      if(response.isOk()){
        DialogPresenter.showInformDialog(context, "驗證成功");
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.invalidCredentialCodeError:
            errorDescription = "驗證碼錯誤";
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
        DialogPresenter.showInformDialog(context, "失敗", description: errorDescription);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.veryLightOrange,
      appBar: AppBar(
        title: const Text("驗證信箱"),
        centerTitle: true,
        backgroundColor: AppTheme.veryLightOrange,
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
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Lottie.asset(
                      "assets/lotties/verify_code.json",
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      decoration: AppTheme.getRoundedRectangleInputDecoration(
                        prefixIcon: const Icon(Icons.code),
                        labelText: "驗證碼",
                      ),
                      onChanged: (text) {
                        setState(() {
                          _code = text;
                        });
                      },
                      validator: (text) {
                        return (text == null || text.isEmpty) ? "請輸入驗證碼" : null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      fixedSize: const Size(100, 40),
                    ),
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        _validate();
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