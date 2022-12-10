import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image/image.dart' as image;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:user/pages/home.dart';
import 'package:user/pages/personality.dart';
import 'package:user/pages/scanner.dart';
import 'package:user/accounts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const User(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class User extends StatefulWidget{
  const User({super.key});

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User>{

  var _selectedIndex = 0;
  final pages = [const Home(), const Scanner(), const Personality()];
  bool initialized = false;


  @override
  void initState() {
    super.initState();
    setUpUsers();
  }

  Future<void> setUpUsers() async {
    Account user1 = Account();
    Account user2 = Account();

    user1.addShare("door1", await loadShare("assets/images/door1_1.png"));
    user1.addShare("door2", await loadShare("assets/images/door2_1.png"));

    user2.addShare("door1", await loadShare("assets/images/door1_2.png"));
    user2.addShare("door2", await loadShare("assets/images/door2_2.png"));

    accounts.addAccount(user1);
    accounts.addAccount(user2);
    currentAccount = accounts.getAccount("user1")!;

    setState(() {
      initialized = true;
    });
  }

  Future<Uint8List> loadShare(String path) async {
    Uint8List inputImg = (await rootBundle.load(path)).buffer.asUint8List();
    final buffer = image.decodeImage(inputImg)!
        .getBytes(format: image.Format.luminance)
        .map((e) => e == 0 ? 0 : 1)
        .toList();

    return Uint8List.fromList(buffer);
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("user app"),
        ),
        body: initialized?
          pages[_selectedIndex] :
          Center(
            child: LoadingAnimationWidget.prograssiveDots(
              color: Theme.of(context).primaryColor,
              size: 100
            )
          ),
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
      ),
      onWillPop: () async {
        if(_selectedIndex == 0){
          return true;
        }
        setState(() {
          _selectedIndex = 0;
        });
        return false;
      }
    );
  }
}