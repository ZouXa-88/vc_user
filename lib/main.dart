import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image/image.dart' as image;
import 'package:basic_utils/basic_utils.dart';

import 'package:user/login.dart';
import 'package:user/connector.dart';
import 'package:user/pages/home/home.dart';
import 'package:user/pages/personality/personality.dart';
import 'package:user/pages/scanner/scanner.dart';
import 'package:user/accounts.dart';
import 'package:user/storage.dart';

// ==========main==========

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
  await storage.storeAccountData(account); // Comment it if you want to test login process.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ==========main==========

// ==========MainPage==========

class MainPage extends StatefulWidget {

  late Account account;

  MainPage({Key? key, required this.account}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {

  int _selectedIndex = 0;
  final _pages = <Widget>[const Home(), const Scanner(), const Personality()];
  final _titles = <Text>[const Text("首頁"), const Text("掃描"), const Text("個人資訊")];

  late Account _account;


  @override
  void initState() {
    _account = widget.account;
    currentAccount = _account; // TODO: Remove it.
    super.initState();
  }

  @override
  void dispose() {
    connector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _titles[_selectedIndex],
        actions: [
          IconButton(
            onPressed: () {
              //TODO: Update.
            },
            icon: const Icon(Icons.update),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "首頁"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "掃描"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "個人資訊"
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState((){
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// ==========UserApp==========