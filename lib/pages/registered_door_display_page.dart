import 'package:flutter/material.dart';
import 'package:user/pages/register_door_page.dart';

import 'package:user/utilities/account.dart';

class RegisteredDoorDisplayPage extends StatelessWidget {

  late final List<String> _registeredDoorsName;


  RegisteredDoorDisplayPage({super.key}) {
    _registeredDoorsName = currentAccount.getAllRegisteredDoorsName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Align(
          alignment: Alignment.centerRight,
          child: Text("可解鎖的門鎖", style: TextStyle(color: Theme.of(context).primaryColor),),
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
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Scrollbar(
          child: ListView.builder(
            itemCount: currentAccount.getNumRegisteredDoors(),
            itemBuilder: (BuildContext buildContext, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  color: Colors.green[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.door_front_door),
                    title: Text(_registeredDoorsName[index]),
                  ),
                ),
              );
            },
            physics: const BouncingScrollPhysics(),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RegisterDoorPage(),
            )
          );
        },
        icon: const Icon(Icons.add_outlined),
        label: const Text("新增門鎖"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.blue[400],
        ),
      ),
    );
  }
}