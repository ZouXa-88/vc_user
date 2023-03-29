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
        title: const Text("可解鎖的門鎖"),
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
                ),
              );
            },
            physics: const BouncingScrollPhysics(),
          ),
        ),
      ),
      floatingActionButton: TextButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RegisterDoorPage(),
            )
          );
        },
        icon: const Icon(Icons.add_outlined),
        label: const Text("新增門鎖"),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}