import 'dart:async';

import 'package:user/backend_processes/connector.dart';
import 'package:user/backend_processes/storage.dart';
import 'package:user/objects/account.dart';


final Updater updater = Updater();

// TODO: Implement it.
class Updater {

  Timer? _updateTimer;


  void startPeriodicUpdate() {
    if(_updateTimer == null || !_updateTimer!.isActive) {
      _updateTimer = Timer.periodic(
        const Duration(seconds: 10),
            (timer) => _update(),
      );
    }
  }

  void stopPeriodicUpdate() {
    if(_updateTimer != null && _updateTimer!.isActive){
      _updateTimer!.cancel();
    }
  }

  Future<void> forceUpdate() async {
    // TODO: Force update.
  }

  Future<void> _update() async {
    ConnectResponse response = await connector.update();

    if(response.isOk()) {
      List<String>? deleteDoors = response.data["deleteDoors"];
      Map<String, String>? newShares = response.data["newShares"];

      if (deleteDoors != null) {
        for (String doorName in deleteDoors) {
          account.deleteKey(doorName);
          storage.deleteShare(doorName);
        }
      }
      if (newShares != null) {
        newShares.forEach((doorName, share) {
          account.addKey(doorName);
          storage.storeShare(doorName, share);
        });
      }
    }
  }
}