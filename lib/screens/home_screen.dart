import 'package:flutter/material.dart';

import 'package:user/modules/app_theme.dart';
import 'package:user/modules/page_switcher.dart';
import 'package:user/pages/delete_key_page.dart';
import 'package:user/pages/inform_blacklist_page.dart';
import 'package:user/pages/qr_code_scanner_page.dart';
import 'package:user/pages/create_key_page.dart';
import 'package:user/pages/display_keys_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  Widget _primaryFunctionButton({
    required String label,
    required String imagePath,
    required void Function() onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset.fromDirection(45, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 70,
              height: 70,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondaryFunctionButton({
    required String label,
    required String imagePath,
    required void Function() onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.white24,
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Expanded> [
              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _roundedRectangleBorderIcon({
    required IconData iconData,
    required Color backgroundColor,
  }) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Icon(
        iconData,
        size: 35,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          "首頁",
          style: TextStyle(
            letterSpacing: 3,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: _primaryFunctionButton(
                    label: "掃QR Code",
                    imagePath: "assets/gifs/qr_code.gif",
                    onPressed: () {
                      PageSwitcher.pushPage(
                        context: context,
                        destinationPage: const QrCodeScannerPage(),
                        lottiePath: "assets/lotties/qr_scanner.json",
                        label: "掃QR Code",
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 5,
                  child: _primaryFunctionButton(
                    label: "通報為黑名單",
                    imagePath: "assets/gifs/alert.gif",
                    onPressed: () {
                      PageSwitcher.pushPage(
                        context: context,
                        destinationPage: const InformBlacklistPage(),
                        lottiePath: "assets/lotties/warning.json",
                        label: "通報為黑名單",
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset.fromDirection(45, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                children: [
                  _secondaryFunctionButton(
                    label: "新增鑰匙",
                    imagePath: "assets/gifs/plus.gif",
                    onPressed: () {
                      PageSwitcher.pushPage(
                        context: context,
                        destinationPage: const CreateKeyPage(enableScan: true),
                        lottiePath: "assets/lotties/plus.json",
                        label: "新增鑰匙",
                      );
                    },
                  ),
                  _secondaryFunctionButton(
                    label: "刪除鑰匙",
                    imagePath: "assets/gifs/remove.gif",
                    onPressed: () {
                      PageSwitcher.pushPage(
                        context: context,
                        destinationPage: const DeleteKeyPage(),
                        lottiePath: "assets/lotties/delete.json",
                        label: "刪除鑰匙",
                      );
                    },
                  ),
                  _secondaryFunctionButton(
                    label: "鑰匙清單",
                    imagePath: "assets/gifs/list.gif",
                    onPressed: () {
                      PageSwitcher.pushPage(
                        context: context,
                        destinationPage: const DisplayKeysPage(),
                        lottiePath: "assets/lotties/list.json",
                        label: "鑰匙清單",
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}