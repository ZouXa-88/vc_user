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
      if(response.isOk()){
        _updateData(response);
      }
      else{
        String? failedReason = response.data["detail"];
        throw Exception(failedReason ?? "");
      }
    }
    catch(e){
      _updateSuccessful = false;
      _updateFailedMessage = e.toString();
    }
  }

  Future<void> _updateData(final ConnectResponse response) async {
    final deleteDoors = response.data["deleteDoors"];
    final newShares = response.data["newShares"];

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

    newShares.forEach((doorName, share){
      account.addKey(doorName);
      storage.storeShare(doorName, share);

      notificationsBox.addNotification(
        UpdateNotification(
          type: NotificationType.newKey,
          content: doorName,
        ),
      );
    });
  }
}