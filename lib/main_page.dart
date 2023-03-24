import 'package:flutter/material.dart';
import 'package:user/utilities/accounts.dart';

import 'main_page_screens/function/function_screen.dart';
import 'main_page_screens/personality/personality_screen.dart';
import 'main_page_screens/scanner/scanner_screen.dart';

class MainPage extends StatefulWidget {

  final Account account;

  const MainPage({Key? key, required this.account}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {

  int _selectedIndex = 0;
  final _pages = <Widget>[const FunctionScreen(), const ScannerScreen(), const PersonalityScreen()];
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