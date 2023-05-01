import 'dart:async';

import 'package:user/backend_processes/connector.dart';
import 'package:user/backend_processes/notifications_box.dart';
import 'package:user/backend_processes/storage.dart';
import 'package:user/objects/account.dart';


final Updater updater = Updater();

class Updater {

  Timer? _updateTimer;


  void startPeriodicUpdate() {
    if(_updateTimer == null || !_updateTimer!.isActive) {
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

  Future<ConnectResponse> update() async {
    final response = await connector.update();
    _updateData(response);

    return response;
  }

  Future<void> _updateData(final ConnectResponse response) async {
    if(response.isOk()) {
      List<String>? deleteDoors = response.data["deleteDoors"];
      Map<String, String>? newShares = response.data["newShares"];

      if(deleteDoors != null){
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
      }
      if(newShares != null){
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
  }
}