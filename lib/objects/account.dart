import 'dart:convert';

Account account = Account(name: "");

class Account {

  late String _name;
  final List<String> _keys = List.empty(growable: true);
  late bool _isDefault;


  Account({required String name, List<String>? keys, bool isDefault = false}) {
    _name = name;
    if(keys != null){
      _keys.addAll(keys);
    }
    _isDefault = isDefault;
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

  bool isDefault() {
    return _isDefault;
  }

  String buildAccountData() {
    return jsonEncode({
      "name": _name,
      "doors": _keys.join(","),
    });
  }

  static Account from(final String jsonString) {
    final json = jsonDecode(jsonString);
    String encodedKeys = json["doors"];
    return Account(
      name: json["name"],
      keys: encodedKeys.contains(",") ? encodedKeys.split(",") : null,
    );
  }
}