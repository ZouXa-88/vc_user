import 'dart:typed_data';

Accounts accounts = Accounts();
Account currentAccount = Account();

// ==========Accounts==========

class Accounts {

  final Map<String, Account> _accounts = {};


  void addAccount(Account account) {
    _accounts[account.getName()] = account;
  }

  Account? getAccount(String name) {
    if(_accounts.containsKey(name)){
      return _accounts[name];
    }
    return null;
  }
}

// ==========Accounts==========

// ==========Account==========

class Account {

  String _name = "";
  Map<String, Uint8List> _shares = {};


  void setName(String name) {
    _name = name;
  }

  void addShare(String doorName, Uint8List share) {
    _shares[doorName] = share;
  }

  bool isRegistered(String doorName) {
    return _shares.containsKey(doorName);
  }

  String getName() {
    return _name;
  }

  Uint8List? getShare(String doorName) {
    if(isRegistered(doorName)) {
      return _shares[doorName];
    }
    return null;
  }

  int getNumRegisteredDoors() {
    return _shares.length;
  }

  List<String> getRegisteredDoorsList() {
    return List.of(_shares.keys);
  }
}

// ==========Account==========