import 'package:user/backend_processes/notifications_box.dart';
import 'package:user/backend_processes/updater.dart';

final Configuration configuration = Configuration();

class Configuration {

  bool _autoUpdate = false;


  bool autoUpdate() {
    return _autoUpdate;
  }

  void setAutoUpdate(bool value) {
    _autoUpdate = value;
    if(_autoUpdate){
      updater.startPeriodicUpdate();
    }
    else{
      updater.stopPeriodicUpdate();
    }
  }
}