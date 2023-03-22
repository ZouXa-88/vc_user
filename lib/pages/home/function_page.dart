import 'package:flutter/material.dart';
import 'package:user/pages/home/route/delete_door.dart';

import 'route/register_door.dart';

class FunctionPage extends StatelessWidget {
  const FunctionPage({super.key});

  Widget _functionButton({required String label, required void Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        width: 200,
        height: 80,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(label, style: const TextStyle(fontSize: 20),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                _functionButton(
                  label: "申請門鎖鑰匙",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterDoor())
                    );
                  },
                ),
                _functionButton(
                  label: "刪除門鎖鑰匙",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DeleteDoor())
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}