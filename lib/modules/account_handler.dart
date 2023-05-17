import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:image/image.dart' as image;
import 'package:user/backend_processes/connector.dart';

import 'package:user/objects/account.dart';
import 'package:user/backend_processes/storage.dart';
import 'package:user/backend_processes/notifications_box.dart';


class AccountHandler {

  AccountHandler._();

  static Future<void> storeAccount(String name) async {
    await storage.storeAccountData(Account(name: name));
  }

  static Future<void> setDefaultAccount() async {
    final defaultAccount = await _getDefaultAccount();
    await storage.storeAccountData(defaultAccount);
    account = defaultAccount;
    _addDefaultNotifications();
  }

  static Future<String> setAccount() async {
    ConnectResponse userDataResponse = await connector.getUserData();

    if(userDataResponse.isOk()) {
      try {
        final String name = userDataResponse.data["userName"];
        storage.setCurrentUser(name);

        if (storage.hasAccountData()) {
          account = Account.from((await storage.loadAccountData())!);
        }
        else {
          ConnectResponse keyDataResponse = await connector.getKeys();

          if(keyDataResponse.isOk()) {
            account = Account(name: name);
            await storage.storeAccountData(account);
            final keys = List<Map<String, String>>.from(keyDataResponse.data["newShares"] as List);

            for(Map<String, String> key in keys){
              String doorName = key["doorName"]!;
              String share = key["share"]!;
              account.addKey(doorName);
              await storage.storeShare(doorName, share);
            }
          }
          else{
            return keyDataResponse.getErrorMessage();
          }
        }
        return "";
      }
      catch(e){
        return e.toString();
      }
    }
    else{
      return userDataResponse.getErrorMessage();
    }
  }

  static void _addDefaultNotifications() {
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

  static Future<Account> _getDefaultAccount() async {
    Account defaultAccount = Account(name: "王小明", isDefault: true);
    storage.setCurrentUser(defaultAccount.getName());

    defaultAccount.addKey("大門");
    storage.storeShare("大門", await _loadShare("assets/shares/door1_1.png"));
    defaultAccount.addKey("二樓辦公室");
    storage.storeShare("二樓辦公室", await _loadShare("assets/shares/door2_1.png"));

    return defaultAccount;
  }

  static Future<String> _loadShare(String path) async {
    final byteData = await rootBundle.load(path);
    final pixels = image
        .decodeImage(byteData.buffer.asUint8List())!
        .getBytes(format: image.Format.luminance)
        .map((e) => e == 0 ? 1 : 0) // e == 0 means e is black
        .toList();

    final buf = base64Encode(_toUint8List(pixels));
    return buf;
  }

  static Uint8List _toUint8List(List<int> listPixels) {
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