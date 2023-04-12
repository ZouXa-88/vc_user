import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:user/abstract_classes/my_theme.dart';
import 'package:user/pages/qr_code_scanner_page.dart';

import 'package:user/utilities/connector.dart';
import 'package:user/abstract_classes/dialog_presenter.dart';

class CreateKeyPage extends StatefulWidget {

  final String doorName;
  final bool enableScan;

  const CreateKeyPage({super.key, this.doorName = "", this.enableScan = false});

  @override
  State<CreateKeyPage> createState() => _CreateKeyPage();
}

class _CreateKeyPage extends State<CreateKeyPage> with DialogPresenter {

  final _formKey = GlobalKey<FormState>();
  String _doorName = "";
  String _reason = "";
  late final bool _enableScan;

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');


  Future<void> _register(BuildContext context) async {
    showProcessingDialog(context, "傳送中...");

    ConnectResponse response = await connector.registerDoor(doorName: _doorName);

    if(context.mounted){
      closeDialog(context);
      if(response.isOk()){
        showProcessResultDialog(context, "傳送成功");
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.objectNotExistError:
            errorDescription = "此門($_doorName)不存在";
            break;
          case StatusType.alreadyAppliedError:
            errorDescription = "$_doorName已經申請過";
            break;
          case StatusType.connectionError:
            errorDescription = "無法連線";
            break;
          case StatusType.notAuthenticatedError:
            showRequireLoginDialog(context);
            return;
          case StatusType.unknownError:
            errorDescription = response.data["reason"];
            break;
          default:
            errorDescription = "";
        }
        showProcessResultDialog(context, "傳送失敗", description: errorDescription);
      }
    }
  }

  @override
  void initState() {
    _doorName = widget.doorName;
    _enableScan = widget.enableScan;
    super.initState();
  }

  @override
  void dispose() {
    controller?.pauseCamera();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.background,
      appBar: AppBar(
        title: const Text("新增鑰匙"),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: _doorName,
                        decoration: const InputDecoration(
                          labelText: "門鎖名稱",
                          prefixIcon: Icon(Icons.door_back_door),
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
                          labelText: "原因",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          setState(() {
                            _registerReason = text;
                          });
                        },
                        validator: (text) {
                          return (text == null || text.isEmpty) ? "請輸入原因" : null;
                        },
                      ),
                    ),
                    */
                    TextButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text("傳送"),
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          _register(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              if(_enableScan) ...[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: const Divider(
                          color: Colors.black,
                          height: 36,
                        ),
                      ),
                    ),
                    const Text("OR"),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 10),
                        child: const Divider(
                          color: Colors.black,
                          height: 36,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const QrCodeScannerPage(forKeyCreation: true)
                      )
                    );
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text("掃門鎖QR Code"),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
