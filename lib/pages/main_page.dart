import 'package:flutter/material.dart';

import 'package:user/abstract_classes/dialog_presenter.dart';
import 'package:user/abstract_classes/my_theme.dart';
import 'package:user/pages/login_page.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/screens/notification_screen.dart';
import 'package:user/screens/function_screen.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> with DialogPresenter {

  int _selectedIndex = 0;
  final _screens = <Widget> [
    const HomeScreen(),
    const NotificationScreen(),
    const FunctionScreen()
  ];
  final _titles = <String> [
    "首頁",
    "通知",
    "功能",
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
        shadowColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            ),
            child: const Text("登出", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border.symmetric(horizontal: BorderSide(color: MyTheme.lightGrey)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.black54,
          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "首頁",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_outlined),
              activeIcon: Icon(Icons.notifications),
              label: "通知",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_outlined),
              activeIcon: Icon(Icons.menu),
              label: "功能",
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
