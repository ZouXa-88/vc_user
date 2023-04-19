import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import 'package:user/backend_processes/notifications_box.dart';
import 'package:user/backend_processes/updater.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/screens/notification_screen.dart';
import 'package:user/screens/account_screen.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {

  int _selectedIndex = 0;
  final PageController _pageController = PageController();


  @override
  void initState() {
    updater.startPeriodicUpdate();
    super.initState();
  }

  @override
  void dispose() {
    updater.stopPeriodicUpdate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SnakeNavigationBar.color(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        snakeShape: SnakeShape.indicator,
        snakeViewColor: CupertinoColors.activeBlue,
        selectedItemColor: CupertinoColors.activeBlue,
        unselectedItemColor: CupertinoColors.inactiveGray,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const <Widget> [
          HomeScreen(),
          NotificationScreen(),
          AccountScreen(),
        ],
      ),
    );
  }
}
