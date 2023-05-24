import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:image/image.dart' as image;

import 'package:user/objects/account.dart';
import 'package:user/backend_processes/updater.dart';
import 'package:user/backend_processes/connector.dart';

final AccountHandler accountHandler = AccountHandler();

class AccountHandler {

  Future<void> setDefaultAccount() async {
    account = Account();
    account.setName("王小明");

    updater.updateData([
      {
        "door_name": String.fromCharCodes(utf8.encode("大門")),
        "share": await _loadShare("assets/shares/door1_1.png"),
      },
      {
        "door_name": String.fromCharCodes(utf8.encode("二樓辦公室")),
        "share": await _loadShare("assets/shares/door2_1.png"),
      },
    ]);
  }

  Future<void> resetAccount() async {
    connector.logout();
    account.clear();
  }

  Future<String> _loadShare(String path) async {
    final byteData = await rootBundle.load(path);
    final pixels = image
        .decodeImage(byteData.buffer.asUint8List())!
        .getBytes(format: image.Format.luminance)
        .map((e) => e == 0 ? 1 : 0) // e == 0 means e is black
        .toList();

    final buf = base64Encode(_toUint8List(pixels));
    return buf;
  }

  Uint8List _toUint8List(List<int> listPixels) {
    final imagePixels = List.generate(40, (i) => listPixels.sublist(40 * i, 40 * (i + 1)));
    List<int> buf = List.filled(200, 0);

    for (int r = 0; r < 40; r += 2) {
      for (int c = 0; c < 40; c += 2) {
        int index = r * 5 + (c ~/ 4);
        for (int sh = 0; sh < 2; ++sh) {
          buf[index] |= imagePixels[r][c] << (sh * 4);
          buf[index] |= imagePixels[r][c + 1] << (sh * 4 + 1);
          buf[index] |= imagePixels[r + 1][c] << (sh * 4 + 2);
          buf[index] |= imagePixels[r + 1][c + 1] << (sh * 4 + 3);
          c += 2;
        }
        c -= 2;
      }
    }

    return Uint8List.fromList(buf);
  }
}