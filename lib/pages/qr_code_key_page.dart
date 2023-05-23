import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:user/backend_processes/storage.dart';


class QrCodeKeyPage extends StatefulWidget {

  final String doorName;
  final int seed;


  const QrCodeKeyPage({Key? key, required this.doorName, required this.seed}) : super(key: key);

  @override
  State<QrCodeKeyPage> createState() => _QrCodeKeyPage();
}

class _QrCodeKeyPage extends State<QrCodeKeyPage> {

  late String _doorName;
  late int _seed;

  late QrImageView _qrImage;
  bool _qrCodeIsGenerated = false;


  @override
  void initState() {
    super.initState();

    _doorName = widget.doorName;
    _seed = widget.seed;
    generateQrCode();
  }

  Future<void> generateQrCode() async {
    Uint8List share = Uint8List.fromList(base64Decode(
        (await storage.loadShare(_doorName))!
    ));
    Random random = Random(_seed);
    Uint8List buf = Uint8List(200);

    for(int i = 0; i < 200; i++) {
      buf[i] = share[i] ^ random.nextInt(256);
    }

    setState(() {
      _qrImage = QrImageView(
        data: base64Encode(buf),
        version: 10,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );
      _qrCodeIsGenerated = true;
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
              _doorName,
              style: const TextStyle(fontSize: 25),
            ),
          ),
          Expanded(
            flex: 6,
            child: _qrCodeIsGenerated
                ? _qrImage
                : const Center(
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(),
                ),
            )
          ),
        ],
      ),
    );
  }
}