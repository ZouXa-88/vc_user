import 'package:flutter/material.dart';

import 'package:user/accounts.dart';
import 'route/registered_door_display.dart';
import 'package:user/dev.dart';

class PersonalityPage extends StatefulWidget{
  const PersonalityPage({super.key});

  @override
  State<PersonalityPage> createState() => _PersonalityPage();
}

class _PersonalityPage extends State<PersonalityPage> {

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
                children: <ElevatedButton>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.app_registration),
                    label: const Text("可解鎖的門鎖"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisteredDoorDisplay()),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text("刪除帳號"),
                    onPressed: () {

                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                    ),
                  ),
                  /*
                  ElevatedButton.icon(
                    icon: const Icon(Icons.developer_mode_rounded),
                    label: const Text("develop options"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Dev()),
                      );
                    },
                  ),
                  */
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
