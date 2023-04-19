import 'dart:convert';

Account account = Account(name: "Guest");

class Account {

  late String _name;
  final Set<String> _keys = {};
  final Set<String> _doors = {};


  Account({required String name, List<String> keys = const []}) {
    _name = name;
    _keys.addAll(keys);
  }

  void addKey(String doorName) {
    _keys.add(doorName);
  }

  void deleteKey(String doorName) {
    _keys.remove(doorName);
  }

  bool hasKey(String doorName) {
    return _keys.contains(doorName);
  }

  String getName() {
    return _name;
  }

  int getNumKeys() {
    return _keys.length;
  }

  List<String> getAllKeys() {
    return _keys.toList();
  }

  String buildAccountData() {
    return jsonEncode({
      "name": _name,
      "doors": _keys.join(","),
    });
  }

  static Account from(final String jsonString) {
    final json = jsonDecode(jsonString);
    return Account(
      name: json["name"],
      keys: (json["doors"]).split(","),
    );
  }
}