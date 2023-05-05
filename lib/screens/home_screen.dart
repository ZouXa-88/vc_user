import 'package:flutter/material.dart';

import 'package:user/modules/app_theme.dart';
import 'package:user/modules/page_switcher.dart';
import 'package:user/pages/delete_key_page.dart';
import 'package:user/pages/report_error_page.dart';
import 'package:user/pages/qr_code_scanner_page.dart';
import 'package:user/pages/apply_key_page.dart';
import 'package:user/pages/display_keys_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  Widget _rectangleContainer({List<Widget> contents = const []}) {
    return Container(
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: contents,
      ),
    );
  }

  Widget _functionButton({
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
            _rectangleContainer(
              contents: [
                _functionButton(
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
              ],
            ),
            _rectangleContainer(
              contents: [
                _functionButton(
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
                _functionButton(
                  label: "申請鑰匙",
                  imagePath: "assets/gifs/plus.gif",
                  onPressed: () {
                    PageSwitcher.pushPage(
                      context: context,
                      destinationPage: const ApplyKeyPage(enableScan: true),
                      lottiePath: "assets/lotties/plus.json",
                      label: "申請鑰匙",
                    );
                  },
                ),
                _functionButton(
                  label: "刪除特定鑰匙",
                  imagePath: "assets/gifs/remove.gif",
                  onPressed: () {
                    PageSwitcher.pushPage(
                      context: context,
                      destinationPage: const DeleteKeyPage(),
                      lottiePath: "assets/lotties/delete.json",
                      label: "刪除特定鑰匙",
                    );
                  },
                ),
              ],
            ),
            _rectangleContainer(
              contents: [
                _functionButton(
                  label: "問題通報",
                  imagePath: "assets/gifs/alert.gif",
                  onPressed: () {
                    PageSwitcher.pushPage(
                      context: context,
                      destinationPage: const ReportErrorPage(),
                      lottiePath: "assets/lotties/warning.json",
                      label: "問題通報",
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}