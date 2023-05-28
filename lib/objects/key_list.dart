KeyList keyList = KeyList();

class KeyList {

  late List<String> _keys;


  KeyList() {
    _keys = List.empty(growable: true);
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

  int getNumKeys() {
    return _keys.length;
  }

  List<String> getAllKeys() {
    return _keys;
  }
}