import 'package:user/utilities/connector.dart';

Backend backend = Backend();

class Backend {

  bool _isActive = false;

  void start() {
    _isActive = true;
  }

  void forceUpdate() {

  }

  void stop() {
    _isActive = false;
  }
}