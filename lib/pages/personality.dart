import 'package:flutter/material.dart';

import 'package:user/accounts.dart';
import 'package:user/door_register.dart';

class Personality extends StatefulWidget{
  const Personality({super.key});

  @override
  _PersonalityState createState() => _PersonalityState();
}

class _PersonalityState extends State<Personality>{

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
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.app_registration),
                    label: const Text("已註冊的門鎖"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisteredDoorDisplay()),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.switch_account),
                    label: const Text("切換帳號"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: const Text("切換帳號"),
                            children: accounts.getAllAccounts().map((account) {
                              return SimpleDialogOption(
                                onPressed: () {
                                  setState(() {
                                    currentAccount = account;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(account.getName()),
                              );
                            }).toList(),
                          );
                        }
                      );
                    },
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

class RegisteredDoorDisplay extends StatelessWidget {

  List<Door> registeredDoors = List.empty();


  RegisteredDoorDisplay({super.key}) {
    registeredDoors = currentAccount.getAllRegisteredDoors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("已註冊的門鎖"),
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
                  title: Text(registeredDoors[index].getName()),
                ),
              );
            },
            physics: const BouncingScrollPhysics(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DoorRegister())
        ),
        label: const Text("新增門鎖"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}