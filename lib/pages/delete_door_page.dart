import 'package:flutter/material.dart';

import 'package:user/utilities/accounts.dart';
import 'package:user/utilities/connector.dart';
import 'package:user/utilities/dialog_presenter.dart';

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

      }
      else{

      }
    }
  }

  @override
  initState() {
    _registeredDoorsName = currentAccount.getAllRegisteredDoorsName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("刪除門鎖"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Scrollbar(
          child: ListView.builder(
            itemCount: currentAccount.getNumRegisteredDoors(),
            itemBuilder: (BuildContext buildContext, int index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.door_front_door),
                  title: Text(_registeredDoorsName[index]),
                  trailing: OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                    ),
                    onPressed: () {
                      connector.deleteDoor(doorName: _registeredDoorsName[index]);
                    },
                    child: const Text("刪除", style: TextStyle(color: Colors.white)),
                  ),
                ),
              );
            },
            physics: const BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
