part of 'package:user/backend_processes/connector.dart';

class ConnectResponse {

  int code;
  Map<String, dynamic> data;

  ConnectResponse({required this.code, this.data = const {}});

  bool isOk() {
    return code ~/ 100 == 2;
  }

  String getErrorMessage() {
    try{
      return data["detail"];
    }
    catch(_){
      try{
        return data["detail"].first["msg"];
      }
      catch(_){
        return "";
      }
    }
  }
}
