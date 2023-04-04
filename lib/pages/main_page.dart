import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:user/abstract_classes/dialog_presenter.dart';
import 'package:user/abstract_classes/my_theme.dart';
import 'package:user/pages/login_page.dart';
import 'package:user/pages/qr_code_key_page.dart';
import 'package:user/pages/register_door_page.dart';
import 'package:user/pages/delete_door_page.dart';
import 'package:user/pages/registered_door_display_page.dart';
import 'package:user/utilities/account.dart';
import 'package:user/utilities/connector.dart';
import 'package:user/utilities/storage.dart';


// ==========MainPage==========

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> with DialogPresenter {

  int _selectedIndex = 0;
  final _pages = <Widget>[
    const FunctionScreen(),
    const ScannerScreen(),
    const NotificationScreen(),
    const PersonalityScreen()
  ];
  final _titles = <Text>[
    const Text("首頁"),
    const Text("掃描"),
    const Text("通知"),
    const Text("個人資訊")
  ];


  Future<void> _update(BuildContext context) async {
    showProcessingDialog(context, "更新中");

    ConnectResponse response = await connector.update();

    List<String>? deleteDoors = response.data["deleteDoors"];
    Map<String, String>? newShares = response.data["newShares"];

    if(deleteDoors != null){
      for(String doorName in deleteDoors){
        account.deleteDoor(doorName);
        storage.deleteShare(doorName);
      }
    }
    if(newShares != null){
      newShares.forEach((doorName, share) {
        account.addDoor(doorName);
        storage.storeShare(doorName, share);
      });
    }

    if(context.mounted){
      closeDialog(context);
      if(response.isOk()){
        showProcessResultDialog(context, "更新成功");
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.connectionError:
            errorDescription = "無法連線";
            break;
          case StatusType.notAuthenticatedError:
            showRequireLoginDialog(context);
            return;
          case StatusType.unknownError:
            errorDescription = response.data["reason"];
            break;
          default:
            errorDescription = "";
        }
        showProcessResultDialog(context, "更新失敗", description: errorDescription);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _titles[_selectedIndex],
        shadowColor: Colors.transparent,
        // TODO: Remove it.
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          ),
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: Colors.grey,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _update(context);
            },
            icon: const Icon(Icons.update),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.qr_code_scanner_outlined),
            activeIcon: Icon(Icons.qr_code_scanner),
            label: "掃描",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_outlined),
            activeIcon: Icon(Icons.notifications),
            label: "通知",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: "個人資訊",
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// ==========MainPage==========

// Belows are four screens of bottom navigation.

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
      backgroundColor: MyTheme.background,
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                _functionButton(
                  label: "新增門鎖鑰匙",
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

      String doorName = stringData.first.replaceAll("d=", "");
      int? seed = int.tryParse(stringData.last.replaceAll("s=", ""));
      if(!account.hasKey(doorName) || seed == null){
        return;
      }

      controller.pauseCamera();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrCodeKeyPage(doorName: doorName, seed: seed),
        ),
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

// ==========NotificationScreen==========

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: MyTheme.background,
    );
  }
}

// ==========NotificationScreen==========

// ==========PersonalityScreen==========

class PersonalityScreen extends StatefulWidget {
  const PersonalityScreen({super.key});

  @override
  State<PersonalityScreen> createState() => _PersonalityScreen();
}

class _PersonalityScreen extends State<PersonalityScreen> with DialogPresenter {

  Future<void> _deleteAccount(BuildContext context) async {
    showProcessingDialog(context, "傳送中");

    ConnectResponse response = await connector.deleteAccount();

    if(context.mounted){
      closeDialog(context);
      if(response.isOk()){
        showProcessResultDialog(context, "傳送成功");
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.connectionError:
            errorDescription = "無法連線";
            break;
          case StatusType.notAuthenticatedError:
            showRequireLoginDialog(context);
            return;
          case StatusType.unknownError:
            errorDescription = response.data["reason"];
            break;
          default:
            errorDescription = "";
        }
        showProcessResultDialog(context, "傳送失敗", description: errorDescription);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.background,
      body: Column(
        children: [
          const Expanded(
            flex: 2,
            child: Icon(
              Icons.account_circle_rounded,
              color: Colors.grey,
              size: 100,
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                account.getName(),
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Scrollbar(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <ElevatedButton>[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.key_rounded),
                      label: const Text("可解鎖的門鎖"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisteredDoorDisplayPage()),
                        );
                      },
                    ),
                    /*
                    ElevatedButton.icon(
                      icon: const Icon(Icons.admin_panel_settings_rounded),
                      label: const Text("管理的門鎖"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisteredDoorDisplayPage()),
                        );
                      },
                    ),
                    */
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text("刪除帳號"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                      ),
                      onPressed: () {
                        showConfirmDialog(context, "刪除帳號", description: "確定要刪除此帳號?")
                          .then((confirm) {
                            if(confirm){
                              _deleteAccount(context);
                            }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ==========PersonalityScreen==========