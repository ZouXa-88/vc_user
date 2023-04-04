import 'package:flutter/material.dart';

import 'package:user/utilities/account.dart';
import 'package:user/utilities/connector.dart';
import 'package:user/abstract_classes/dialog_presenter.dart';

class DeleteDoorPage extends StatefulWidget {
  const DeleteDoorPage({super.key});

  @override
  State<DeleteDoorPage> createState() => _DeleteDoorPage();
}

class _DeleteDoorPage extends State<DeleteDoorPage> with DialogPresenter {

  late final List<String> _registeredDoorsName;


  Future<void> _delete(BuildContext context, {required String doorName}) async {
    showProcessingDialog(context, "傳送中...");

    final response = await connector.deleteDoor(doorName: doorName);

    if(context.mounted){
      closeDialog(context);
      if(response.isOk()){
        showProcessResultDialog(context, "傳送成功");
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.objectNotExistError:
            errorDescription = "此門($doorName)不存在";
            break;
          case StatusType.youNotHaveThisKeyError:
            errorDescription = "您未擁有這扇門的鑰匙";
            break;
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
  initState() {
    _registeredDoorsName = account.getAllRegisteredDoorNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Align(
          alignment: Alignment.centerRight,
          child: Text("刪除門鎖", style: TextStyle(color: Theme.of(context).primaryColor),),
        ),
        backgroundColor: Colors.grey[100],
        shadowColor: Colors.transparent,
        foregroundColor: Colors.grey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: const Text("點選要刪除的門鎖"),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: account.getNumRegisteredDoors(),
                  itemBuilder: (BuildContext buildContext, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.door_front_door),
                          title: Text(_registeredDoorsName[index]),
                          onTap: () {
                            showConfirmDialog(context, "刪除門鎖", description: "確定要刪除 ${_registeredDoorsName[index]}?")
                              .then((confirm) {
                                if(confirm){
                                  _delete(context, doorName: _registeredDoorsName[index]);
                                }
                            });
                          },
                        ),
                      ),
                    );
                  },
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
