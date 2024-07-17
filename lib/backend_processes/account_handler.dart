import 'dart:convert';

import 'package:user/objects/key_list.dart';
import 'package:user/backend_processes/updater.dart';
import 'package:user/backend_processes/connector.dart';

final AccountHandler accountHandler = AccountHandler();

class AccountHandler {

  final String defaultShare = "vqfp7XW9xtm+3Km5dmvpfs3cPrl7t+rZNbN5u9Nz6napWunjmZw8w5U2UzY5WcVmmlZcw2amOsUzNZVpw2OWNjVso1NsOqmqxsWpZWbFpmVjPKNZOZlsmZo5OpVpaqxsNqbDyjlVnKZpyWY6XDM1yqmVM8qaU8ajrFY6VTXFyZapbDWZxjOqVVxTqszFOsNjVpbJXDqZVpw8llWmqqnJbMk5VcU5mTM2xclTyVw5PJqWnKNqpjapxsqTY2PDbJqsppVVmlallaw=";


  void setDefaultAccount() {
    keyList.clearKeys();

    updater.updateData([
      {
        "door_name": String.fromCharCodes(utf8.encode("Gate")),
        "share": defaultShare,
      },
    ]);
  }

  Future<void> resetAccount() async {
    connector.logout();
    keyList.clearKeys();
  }
}