import 'package:flutter/material.dart';

import 'package:user/utilities/accounts.dart';
import 'package:user/utilities/connector.dart';

class Dev extends StatefulWidget {
  const Dev({super.key});

  @override
  State<StatefulWidget> createState() => _Dev();
}

class _Dev extends State<Dev> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Develop Options"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
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
            TextFormField(
              initialValue: connector.getServerAddress(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text("server's address"),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) => connector.setServerAddress(text),
            ),
          ],
        ),
      ),
    );
  }
}