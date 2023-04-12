import 'dart:async';

import 'package:flutter/material.dart';

import 'package:user/utilities/account.dart';


class AvailableKeysDisplayPage extends StatefulWidget {
  const AvailableKeysDisplayPage({super.key});

  @override
  State<StatefulWidget> createState() => _AvailableKeysDisplayPage();
}

class _AvailableKeysDisplayPage extends State<AvailableKeysDisplayPage> {

  late final List<String> _registeredDoorsName;
  late final Timer fadeInTimer;
  bool cardVisible = false;


  @override
  void initState() {
    _registeredDoorsName = account.getAllRegisteredDoorNames();
    _fadeInCardRespectively();
    super.initState();
  }

  Future<void> _fadeInCardRespectively() async {
    fadeInTimer = Timer(const Duration(microseconds: 1), () {
      setState(() {
        cardVisible = true;
      });
    });
  }

  @override
  void dispose() {
    if(fadeInTimer.isActive){
      fadeInTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text("鑰匙清單"),
        backgroundColor: Colors.grey[100],
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
          child: AnimatedOpacity(
            opacity: cardVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: ListView.builder(
              itemCount: account.getNumRegisteredDoors(),
              itemBuilder: (BuildContext buildContext, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    color: Colors.green[100],
                    child: ListTile(
                      leading: const Icon(Icons.key),
                      title: Text(_registeredDoorsName[index]),
                    ),
                  ),
                );
              },
              physics: const BouncingScrollPhysics(),
            ),
          ),
        ),
      ),
    );
  }
}