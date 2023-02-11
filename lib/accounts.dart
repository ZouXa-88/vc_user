import 'dart:typed_data';

Accounts accounts = Accounts();
Account currentAccount = Account("000", "unknown");

// ==========Accounts==========

class Accounts {

  final Map<String, Account> _accounts = {};


  void addAccount(Account account) {
    _accounts[account.getName()] = account;
  }

  Account? getAccount(String accountId) {
    if(_accounts.containsKey(accountId)){
      return _accounts[accountId];
    }
    return null;
  }

  List<Account> getAllAccounts() {
    return List.of(_accounts.values);
  }
}

// ==========Accounts==========

// ==========Account==========

class Account {

  late String _id;
  late String _name;
  final Map<String, Door> _availableDoors = {};


  Account(final String id, final String name) {
    setId(id);
    setName(name);
  }

  void setId(String id) {
    _id = id;
  }

  void setName(String name) {
    _name = name;
  }

  void addDoor(String id, String name, Uint8List share) {
    _availableDoors[id] = Door(id, name, share);
  }

  bool isRegistered(String doorId) {
    return _availableDoors.containsKey(doorId);
  }

  String getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  Door? getDoor(String doorId) {
    if(isRegistered(doorId)){
      return _availableDoors[doorId]!;
    }
    return null;
  }

  int getNumRegisteredDoors() {
    return _availableDoors.length;
  }

  List<Door> getAllRegisteredDoors() {
    return List.of(_availableDoors.values);
  }
}

// ==========Account==========

// ==========Door==========

class Door {

  late String _id;
  late String _name;
  late Uint8List _share;


  Door(final String id, final String name, final Uint8List share) {
    _id = id;
    _name = name;
    _share = share;
  }

  String getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  Uint8List getShare() {
    return _share;
  }
}

// ==========Door==========