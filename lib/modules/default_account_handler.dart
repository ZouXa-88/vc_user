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
    Uint8List inputImg = (await rootBundle.load(path)).buffer.asUint8List();
    String binaries = image.decodeImage(inputImg)!
        .getBytes(format: image.Format.luminance)
        .map((e) => e == 0 ? 0 : 1)
        .join();

    String buf = "";
    for(int pixel = 0; pixel < 400; pixel++){
      int topLeft = 40 * (pixel ~/ 20) + 2 * (pixel % 20);
      buf += binaries[topLeft];
      buf += binaries[topLeft + 1];
      buf += binaries[topLeft + 40];
      buf += binaries[topLeft + 41];
    }
    List<int> intBuf = List.filled(200, 0);
    for(int i = 0; i < 200; i++){
      intBuf[i] = int.parse(buf.substring(i * 8, i * 8 + 8), radix: 2);
    }

    return base64Encode(intBuf);
  }
}