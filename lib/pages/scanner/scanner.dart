import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:user/accounts.dart';
import 'route/qr_code_key.dart';


class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');


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

      String doorId = stringData.first.replaceAll("d=", "");
      int? seed = int.tryParse(stringData.last.replaceAll("s=", ""));
      if(!currentAccount.isRegistered(doorId) || seed == null){
        return;
      }
      Door door = currentAccount.getDoor(doorId)!;

      controller.pauseCamera();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrCodeKey(doorName: door.name, share: door.share, seed: seed),
          )
      ).then((_) {
        controller.resumeCamera();
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
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        // full screen
        borderColor: Theme.of(context).primaryColor,
        borderRadius: 0,
        borderLength: 0,
        borderWidth: 0,
        cutOutWidth: MediaQuery.of(context).size.width,
        cutOutHeight: MediaQuery.of(context).size.height,
      ),
    );
  }
}
