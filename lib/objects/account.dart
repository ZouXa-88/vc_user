Account account = Account();

class Account {

  late String _name;
  late List<String> _keys;


  Account() {
    _name = "";
    _keys = List.empty(growable: true);
  }

  void setName(String name) {
    _name = name;
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

  void clearKeys() {
    _keys.clear();
  }

  String getName() {
    return _name;
  }

  int getNumKeys() {
    return _keys.length;
  }

  List<String> getAllKeys() {
    return _keys;
  }

  void clear() {
    _name = "";
    _keys.clear();
  }
}