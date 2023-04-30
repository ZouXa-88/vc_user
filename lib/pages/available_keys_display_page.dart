import 'dart:async';

import 'package:flutter/material.dart';

import 'package:user/modules/app_theme.dart';
import 'package:user/objects/account.dart';


class AvailableKeysDisplayPage extends StatefulWidget {
  const AvailableKeysDisplayPage({super.key});

  @override
  State<StatefulWidget> createState() => _AvailableKeysDisplayPage();
}

class _AvailableKeysDisplayPage extends State<AvailableKeysDisplayPage> {

  late final List<String> _registeredDoorsName;
  late final Timer _fadeInTimer;
  bool _cardVisible = false;


  @override
  void initState() {
    _registeredDoorsName = account.getAllKeys();
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
        child: Scrollbar(
          child: AnimatedOpacity(
            opacity: _cardVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: ListView.builder(
              itemCount: account.getNumKeys(),
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
        ),
      ),
    );
  }
}