import 'dart:convert';

Account account = Account(name: "Guest");

class Account {

  late String _name;
  final Set<String> _doorNames = {};


  Account({required String name, List<String> doorNames = const []}) {
    _name = name;
    _doorNames.addAll(doorNames);
  }

  void addDoor(String doorName) {
    _doorNames.add(doorName);
  }

  void deleteDoor(String doorName) {
    _doorNames.remove(doorName);
  }

  bool hasKey(String doorName) {
    return _doorNames.contains(doorName);
  }

  String getName() {
    return _name;
  }

  int getNumRegisteredDoors() {
    return _doorNames.length;
  }

  List<String> getAllRegisteredDoorNames() {
    return _doorNames.toList();
  }

  String buildAccountData() {
    return jsonEncode({
      "name": _name,
      "doors": _doorNames.join(","),
    });
  }

  static Account from(final String jsonString) {
    final json = jsonDecode(jsonString);
    return Account(
      name: json["name"],
      doorNames: (json["doors"]).split(","),
    );
  }
}