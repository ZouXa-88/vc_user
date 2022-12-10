import 'dart:collection';
import 'dart:typed_data';


// ==========Shares==========

class Shares {

  Map<String, Uint8List> _shares = {};


  void add(String key, Uint8List value) {
    _shares[key] = value;
  }

  String keyAt(int index) {
    return _shares.keys.elementAt(index);
  }

  bool containsKey(String key) {
    return _shares.containsKey(key);
  }

  Uint8List? getShare(String key) {
    if(_shares.containsKey(key)) {
      return _shares[key];
    }
    return null;
  }

  int length() {
    return _shares.length;
  }
}

// ==========Shares==========

// ==========AvailableAccount==========

class AvailableAccount {
  final List<Account> _accounts = List.empty(growable: true);
}

// ==========AvailableAccount==========

// ==========Account==========

class Account {
  late String name;

}

// ==========Account==========