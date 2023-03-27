import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image/image.dart' as image;
import 'package:basic_utils/basic_utils.dart';

import 'package:user/pages/setup_page.dart';
import 'package:user/utilities/accounts.dart';
import 'package:user/utilities/storage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPortrait(); // Allow vertical only.
  await setupUsers();
  runApp(const MyApp());
}

Future<void> setPortrait() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future<void> setupUsers() async {
  Account user1 = Account(id: "001", name: "王小明");

  user1.addDoor("door1", "大門", await loadShare("assets/images/door1_1.png"));
  user1.addDoor("door2", "二樓辦公室", await loadShare("assets/images/door2_1.png"));

  accounts.addAccount(user1);
  await storeUserData(user1);
}

Future<Uint8List> loadShare(String path) async {
  Uint8List inputImg = (await rootBundle.load(path)).buffer.asUint8List();
  String binaries = image.decodeImage(inputImg)!
      .getBytes(format: image.Format.luminance)
      .map((e) => e == 0 ? 0 : 1)
      .join();
  
  List<int> buf = List.filled(200, 0);
  for(int i = 0; i < 200; i++){
    buf[i] = int.parse(StringUtils.reverse(binaries.substring(i * 8, i * 8 + 8)), radix: 2);
  }

  return Uint8List.fromList(buf);
}

Future<void> storeUserData(final Account account) async {
  await storage.initialize();
  await storage.storeAccountData(account);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
      ),
      home: const SetupPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
