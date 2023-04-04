import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image/image.dart' as image;
import 'package:basic_utils/basic_utils.dart';

import 'package:user/pages/setup_page.dart';
import 'package:user/utilities/account.dart';
import 'package:user/utilities/storage.dart';
import 'package:user/abstract_classes/my_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await storage.initialize();
    await setupUsers(); // TODO: Remove it when this project is done.
  }
  catch(e){
    print(e.toString());
  }
  runApp(const MyApp());
}

// These will be removed when the project is completed.
// ----------------------------------------

Future<void> setupUsers() async {
  Account user1 = Account(name: "王小明");

  user1.addDoor("大門");
  storage.storeShare("大門", await loadShare("assets/images/door1_1.png"));
  user1.addDoor("二樓辦公室");
  storage.storeShare("二樓辦公室", await loadShare("assets/images/door2_1.png"));

  await storeUserData(user1);
}

Future<String> loadShare(String path) async {
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

Future<void> storeUserData(final Account account) async {
  print("Store user data: ${await storage.storeAccountData(account)}");
}

// ----------------------------------------

class MyApp extends StatelessWidget with MyTheme {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    setSystemBar();
    return MaterialApp(
      theme: getThemeData(),
      home: const SetupPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
