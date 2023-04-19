import 'dart:async';

Updater updater = Updater();

// TODO: Implement it.
class Updater {

  Timer? _updateTimer;


  void startPeriodicUpdate() {
    _updateTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => _update(),
    );
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
    // TODO: Periodic update.
  }
}