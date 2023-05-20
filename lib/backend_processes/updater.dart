import 'dart:async';
import 'dart:convert';

import 'package:user/backend_processes/connector.dart';
import 'package:user/backend_processes/notifications_box.dart';
import 'package:user/backend_processes/storage.dart';
import 'package:user/objects/account.dart';


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
        const Duration(seconds: 10),
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
    final response = await connector.update();
    try{
      if(response.isOk()){
        await updateData(response.data);
      }
      else{
        throw Exception(response.getErrorMessage());
      }
    }
    catch(e){
      _setUpdateFailed(message: e.toString());
      print(e.toString());
    }
  }

  Future<void> updateData(final data) async {
    //await storage.clearAllShares();
    final deleteDoors = List<String>.from(data["deleteDoors"] as List);
    final newShares = List<Map<String, dynamic>>.from(data["newShares"] as List);

    for(String doorName in deleteDoors){
      doorName = utf8.decode(doorName.codeUnits);
      account.deleteKey(doorName);
      storage.deleteShare(doorName);

      notificationsBox.addNotification(
        UpdateNotification(
          type: NotificationType.deleteKey,
          content: doorName,
        ),
      );
    }

    for(Map<String, dynamic> newShare in newShares) {
      String doorName = utf8.decode((newShare["doorName"]! as String).codeUnits);
      String share = newShare["share"]! as String;
      account.addKey(doorName);
      await storage.storeShare(doorName, share);

      notificationsBox.addNotification(
        UpdateNotification(
          type: NotificationType.newKey,
          content: doorName,
        ),
      );
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