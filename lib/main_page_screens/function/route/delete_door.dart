import 'package:flutter/material.dart';

import 'package:user/utilities/accounts.dart';
import 'package:user/utilities/connector.dart';

class DeleteDoor extends StatefulWidget {
  const DeleteDoor({super.key});

  @override
  State<DeleteDoor> createState() => _DeleteDoor();
}

class _DeleteDoor extends State<DeleteDoor> {

  late final List<String> _registeredDoorsName;


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
