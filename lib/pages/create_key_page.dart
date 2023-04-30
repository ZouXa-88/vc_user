import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:user/pages/qr_code_scanner_page.dart';
import 'package:user/backend_processes/connector.dart';
import 'package:user/modules/dialog_presenter.dart';
import 'package:user/modules/app_theme.dart';


class CreateKeyPage extends StatefulWidget {

  final String doorName;
  final bool enableScan;

  const CreateKeyPage({super.key, this.doorName = "", this.enableScan = false});

  @override
  State<CreateKeyPage> createState() => _CreateKeyPage();
}

class _CreateKeyPage extends State<CreateKeyPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _doorNameController = TextEditingController();

  String _doorName = "";
  String _reason = "";

  late final bool _enableScan;

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');


  Future<void> _register() async {
    DialogPresenter.showProcessingDialog(context, "傳送中...");

    ConnectResponse response = await connector.applyKey(doorName: _doorName);

    if(context.mounted){
      DialogPresenter.closeDialog(context);
      if(response.isOk()){
        DialogPresenter.showInformDialog(context, "傳送成功");
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
          case StatusType.programExceptionError:
            errorDescription = response.data["reason"];
            break;
          case StatusType.connectionError:
            errorDescription = "無法連線";
            break;
          case StatusType.notAuthenticatedError:
            errorDescription = "請登入";
            return;
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
      appBar: AppBar(
        title: const Text("新增鑰匙"),
      ),
      backgroundColor: AppTheme.background,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const QrCodeScannerPage(forKeyCreation: true),
                          ),
                        ).then((doorName) {
                          _doorNameController.text = doorName;
                          setState(() {
                            _doorName = _doorName;
                          });
                        });
                      },
                      child: const Text(
                        "掃門鎖QR Code",
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _doorNameController,
                        decoration: AppTheme.getEllipseInputDecoration(
                          labelText: "門鎖名稱",
                          prefixIcon: const Icon(Icons.door_back_door),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 40),
                      ),
                      child: const Text("傳送"),
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          _register();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
