import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:user/utilities/connector.dart';
import 'package:user/abstract_classes/dialog_presenter.dart';

class RegisterDoorPage extends StatefulWidget {
  const RegisterDoorPage({super.key});

  @override
  State<RegisterDoorPage> createState() => _RegisterDoorPage();
}

class _RegisterDoorPage extends State<RegisterDoorPage> with DialogPresenter {

  final _formKey = GlobalKey<FormState>();
  final _doorNameEditingController = TextEditingController();
  String _doorName = "";
  String _reason = "";

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

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      this.controller!.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) {
      List<String>? stringData = scanData.code?.split('&');
      if(stringData == null || stringData.length != 2 ||
          !stringData.first.contains("d=") || !stringData.last.contains("s=")){
        return;
      }

      String doorName = stringData.first.replaceAll("d=", "");
      _doorNameEditingController.text = doorName;
      setState(() {
        _doorName = doorName;
      });
    });
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
          Column(
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
                        controller: _doorNameEditingController,
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
                          _register(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
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
                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: const Divider(
                        color: Colors.black,
                        height: 36,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.qr_code_scanner),
                  Text("掃門鎖QR Code"),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.width - 20,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    // full screen
                    borderColor: Theme.of(context).primaryColor,
                    borderRadius: 0,
                    borderLength: 0,
                    borderWidth: 0,
                    cutOutWidth: MediaQuery.of(context).size.width - 20,
                    cutOutHeight: MediaQuery.of(context).size.width - 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
