import 'dart:convert';
import 'dart:typed_data';

Account currentAccount = Account(name: "Guest");

// ==========Account==========

class Account {

  late String _name;
  final Map<String, Door> _availableDoors = {}; // TODO: Remove it latter.
  List<String> _availableDoorsName = List.empty(growable: true);


  Account({required String name, final List<String>? doorsName}) {
    _name = name;

    if(doorsName != null){
      _availableDoorsName = doorsName;
    }
  }

  void addDoor(String name, Uint8List share) {
    _availableDoors[name] = Door(
      name: name,
      share: share,
    );
    _availableDoorsName.add(name);
  }

  bool isRegistered(String doorId) {
    return _availableDoors.containsKey(doorId);
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
      "name": _name,
      "doors": _availableDoorsName.join(","),
    });
  }

  static Account from(final String jsonString) {
    final json = jsonDecode(jsonString);
    return Account(
      name: json["name"],
      doorsName: (json["doors"]).split(","),
    );
  }
}

// ==========Account==========

// ==========Door==========

class Door {

  late String name;
  late Uint8List share;

  Door({required this.name, required this.share});

  String buildDoorData() {
    return jsonEncode({
      "name": name,
      "share": share.join(","),
    });
  }

  static Door from(final String jsonString) {
    final json = jsonDecode(jsonString);
    return Door(
      name: json["name"],
      share: Uint8List.fromList(json["share"].split(",")),
    );
  }
}

// ==========Door==========