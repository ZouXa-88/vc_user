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
    /*
    Uri url = Uri.http(_serverAddress, "/login");
    final response = await http.post(url, body: {
      "email": email,
      "password": password,
    });

    final responseBody = _getResponseBody(response);
    if(response.statusCode == 200){
      _updateCookie(response);
      return ConnectorResponse(ok: true);
    }
    return ConnectorResponse(ok: false, errorMessage: responseBody["reason"]);
    */
    await Future.delayed(const Duration(seconds: 1));
    return ConnectResponse(ok: true);
  }

  Future<ConnectResponse> createAccount({required String userName, required String email, required String password}) async {
    Uri url = Uri.http(_serverAddress, "/createUser");
    final response = await http.post(url, body: {
      "userName": userName,
      "email": email,
      "password": password,
    });

    final responseBody = _getResponseBody(response);
    if(response.statusCode == 200){
      return ConnectResponse(ok: true);
    }
    return ConnectResponse(ok: false, body: responseBody);
  }

  Future<ConnectResponse> registerDoor({required String doorName}) async {
    // TODO.
    return ConnectResponse(ok: true);
  }

  Future<ConnectResponse> deleteDoor({required String doorName}) async {
    // TODO.
    return ConnectResponse(ok: true);
  }

  Future<ConnectResponse> update() async {
    // TODO.
    return ConnectResponse(ok: true);
  }

  Future<ConnectResponse> deleteAccount() async {
    // TODO.
    return ConnectResponse(ok: true);
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

  ConnectErrorType _toErrorType(int statusCode, int code) {
    if(statusCode == 401){
      return ConnectErrorType.notAuthenticated;
    }
    if(statusCode == 400){
      switch(code){
        case 0:
          return ConnectErrorType.syntaxError;
        case 1:
          return ConnectErrorType.parameterInUsed;
        case 3:
          return ConnectErrorType.invalidCredentialCode;
        case 4:
          return ConnectErrorType.emailPasswordIncorrect;
        case 5:
          return ConnectErrorType.objectNotExist;
        case 6:
          return ConnectErrorType.alreadyApplied;
        case 7:
          return ConnectErrorType.youNotHaveThisKey;
        case 8:
          return ConnectErrorType.namePasswordInvalid;
        default:
          return ConnectErrorType.unknown;
      }
    }
    return ConnectErrorType.unknown;
  }
}

// ==========Connector==========

// ==========ConnectResponse==========

class ConnectResponse {

  bool ok;
  ConnectErrorType? errorType;
  Map<String, dynamic> body;

  ConnectResponse({required this.ok, this.body = const {}});

}

// ==========ConnectResponse==========

// ==========ConnectErrorType==========

enum ConnectErrorType {
  syntaxError,
  parameterInUsed,
  invalidCredentialCode,
  emailPasswordIncorrect,
  objectNotExist,
  alreadyApplied,
  youNotHaveThisKey,
  namePasswordInvalid,
  notAuthenticated,
  unknown,
}

// ==========ConnectErrorType==========