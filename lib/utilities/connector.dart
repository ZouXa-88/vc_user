import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

// ==========Connector==========

Connector connector = Connector();

class Connector {

  String _serverAddress = "127.0.0.1";
  int _port = 5000;

  Map<String, String> headers = {};


  void setServerAddress(final String serverAddress) {
    _serverAddress = serverAddress;
  }

  String getServerAddress() {
    return _serverAddress;
  }

  void setPort(final int port) {
    _port = port;
  }

  int getPort() {
    return _port;
  }

  Future<ConnectResponse> login({required String email, required String password}) async {
    return _sendRequest(
      requestType: "POST",
      url: Uri.http(_getHost(), "/login"),
      body: {
        "email": email,
        "password": password,
      },
    );
  }

  Future<ConnectResponse> createAccount({required String userName, required String email, required String password}) async {
    return _sendRequest(
      requestType: "POST",
      url: Uri.http(_getHost(), "/createUser"),
      body: {
        "userName": userName,
        "email": email,
        "password": password,
      },
    );
  }

  Future<ConnectResponse> validate({required String code}) async {
    return _sendRequest(
      requestType: "GET",
      url: Uri.http(_getHost(), "/validateEmail?code=$code"),
      body: {},
    );
  }

  Future<ConnectResponse> registerDoor({required String doorName}) async {
    return _sendRequest(
      requestType: "POST",
      url: Uri.http(_getHost(), "/requestKey"),
      body: {
        "doorName": doorName,
      },
    );
  }

  Future<ConnectResponse> deleteDoor({required String doorName}) async {
    return _sendRequest(
      requestType: "POST",
      url: Uri.http(_getHost(), "/deleteKey"),
      body: {
        "doorName": doorName,
      },
    );
  }

  Future<ConnectResponse> update() async {
    return _sendRequest(
      requestType: "GET",
      url: Uri.http(_getHost(), "/userUpdate"),
      body: {},
    );
  }

  Future<ConnectResponse> deleteAccount() async {
    return _sendRequest(
      requestType: "DELETE",
      url: Uri.http(_getHost(), "/deleteUser"),
      body: {},
    );
  }

  // TODO: Remove this test.
  Future<ConnectResponse> fakeProcessing(StatusType statusType) async {
    await Future.delayed(const Duration(seconds: 3));
    return ConnectResponse(type: statusType);
  }

  Future<ConnectResponse> _sendRequest({required String requestType,
                                        required Uri url,
                                        required Map<String, dynamic> body}) async {
    http.Response response;
    FutureOr<http.Response> onTimeout() => http.Response(jsonEncode({}), 408);

    // TODO: cookie.
    try{
      if(requestType == "GET"){
        response = await http.get(url, headers: headers)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: onTimeout,
        );
      }
      else if(requestType == "POST"){
        response = await http.post(url, body: jsonEncode(body), headers: headers)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: onTimeout,
        );
      }
      else if(requestType == "DELETE"){
        response = await http.delete(url, headers: headers)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: onTimeout,
        );
      }
      else{
        return ConnectResponse(type: StatusType.syntaxError);
      }
    }catch(e){
      return ConnectResponse(type: StatusType.unknownError, data: {"reason": e.toString()});
    }

    final responseBody = _getResponseBody(response);
    if(response.statusCode == 200) {
      _updateCookie(response);
    }

    return ConnectResponse(
      type: _toStatusType(response.statusCode, responseBody["code"]),
      data: responseBody,
    );
  }

  Map<String, dynamic> _getResponseBody(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  void _updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if(rawCookie != null){
      int index = rawCookie.indexOf(';');
      headers['cookie'] = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  StatusType _toStatusType(int statusCode, int? code) {
    switch(statusCode){
      case 200:
        return StatusType.ok;
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
      case 401:
        return StatusType.notAuthenticatedError;
      case 408:
        return StatusType.connectionError;
      default:
        return StatusType.unknownError;
    }
  }

  String _getHost() {
    return "$_serverAddress:$_port";
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
  connectionError,
  unknownError,
}

// ==========StatusType==========