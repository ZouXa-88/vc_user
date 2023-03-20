import 'dart:convert';
import 'dart:typed_data';

Accounts accounts = Accounts();
Account currentAccount = Account(id: "000", name: "unknown");

// ==========Accounts==========

class Accounts {

  final Map<String, Account> _accounts = {};


  void addAccount(Account account) {
    _accounts[account.getId()] = account;
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
  final Map<String, Door> _availableDoors = {}; // TODO: Remove it latter.
  List<String> _availableDoorsName = List.empty(growable: true);


  Account({required final String id, required final String name, final List<String>? doorsName}) {
    _id = id;
    _name = name;

    if(doorsName != null){
      _availableDoorsName = doorsName;
    }
  }

  void addDoor(String id, String name, Uint8List share) {
    _availableDoors[id] = Door(
      id: id,
      name: name,
      share: share,
    );
    _availableDoorsName.add(name);
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
    return _availableDoorsName.length;
  }

  List<Door> getAllRegisteredDoors() {
    return List.of(_availableDoors.values);
  }

  List<String> getAllRegisteredDoorsName() {
    return _availableDoorsName;
  }

  String buildAccountData() {
    return jsonEncode({
      "id": _id,
      "name": _name,
      "doors": _availableDoorsName.join(","),
    });
  }

  static Account from(final String jsonString) {
    final json = jsonDecode(jsonString);
    return Account(
      id: json["id"],
      name: json["name"],
      doorsName: (json["doors"]).split(","),
    );
  }
}

// ==========Account==========

// ==========Door==========

class Door {

  late String id; // TODO: Remove it latter.
  late String name;
  late Uint8List share;

  Door({required this.id, required this.name, required this.share});

  String buildDoorData() {
    return jsonEncode({
      "name": name,
      "share": share.join(","),
    });
  }

  static Door from(final String jsonString) {
    final json = jsonDecode(jsonString);
    return Door(
      id: "door1",
      name: json["name"],
      share: Uint8List.fromList(json["share"].split(",")),
    );
  }
}

// ==========Door==========