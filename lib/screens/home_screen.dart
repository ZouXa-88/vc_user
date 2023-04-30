import 'package:flutter/material.dart';

import 'package:tab_container/tab_container.dart';

import 'package:user/modules/dialog_presenter.dart';
import 'package:user/modules/app_theme.dart';
import 'package:user/modules/page_switcher.dart';
import 'package:user/pages/delete_key_page.dart';
import 'package:user/pages/inform_blacklist_page.dart';
import 'package:user/pages/qr_code_scanner_page.dart';
import 'package:user/pages/create_key_page.dart';
import 'package:user/pages/available_keys_display_page.dart';
import 'package:user/objects/account.dart';
import 'package:user/backend_processes/connector.dart';
import 'package:user/backend_processes/storage.dart';
import 'package:user/backend_processes/updater.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  Future<void> _update() async {
    DialogPresenter.showProcessingDialog(context, "更新中");

    ConnectResponse response = await connector.update();

    List<String>? deleteDoors = response.data["deleteDoors"];
    Map<String, String>? newShares = response.data["newShares"];

    if(deleteDoors != null){
      for(String doorName in deleteDoors){
        account.deleteKey(doorName);
        storage.deleteShare(doorName);
      }
    }
    if(newShares != null){
      newShares.forEach((doorName, share) {
        account.addKey(doorName);
        storage.storeShare(doorName, share);
      });
    }

    if(context.mounted){
      DialogPresenter.closeDialog(context);
      if(response.isOk()){
        DialogPresenter.showInformDialog(context, "更新成功");
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.programExceptionError:
            errorDescription = response.data["reason"];
            break;
          case StatusType.connectionError:
            errorDescription = "無法連線";
            break;
          case StatusType.notAuthenticatedError:
            errorDescription = "請登入";
            return;
          case StatusType.unknownError:
            errorDescription = response.data["reason"];
            break;
          default:
            errorDescription = "";
        }
        DialogPresenter.showInformDialog(context, "更新失敗", description: errorDescription);
      }
    }
  }

  Widget _primaryFunctionButton({
    required String label,
    required String imagePath,
    required void Function() onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 150,
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
    required Widget icon,
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
                  child: icon,
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
                      color: Colors.white,
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

  List<Widget> _getUserMenuItems() {
    return <Widget> [
      _secondaryFunctionButton(
        label: "新增鑰匙",
        icon: _roundedRectangleBorderIcon(
          iconData: Icons.add,
          backgroundColor: Colors.blueAccent,
        ),
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
        icon: _roundedRectangleBorderIcon(
          iconData: Icons.delete,
          backgroundColor: Colors.redAccent,
        ),
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
        icon: _roundedRectangleBorderIcon(
          iconData: Icons.list,
          backgroundColor: Colors.grey,
        ),
        onPressed: () {
          PageSwitcher.pushPage(
            context: context,
            destinationPage: const AvailableKeysDisplayPage(),
            lottiePath: "assets/lotties/list.json",
            label: "鑰匙清單",
          );
        },
      ),
      _secondaryFunctionButton(
        label: "通報為黑名單",
        icon: _roundedRectangleBorderIcon(
          iconData: Icons.warning,
          backgroundColor: Colors.orangeAccent,
        ),
        onPressed: () {
          PageSwitcher.pushPage(
            context: context,
            destinationPage: const InformBlacklistPage(),
            lottiePath: "assets/lotties/warning.json",
            label: "通報為黑名單",
          );
        },
      ),
    ];
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _primaryFunctionButton(
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
                _primaryFunctionButton(
                  label: "更新資料",
                  imagePath: "assets/gifs/update.gif",
                  onPressed: () {
                    _update();
                  },
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: AppTheme.lightGrey,
                thickness: 1.2,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: AppTheme.green,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: _getUserMenuItems(),
              ),
              /*
              child: IntrinsicHeight(
                child: TabContainer(
                  isStringTabs: false,
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Image.asset("assets/images/selfie.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Image.asset("assets/images/businessman.png"),
                    ),
                  ],
                  colors: const [
                    AppTheme.green,
                    AppTheme.blue,
                  ],
                  childPadding: const EdgeInsets.only(top: 10),
                  children: [
                    _getUserMenu(),
                    _getAdminMenu(),
                  ],
                ),
              ),
              */
            ),
          ],
        ),
      ),
    );
  }
}