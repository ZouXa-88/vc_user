import 'dart:async';
import 'dart:convert';

import 'package:user/backend_processes/connector.dart';
import 'package:user/backend_processes/storage.dart';
import 'package:user/objects/key_list.dart';


final Updater updater = Updater();

class Updater {

  Timer? _updateTimer;
  bool _updateSuccessful = true;
  String _updateFailedMessage = "";


  bool isSuccessful() {
    return _updateSuccessful;
  }

  String getFailedMessage() {
    return _updateFailedMessage;
  }

  void startPeriodicUpdate() {
    if(_updateTimer == null || !_updateTimer!.isActive) {
      _resetState();
      update();
      _updateTimer = Timer.periodic(
        const Duration(seconds: 3),
        (timer) => update(),
      );
    }
  }

  void stopPeriodicUpdate() {
    if(_updateTimer != null && _updateTimer!.isActive){
      _updateTimer!.cancel();
    }
  }

  Future<void> update() async {
    final response = await connector.getKeys();
    try{
      if(response.isOk()){
        await updateData(response.data);
        _resetState();
      }
      else{
        throw Exception(response.getErrorMessage());
      }
    }
    catch(e){
      _setUpdateFailed(message: e.toString());
    }
  }

  Future<void> updateData(List<dynamic> data) async {
    await storage.clearAllShares();
    keyList.clearKeys();
    final keys = List<Map<String, dynamic>>.from(data);

    for(Map<String, dynamic> key in keys){
      String doorName = utf8.decode((key["door_name"]! as String).codeUnits);
      String share = key["share"]! as String;
      keyList.addKey(doorName);
      await storage.storeShare(doorName, share);
    }
  }

  void _setUpdateFailed({String message = ""}) {
    _updateSuccessful = false;
    _updateFailedMessage = message;
  }

  void _resetState() {
    _updateSuccessful = true;
    _updateFailedMessage = "";
  }
}