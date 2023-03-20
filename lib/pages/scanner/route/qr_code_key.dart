import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeKey extends StatefulWidget {

  final String doorName;
  final Uint8List share;
  final int seed;


  const QrCodeKey({Key? key, required this.doorName, required this.share, required this.seed}) : super(key: key);

  @override
  State<QrCodeKey> createState() => _QrCodeKeyState();
}

class _QrCodeKeyState extends State<QrCodeKey> {

  late String doorName;
  late Uint8List share;
  late int seed;

  late QrImage qrImage;
  bool qrCodeIsGenerated = false;


  @override
  void initState() {
    super.initState();

    doorName = widget.doorName;
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
              doorName,
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