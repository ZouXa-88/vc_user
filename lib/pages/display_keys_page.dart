import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:user/modules/app_theme.dart';
import 'package:user/objects/key_list.dart';


class DisplayKeysPage extends StatefulWidget {
  const DisplayKeysPage({super.key});

  @override
  State<StatefulWidget> createState() => _DisplayKeysPage();
}

class _DisplayKeysPage extends State<DisplayKeysPage> {

  late final List<String> _registeredDoorsName;
  late final Timer _fadeInTimer;
  bool _cardVisible = false;


  @override
  void initState() {
    _registeredDoorsName = keyList.getAllKeys();
    _fadeInCardRespectively();
    super.initState();
  }

  Future<void> _fadeInCardRespectively() async {
    _fadeInTimer = Timer(const Duration(microseconds: 1), () {
      setState(() {
        _cardVisible = true;
      });
    });
  }

  @override
  void dispose() {
    if(_fadeInTimer.isActive){
      _fadeInTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("鑰匙清單"),
      ),
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: keyList.getAllKeys().isNotEmpty
            ? Scrollbar(
              child: AnimatedOpacity(
                opacity: _cardVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                child: ListView.builder(
                  itemCount: keyList.getNumKeys(),
                  itemBuilder: (BuildContext buildContext, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
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
            )
            : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/lotties/astronaut.json"
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: const Text(
                      "無鑰匙",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                      ),
                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }
}