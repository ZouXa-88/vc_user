import 'package:flutter/material.dart';

import 'package:user/utilities/accounts.dart';
import 'package:user/utilities/connector.dart';

class RegisterDoor extends StatefulWidget {
  const RegisterDoor({super.key});

  @override
  State<RegisterDoor> createState() => _RegisterDoor();
}

class _RegisterDoor extends State<RegisterDoor> {

  final _formKey = GlobalKey<FormState>();
  String _doorName = "";
  String _reason = "";


  Future<void> _register(BuildContext context, {required String doorName}) async {

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("新增門鎖"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  initialValue: "",
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "門鎖名稱",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _doorName = text;
                    });
                  },
                  validator: (text) {
                    return (text == null || text.isEmpty) ? "請輸入門鎖名稱" : null;
                  },
                ),
              ),
              /*
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  initialValue: "",
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: "新增原因",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _registerReason = text;
                    });
                  },
                  validator: (text) {
                    return (text == null || text.isEmpty) ? "請輸入新增原因" : null;
                  },
                ),
              ),
              */
              TextButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("傳送"),
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    connector.registerDoor(doorName: _doorName);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
