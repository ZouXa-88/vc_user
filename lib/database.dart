import 'dart:collection';
import 'dart:typed_data';

Database database = Database();

// ==========Database==========

class Database {

  Shares shares = Shares();
  History history = History();
}

// ==========Database==========

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

// ==========History==========

class History {

  Queue<HistoryData> _history = Queue();


  void addNewHistory(String door) {
    _history.add(HistoryData(door, _getCurrentTime()));

    if(_history.length > 10){
      _history.removeFirst();
    }
  }

  HistoryData elementAt(int index) {
    return _history.elementAt(_history.length - 1 - index); // reverse
  }

  int length() {
    return _history.length;
  }

  String _getCurrentTime() {
    final now = DateTime.now();

    return "${now.month}/${now.day} " +
        now.hour.toString().padLeft(2, "0") + ":" +
        now.minute.toString().padLeft(2, "0") + ":" +
        now.second.toString().padLeft(2, "0");
  }
}

// ==========History==========

// ==========HistoryData==========

class HistoryData {

  late String _doorName;
  late String _time;
  
  
  HistoryData(String door, String time) {
    _doorName = door;
    _time = time;
  }
  
  String getDoor() {
    return _doorName;
  }
  
  String getTime() {
    return _time;
  }
}

// ==========HistoryData==========