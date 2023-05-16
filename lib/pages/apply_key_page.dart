import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:user/pages/qr_code_scanner_page.dart';
import 'package:user/backend_processes/connector.dart';
import 'package:user/modules/dialog_presenter.dart';
import 'package:user/modules/app_theme.dart';
import 'package:user/modules/snack_bar_presenter.dart';


class ApplyKeyPage extends StatefulWidget {

  final String doorName;
  final bool enableScan;

  const ApplyKeyPage({super.key, this.doorName = "", this.enableScan = false});

  @override
  State<ApplyKeyPage> createState() => _ApplyKeyPage();
}

class _ApplyKeyPage extends State<ApplyKeyPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _doorNameController = TextEditingController();

  String _doorName = "";
  String _reason = "";

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');


  Future<void> _apply() async {
    DialogPresenter.showProcessingDialog(context, "傳送中...");

    ConnectResponse response = await connector.applyKey(doorName: _doorName);

    if(context.mounted){
      DialogPresenter.closeDialog(context);
      if(response.isOk()){
        SnackBarPresenter.showSnackBar(context, "傳送成功");
      }
      else{
        DialogPresenter.showInformDialog(context, "傳送失敗", description: response.data["detail"]);
      }
    }
  }

  @override
  void initState() {
    _doorName = widget.doorName;

    if(_doorName.isNotEmpty){
      _doorNameController.text = _doorName;
    }

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
        title: const Text("申請鑰匙"),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(widget.enableScan) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const QrCodeScannerPage(forKeyCreation: true),
                            ),
                          ).then((doorName) {
                            setState(() {
                              _doorNameController.text = doorName;
                              _doorName = doorName;
                            });
                          });
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text(
                          "掃門鎖QR Code",
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          side: const BorderSide(
                            color: Colors.grey,
                          ),
                          backgroundColor: AppTheme.background,
                          foregroundColor: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(
                    height: 100,
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
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      initialValue: "",
                      keyboardType: TextInputType.multiline,
                      decoration: AppTheme.getEllipseInputDecoration(
                        labelText: "申請原因",
                        prefixIcon: const Icon(Icons.description),
                      ),
                      onChanged: (text) {
                        setState(() {
                          _reason = text;
                        });
                      },
                      validator: (text) {
                        return (text == null || text.isEmpty) ? "請輸入申請原因" : null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 40),
                    ),
                    child: const Text("傳送"),
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _apply();
                      }
                    },
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
