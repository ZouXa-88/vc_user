import 'package:flutter/material.dart';

import 'package:user/abstract_classes/dialog_presenter.dart';
import 'package:user/utilities/connector.dart';

class ValidatePage extends StatefulWidget {
  const ValidatePage({super.key});

  @override
  State<ValidatePage> createState() => _ValidatePage();
}

class _ValidatePage extends State<ValidatePage> with DialogPresenter {

  final _formKey = GlobalKey<FormState>();
  String _code = "";


  Future<void> _validate(BuildContext context) async {
    showProcessingDialog(context, "傳送中");

    ConnectResponse response = await connector.validate(code: _code);

    if(context.mounted){
      closeDialog(context);
      if(response.isOk()){
        showProcessResultDialog(context, "驗證成功");
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
        showProcessResultDialog(context, "失敗", description: errorDescription);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("驗證信箱"),
        centerTitle: true,
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      decoration: const InputDecoration(
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
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        _validate(context);
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