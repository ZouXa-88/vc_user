import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image/image.dart' as image;
import 'package:basic_utils/basic_utils.dart';

import 'package:user/login_page.dart';
import 'package:user/connector.dart';
import 'package:user/pages/home/function_page.dart';
import 'package:user/pages/personality/personality_page.dart';
import 'package:user/pages/scanner/scanner_page.dart';
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
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ==========main==========

// ==========MainScreen==========

class MainScreen extends StatefulWidget {

  final Account account;

  const MainScreen({Key? key, required this.account}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {

  int _selectedIndex = 0;
  final _pages = <Widget>[const FunctionPage(), const ScannerPage(), const PersonalityPage()];
  final _titles = <Text>[const Text("首頁"), const Text("掃描"), const Text("個人資訊")];

  late Account _account;


  @override
  void initState() {
    _account = widget.account;
    currentAccount = _account; // TODO: Remove it.
    super.initState();
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

// ==========MainScreen==========