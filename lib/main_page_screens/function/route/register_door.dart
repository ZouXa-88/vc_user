import 'package:flutter/material.dart';

import 'package:user/utilities/connector.dart';
import 'package:user/utilities/dialog_presenter.dart';

class RegisterDoor extends StatefulWidget {
  const RegisterDoor({super.key});

  @override
  State<RegisterDoor> createState() => _RegisterDoor();
}

class _RegisterDoor extends State<RegisterDoor> with DialogPresenter {

  final _formKey = GlobalKey<FormState>();
  String _doorName = "";
  String _reason = "";


  Future<void> _register(BuildContext context, {required String doorName}) async {
    showProcessingDialog(context, "傳送中...");

    ConnectResponse response = await connector.registerDoor(doorName: doorName);

    if(context.mounted){
      closeDialog(context);
      if(response.isOk()){
        showSuccessDialog(context, "傳送成功", "");
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.objectNotExistError:
            errorDescription = "此門($doorName)不存在";
            break;
          case StatusType.alreadyAppliedError:
            errorDescription = "$doorName已經申請過";
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
        showFailureDialog(context, "申請失敗", errorDescription);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新增門鎖"),
      ),
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
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
                      labelText: "門鎖名稱",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _doorName = text;
                      });
                    },
                    validator: (text) {
                      return (text == null || text.isEmpty) ? "請輸入門鎖名稱" : null;
                    },
                  ),
                ),
                /*
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    initialValue: "",
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: "新增原因",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _registerReason = text;
                      });
                    },
                    validator: (text) {
                      return (text == null || text.isEmpty) ? "請輸入新增原因" : null;
                    },
                  ),
                ),
                */
                TextButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text("傳送"),
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      _register(context, doorName: _doorName);
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
