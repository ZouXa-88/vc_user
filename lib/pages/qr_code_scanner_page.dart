import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:user/abstract_classes/dialog_presenter.dart';
import 'package:user/pages/create_key_page.dart';
import 'package:user/pages/qr_code_key_page.dart';
import 'package:user/utilities/account.dart';


class QrCodeScannerPage extends StatefulWidget {

  final bool forKeyCreation;

  const QrCodeScannerPage({Key? key, this.forKeyCreation = false}) : super(key: key);

  @override
  State<QrCodeScannerPage> createState() => _QrCodeScannerPage();
}

class _QrCodeScannerPage extends State<QrCodeScannerPage> with DialogPresenter {

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late final bool _forKeyCreation;


  bool _isValidFormat(final List<String>? tuple) {
    return (tuple != null && tuple.length == 2 &&
        tuple.first.contains("d=") && tuple.last.contains("s="));
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      this.controller!.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) {
      // Check format.
      List<String>? stringTuple = scanData.code?.split('&');
      if(!_isValidFormat(stringTuple)){
        return;
      }

      // Check if data is empty.
      String doorName = stringTuple!.first.replaceAll("d=", "");
      int? seed = int.tryParse(stringTuple.last.replaceAll("s=", ""));
      if(doorName.isEmpty || seed == null){
        return;
      }

      // Let's handle this door.
      if(account.hasKey(doorName)){
        controller.pauseCamera();
        // Show qrcode key.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrCodeKeyPage(doorName: doorName, seed: seed),
          ),
        ).then((_) {
          controller.resumeCamera();
        });
      }
      else{
        // The user doesn't have this key.
        if(_forKeyCreation){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CreateKeyPage(doorName: doorName)
            )
          );
        }
        else{
          controller.pauseCamera();
          showConfirmDialog(context, "您沒有這扇門的鑰匙", description: "想要申請這扇門的鑰匙嗎?")
            .then((confirm) {
              if(confirm){
                controller.pauseCamera();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateKeyPage(doorName: doorName)
                  )
                ).then((_) {
                  controller.resumeCamera();
                });
              }
              else {
                controller.resumeCamera();
              }
          });
        }
      }
    });
  }

  @override
  void initState() {
    _forKeyCreation = widget.forKeyCreation;
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
        title: const Text("掃QR Code"),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          // Full screen.
          borderColor: Theme.of(context).primaryColor,
          borderRadius: 0,
          borderLength: 0,
          borderWidth: 0,
          cutOutWidth: MediaQuery.of(context).size.width,
          cutOutHeight: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}