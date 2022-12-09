import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:user/database.dart';

// ==========Scanner==========

class Scanner extends StatefulWidget{
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner>{

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

      String door = stringData.first.replaceAll("d=", "");
      int? seed = int.tryParse(stringData.last.replaceAll("s=", ""));
      if(!database.shares.containsKey(door) || seed == null){
        return;
      }

      database.history.addNewHistory(door);
      controller.pauseCamera();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrCodeKey(door: door, share: database.shares.getShare(door)!, seed: seed),
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

// ==========Scanner==========

// ==========QrCodeKey==========

class QrCodeKey extends StatefulWidget {

  final String door;
  final Uint8List share;
  final int seed;


  const QrCodeKey({Key? key, required this.door, required this.share, required this.seed}) : super(key: key);

  @override
  _QrCodeKeyState createState() => _QrCodeKeyState();
}

class _QrCodeKeyState extends State<QrCodeKey> {

  late String door;
  late Uint8List share;
  late int seed;

  late QrImage qrImage;
  bool qrCodeIsGenerated = false;

  @override
  void initState() {
    super.initState();

    door = widget.door;
    share = widget.share;
    seed = widget.seed;
    generateQrCode();
  }

  void generateQrCode() {
    Random random = Random(seed);
    Uint8List buf = Uint8List(200);
    for(int i = 0; i < 200; i++) {
      buf[i] = share[i] ^ random.nextInt(256);
    }

    setState(() {
      qrImage = QrImage(
        data: base64Encode(buf),
        version: 10,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );
      qrCodeIsGenerated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "# $door",
              style: const TextStyle(fontSize: 25),
            ),
          ),
          Expanded(
            flex: 6,
            child: qrCodeIsGenerated? qrImage : const Text("Qr Code 產生中..."),
          ),
        ],
      ),
    );
  }
}

// ==========QrCodeKey==========