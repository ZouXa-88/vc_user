import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:image/image.dart' as image;
import 'package:user/backend_processes/notifications_box.dart';

import 'package:user/objects/account.dart';
import 'package:user/backend_processes/storage.dart';


class DefaultAccountHandler {

  DefaultAccountHandler._();

  static Future<void> storeDefaultAccount() async {
    final account = await _setupAccount();
    await storage.storeAccountData(account);
  }

  static void addDefaultNotifications() {
    notificationsBox.clear();
    notificationsBox.addNotification(
      UpdateNotification(
        type: NotificationType.newKey,
        content: "大門",
      ),
    );
    notificationsBox.addNotification(
      UpdateNotification(
        type: NotificationType.newKey,
        content: "二樓辦公室",
      ),
    );
    notificationsBox.addNotification(
      UpdateNotification(
        type: NotificationType.deleteKey,
        content: "實驗室",
      ),
    );
  }

  static Future<Account> _setupAccount() async {
    Account account = Account(name: "王小明");

    account.addKey("大門");
    storage.storeShare("大門", await _loadShare("assets/shares/door1_1.png"));
    account.addKey("二樓辦公室");
    storage.storeShare("二樓辦公室", await _loadShare("assets/shares/door2_1.png"));

    return account;
  }

  static Future<String> _loadShare(String path) async {
    String buf = "";
    final byteData = await rootBundle.load(path);
    final buffer = image
        .decodeImage(byteData.buffer.asUint8List())!
        .getBytes(format: image.Format.luminance)
        .map((e) => e == 0 ? 1 : 0) // e == 0 means e is black
        .toList();

    buf = base64Encode(Uint8List.fromList(LoadShare(buffer)));
    return buf;
  }

  static List<int> LoadShare(List<int> Share) {
      var Img = List.generate(40, (i) => List.filled(40, 0, growable: false), growable: false);
      var Ret = List.filled(200, 0);
      for (int i = 0; i < 1600; ++i) {
        Img[i ~/ 40][i % 40] = Share[i];
      }
      for (int r = 0; r < 40; r += 2) {
        for (int c = 0; c < 40; c += 2) {
          int Idx = r * 5 + (c ~/ 4);
          for (int sh = 0; sh < 2; ++sh) {
            Ret[Idx] |= Img[r][c] << (sh * 4);
            Ret[Idx] |= Img[r][c + 1] << (sh * 4 + 1);
            Ret[Idx] |= Img[r + 1][c] << (sh * 4 + 2);
            Ret[Idx] |= Img[r + 1][c + 1] << (sh * 4 + 3);
            c += 2;
          }
          c -= 2;
        }
      }
      return Ret;
  }
}