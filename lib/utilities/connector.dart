import 'dart:convert';

import 'package:http/http.dart' as http;

// ==========Connector==========

Connector connector = Connector();

class Connector {

  String _serverAddress = "0.0.0.0";
  Map<String, String> headers = {};


  void setServerAddress(final String serverAddress) {
    _serverAddress = serverAddress;
  }

  String getServerAddress() {
    return _serverAddress;
  }

  Future<ConnectResponse> login({required final String email, required final String password}) async {
    Uri url = Uri.http(_serverAddress, "/login");
    final response = await http.post(url, body: {
      "email": email,
      "password": password,
    });

    final responseBody = _getResponseBody(response);
    if(response.statusCode == 200){
      _updateCookie(response);
    }
    return ConnectResponse(type: _toStatusType(response.statusCode, responseBody["code"]));

    await Future.delayed(const Duration(seconds: 1));
    return ConnectResponse(type: StatusType.ok);
  }

  Future<ConnectResponse> createAccount({required String userName, required String email, required String password}) async {
    Uri url = Uri.http(_serverAddress, "/createUser");
    final response = await http.post(url, body: {
      "userName": userName,
      "email": email,
      "password": password,
    });

    final responseBody = _getResponseBody(response);
    return ConnectResponse(type: _toStatusType(response.statusCode, responseBody["code"]));
  }

  Future<ConnectResponse> registerDoor({required String doorName}) async {
    // TODO.
    return ConnectResponse(type: StatusType.ok);
  }

  Future<ConnectResponse> deleteDoor({required String doorName}) async {
    // TODO.
    return ConnectResponse(type: StatusType.ok);
  }

  Future<ConnectResponse> update() async {
    // TODO.
    return ConnectResponse(type: StatusType.ok);
  }

  Future<ConnectResponse> deleteAccount() async {
    // TODO.
    return ConnectResponse(type: StatusType.ok);
  }

  Map<String, dynamic> _getResponseBody(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  void _updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  StatusType _toStatusType(int statusCode, int? code) {
    switch(statusCode){
      case 200:
        return StatusType.ok;
      case 401:
        return StatusType.notAuthenticatedError;
      case 400:
        switch(code){
          case 0:
            return StatusType.syntaxError;
          case 1:
            return StatusType.parameterInUsedError;
          case 3:
            return StatusType.invalidCredentialCodeError;
          case 4:
            return StatusType.emailPasswordIncorrectError;
          case 5:
            return StatusType.objectNotExistError;
          case 6:
            return StatusType.alreadyAppliedError;
          case 7:
            return StatusType.youNotHaveThisKeyError;
          case 8:
            return StatusType.namePasswordInvalidError;
          default:
            return StatusType.unknownError;
        }
      default:
        return StatusType.unknownError;
    }
  }
}

// ==========Connector==========

// ==========ConnectResponse==========

class ConnectResponse {

  StatusType type;
  Map<String, dynamic> data;

  ConnectResponse({required this.type, this.data = const {}});

  bool isOk() {
    return type == StatusType.ok;
  }

}

// ==========ConnectResponse==========

// ==========StatusType==========

enum StatusType {
  ok,
  syntaxError,
  parameterInUsedError,
  invalidCredentialCodeError,
  emailPasswordIncorrectError,
  objectNotExistError,
  alreadyAppliedError,
  youNotHaveThisKeyError,
  namePasswordInvalidError,
  notAuthenticatedError,
  unknownError,
}

// ==========StatusType==========