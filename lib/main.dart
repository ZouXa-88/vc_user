import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image/image.dart' as image;
import 'package:basic_utils/basic_utils.dart';

import 'package:user/pages/home.dart';
import 'package:user/pages/personality.dart';
import 'package:user/pages/scanner.dart';
import 'package:user/accounts.dart';

// ==========main==========

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpUsers();
  runApp(const MyApp());
}

Future<void> setUpUsers() async {
  Account user1 = Account();
  Account user2 = Account();

  user1.setName("user1");
  user1.addShare("door1", await loadShare("assets/images/door1_1.png"));
  user1.addShare("door2", await loadShare("assets/images/door2_1.png"));

  user2.setName("user2");
  user2.addShare("door1", await loadShare("assets/images/door1_2.png"));
  user2.addShare("door2", await loadShare("assets/images/door2_2.png"));

  accounts.addAccount(user1);
  accounts.addAccount(user2);
  currentAccount = accounts.getAccount("user1")!;
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

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const UserApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ==========main==========

// ==========UserApp==========

class UserApp extends StatefulWidget{
  const UserApp({super.key});

  @override
  _UserAppState createState() => _UserAppState();
}

class _UserAppState extends State<UserApp>{

  var _selectedIndex = 0;
  final pages = [const Home(), const Scanner(), const Personality()];


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("user app"),
      ),
      body: pages[_selectedIndex],
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