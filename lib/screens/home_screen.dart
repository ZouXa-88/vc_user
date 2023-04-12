import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';

import 'package:user/abstract_classes/dialog_presenter.dart';
import 'package:user/abstract_classes/my_theme.dart';
import 'package:user/pages/delete_key_page.dart';
import 'package:user/pages/qr_code_scanner_page.dart';
import 'package:user/pages/create_key_page.dart';
import 'package:user/pages/available_keys_display_page.dart';
import 'package:user/utilities/account.dart';
import 'package:user/utilities/connector.dart';
import 'package:user/utilities/storage.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with DialogPresenter {

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

  Widget _primaryFunctionButton({
      required String label,
      required String imagePath,
      required void Function() onPressed
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 150,
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
          mainAxisSize: MainAxisSize.min,
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
      required IconData iconData,
      required void Function() onPressed
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: Icon(
                  iconData,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20,
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
  
  void _gradientIcon(IconData iconData) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _primaryFunctionButton(
                  label: "掃QR Code",
                  imagePath: "assets/images/qr_code.gif",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QrCodeScannerPage())
                    );
                  },
                ),
                _primaryFunctionButton(
                  label: "更新資料",
                  imagePath: "assets/images/update.gif",
                  onPressed: () {
                    _update(context);
                  },
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: MyTheme.lightGrey,
                thickness: 1.2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: IntrinsicHeight(
                child: TabContainer(
                  isStringTabs: false,
                  tabs: <Image> [
                    Image.asset("assets/images/selfie.png"),
                    Image.asset("assets/images/businessman.png"),
                  ],
                  colors: const [
                    MyTheme.green,
                    MyTheme.blue,
                  ],
                  childPadding: const EdgeInsets.only(top: 10),
                  children: [
                    // User menu.
                    Column(
                      children: [
                        const Text(
                          "使用者",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        const Divider(
                          indent: 40,
                          endIndent: 40,
                          color: Colors.white54,
                          thickness: 1,
                        ),
                        _secondaryFunctionButton(
                          label: "新增鑰匙",
                          iconData: Icons.add,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CreateKeyPage(enableScan: true))
                            );
                          },
                        ),
                        _secondaryFunctionButton(
                          label: "刪除鑰匙",
                          iconData: Icons.delete,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DeleteKeyPage())
                            );
                          },
                        ),
                        _secondaryFunctionButton(
                          label: "鑰匙清單",
                          iconData: Icons.list,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AvailableKeysDisplayPage())
                            );
                          },
                        ),
                      ],
                    ),
                    // Admin menu.
                    Column(
                      children: [
                        const Text(
                          "管理者",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        const Divider(
                          indent: 40,
                          endIndent: 40,
                          color: Colors.white54,
                          thickness: 1,
                        ),
                        _secondaryFunctionButton(
                          label: "新增門鎖",
                          iconData: Icons.add,
                          onPressed: () {
                            // TODO: Create door page.
                          },
                        ),
                        _secondaryFunctionButton(
                          label: "刪除門鎖",
                          iconData: Icons.delete,
                          onPressed: () {
                            // TODO: Delete door page.
                          },
                        ),
                        _secondaryFunctionButton(
                          label: "門鎖清單",
                          iconData: Icons.list,
                          onPressed: () {
                            // TODO: Doors display page.
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}