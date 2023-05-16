part of 'package:user/backend_processes/connector.dart';

class ConnectResponse {

  int code;
  Map<String, dynamic> data;

  ConnectResponse({required this.code, this.data = const {}});

  bool isOk() {
    return code ~/ 100 == 2;
  }
}
