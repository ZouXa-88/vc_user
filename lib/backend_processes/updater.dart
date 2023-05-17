import 'dart:async';

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
      if(response.isOk() && await _updateData(response)){
        _setUpdateSuccessful();
      }
      else{
        String? failedReason = response.data["detail"];
        throw Exception(failedReason ?? "");
      }
    }
    catch(e){
      _setUpdateFailed(message: e.toString());
    }
  }

  Future<bool> _updateData(final ConnectResponse response) async {
    try{
      final deleteDoors = List<String>.from(response.data["deleteDoors"] as List);
      final newShares = List<Map<String, String>>.from(response.data["newShares"] as List);

      for(String doorName in deleteDoors){
        account.deleteKey(doorName);
        storage.deleteShare(doorName);

        notificationsBox.addNotification(
          UpdateNotification(
            type: NotificationType.deleteKey,
            content: doorName,
          ),
        );
      }

      for(Map<String, String> newShare in newShares){
        String doorName = newShare["doorName"]!;
        String share = newShare["share"]!;
        account.addKey(doorName);
        await storage.storeShare(doorName, share);

        notificationsBox.addNotification(
          UpdateNotification(
            type: NotificationType.newKey,
            content: doorName,
          ),
        );
      }

      return true;
    }
    catch(e){
      _setUpdateFailed(message: e.toString());
      return false;
    }
  }

  void _setUpdateFailed({String message = ""}) {
    _updateSuccessful = false;
    _updateFailedMessage = message;
  }

  void _setUpdateSuccessful() {
    _updateSuccessful = true;
    _updateFailedMessage = "";
  }
}