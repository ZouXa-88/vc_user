import 'package:flutter/material.dart';

import 'package:user/modules/app_theme.dart';
import 'package:user/modules/page_switcher.dart';
import 'package:user/pages/delete_key_page.dart';
import 'package:user/pages/report_page.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        child: Column(
          children: contents,
        ),
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
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Expanded> [
              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 50,
                    height: 50,
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
                      fontSize: 16,
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
          "Home",
          style: TextStyle(
            letterSpacing: 3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            _rectangleContainer(
              contents: [
                _functionButton(
                  label: "Scan QR Code",
                  imagePath: "assets/gifs/qr_code.gif",
                  onPressed: () {
                    PageSwitcher.pushPage(
                      context: context,
                      destinationPage: const QrCodeScannerPage(),
                      lottiePath: "assets/lotties/qr_scanner.json",
                      label: "Scan QR Code",
                    );
                  },
                ),
              ],
            ),
            _rectangleContainer(
              contents: [
                _functionButton(
                  label: "Key List",
                  imagePath: "assets/gifs/keys.gif",
                  onPressed: () {
                    PageSwitcher.pushPage(
                      context: context,
                      destinationPage: const DisplayKeysPage(),
                      lottiePath: "assets/lotties/list.json",
                      label: "Key List",
                    );
                  },
                ),
                const Divider(
                  color: AppTheme.background,
                  thickness: 1.5,
                ),
                _functionButton(
                  label: "Apply for a Key",
                  imagePath: "assets/gifs/plus.gif",
                  onPressed: () {
                    PageSwitcher.pushPage(
                      context: context,
                      destinationPage: const ApplyKeyPage(enableScan: true),
                      lottiePath: "assets/lotties/plus.json",
                      label: "Apply for a Key",
                    );
                  },
                ),
                const Divider(
                  color: AppTheme.background,
                  thickness: 1.5,
                ),
                _functionButton(
                  label: "Delete the Key",
                  imagePath: "assets/gifs/remove.gif",
                  onPressed: () {
                    PageSwitcher.pushPage(
                      context: context,
                      destinationPage: const DeleteKeyPage(),
                      lottiePath: "assets/lotties/delete.json",
                      label: "Delete the Key",
                    );
                  },
                ),
              ],
            ),
            _rectangleContainer(
              contents: [
                _functionButton(
                  label: "Report",
                  imagePath: "assets/gifs/alert.gif",
                  onPressed: () {
                    PageSwitcher.pushPage(
                      context: context,
                      destinationPage: const ReportPage(),
                      lottiePath: "assets/lotties/warning.json",
                      label: "Report",
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