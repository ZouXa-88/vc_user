import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:user/pages/qr_code_page.dart';
import 'package:user/pages/register_door_page.dart';
import 'package:user/pages/delete_door_page.dart';
import 'package:user/pages/registered_door_display_page.dart';
import 'package:user/utilities/account.dart';
import 'package:user/utilities/connector.dart';


// ==========MainPage==========

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {

  int _selectedIndex = 0;
  final _pages = <Widget>[const FunctionScreen(), const ScannerScreen(), const PersonalityScreen()];
  final _titles = <Text>[const Text("首頁"), const Text("掃描"), const Text("個人資訊")];


  Future<void> _update() async {
    ConnectResponse response = await connector.update();

    List<String>? deleteDoors = response.data["deleteDoors"];
    Map<String, String>? newShares = response.data["newShares"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _titles[_selectedIndex],
        actions: [
          IconButton(
            onPressed: () {
              _update();
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

// ==========MainPage==========

// Belows are three screens of bottom navigation.

// ==========FunctionScreen==========

class FunctionScreen extends StatelessWidget {
  const FunctionScreen({super.key});

  Widget _functionButton({required String label, required void Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        width: 200,
        height: 80,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(label, style: const TextStyle(fontSize: 20),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                _functionButton(
                  label: "申請門鎖鑰匙",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterDoorPage())
                    );
                  },
                ),
                _functionButton(
                  label: "刪除門鎖鑰匙",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DeleteDoorPage())
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========FunctionScreen==========

// ==========ScannerScreen==========

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreen();
}

class _ScannerScreen extends State<ScannerScreen> {

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');


  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      this.controller!.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) {
      List<String>? stringData = scanData.code?.split('&');
      if(stringData == null || stringData.length != 2 ||
          !stringData.first.contains("d=") || !stringData.last.contains("s=")){
        return;
      }

      String doorId = stringData.first.replaceAll("d=", "");
      int? seed = int.tryParse(stringData.last.replaceAll("s=", ""));
      if(!currentAccount.isRegistered(doorId) || seed == null){
        return;
      }
      Door door = currentAccount.getDoor(doorId)!;

      controller.pauseCamera();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrCodePage(doorName: door.name, share: door.share, seed: seed),
          )
      ).then((_) {
        controller.resumeCamera();
      });
    });
  }

  @override
  void dispose() {
    controller?.pauseCamera();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        // full screen
        borderColor: Theme.of(context).primaryColor,
        borderRadius: 0,
        borderLength: 0,
        borderWidth: 0,
        cutOutWidth: MediaQuery.of(context).size.width,
        cutOutHeight: MediaQuery.of(context).size.height,
      ),
    );
  }
}

// ==========ScannerScreen==========

// ==========PersonalityScreen==========

class PersonalityScreen extends StatefulWidget{
  const PersonalityScreen({super.key});

  @override
  State<PersonalityScreen> createState() => _PersonalityScreen();
}

class _PersonalityScreen extends State<PersonalityScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            flex: 2,
            child: Icon(
              Icons.person,
              color: Colors.grey,
              size: 100,
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                currentAccount.getName(),
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20,),
              child: ListView(
                children: <ElevatedButton>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.app_registration),
                    label: const Text("可解鎖的門鎖"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisteredDoorDisplayPage()),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text("刪除帳號"),
                    onPressed: () {

                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ==========PersonalityScreen==========