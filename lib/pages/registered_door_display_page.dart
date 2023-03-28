import 'package:flutter/material.dart';

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
    );
  }
}