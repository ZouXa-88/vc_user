import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

part 'package:user/objects/connect_response.dart';


final Connector connector = Connector();

class Connector {

  String _serverAddress = "192.168.0.1";
  int _port = 8000;

  final Map<String, String> _headers = {"Content-Type": "application/json"};

  final _timeoutDuration = const Duration(seconds: 5);
  FutureOr<http.Response> _onTimeout() => http.Response(jsonEncode({}), 408);
  http.Response _onException(String e) => http.Response(jsonEncode({"reason": e}), 422);


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

  Future<ConnectResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _post(
      url: Uri.http(_getHost(), "/login"),
      body: {
        "email": email,
        "password": password,
      },
    );
    final responseBody = _getResponseBody(response);

    if(response.statusCode == 200) {
      _updateCookie(response);
    }

    return ConnectResponse(
      type: _toStatusType(response.statusCode, responseBody["code"]),
      data: responseBody,
    );
  }

  Future<ConnectResponse> createAccount({
    required String userName,
    required String email,
    required String password,
  }) async {
    final response = await _post(
      url: Uri.http(_getHost(), "/createUser"),
      body: {
        "userName": userName,
        "email": email,
        "password": password,
      },
    );
    final responseBody = _getResponseBody(response);

    return ConnectResponse(
      type: _toStatusType(response.statusCode, responseBody["code"]),
      data: responseBody,
    );
  }

  Future<ConnectResponse> validate({required String code}) async {
    final response = await _get(
      url: Uri.http(_getHost(), "/validateEmail?code=$code"),
    );
    final responseBody = _getResponseBody(response);

    return ConnectResponse(
      type: _toStatusType(response.statusCode, responseBody["code"]),
      data: responseBody,
    );
  }

  Future<ConnectResponse> applyKey({required String doorName}) async {
    final response = await _post(
      url: Uri.http(_getHost(), "/requestKey"),
      body: {
        "doorName": doorName,
      },
    );
    final responseBody = _getResponseBody(response);

    return ConnectResponse(
      type: _toStatusType(response.statusCode, responseBody["code"]),
      data: responseBody,
    );
  }

  Future<ConnectResponse> deleteKey({required String doorName}) async {
    final response = await _post(
      url: Uri.http(_getHost(), "/deleteKey"),
      body: {
        "doorName": doorName,
      },
    );
    final responseBody = _getResponseBody(response);

    return ConnectResponse(
      type: _toStatusType(response.statusCode, responseBody["code"]),
      data: responseBody,
    );
  }

  Future<ConnectResponse> update() async {
    final response = await _get(
      url: Uri.http(_getHost(), "/userUpdate"),
    );
    final responseBody = _getResponseBody(response);

    return ConnectResponse(
      type: _toStatusType(response.statusCode, responseBody["code"]),
      data: responseBody,
    );
  }

  Future<ConnectResponse> deleteAccount() async {
    final response = await _delete(
      url: Uri.http(_getHost(), "/deleteUser"),
      body: {},
    );
    final responseBody = _getResponseBody(response);

    return ConnectResponse(
      type: _toStatusType(response.statusCode, responseBody["code"]),
      data: responseBody,
    );
  }

  Future<http.Response> _post({
    required Uri url,
    required Map<String, dynamic> body,
  }) async {
    try{
      return http.post(
        url,
        body: jsonEncode(body),
        headers: _headers,
      ).timeout(
        _timeoutDuration,
        onTimeout: _onTimeout,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Future<http.Response> _get({required Uri url}) async {
    try{
      return http.get(
        url,
        headers: _headers,
      ).timeout(
        _timeoutDuration,
        onTimeout: _onTimeout,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Future<http.Response> _delete({
    required Uri url,
    required Map<String, dynamic> body,
  }) async {
    try{
      return http.delete(
        url,
        body: jsonEncode(body),
        headers: _headers,
      ).timeout(
        _timeoutDuration,
        onTimeout: _onTimeout,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Map<String, dynamic> _getResponseBody(http.Response response) {
    try {
      return jsonDecode(response.body);
    }
    catch(e){
      return {};
    }
  }

  void _updateCookie(http.Response response) {
    String? cookie = response.headers['set-cookie'];
    if(cookie != null){
      _headers['cookie'] = cookie;
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
            return StatusType.youDoNotHaveThisKeyError;
          case 8:
            return StatusType.namePasswordInvalidError;
          default:
            return StatusType.unknownError;
        }
      case 401:
        return StatusType.notAuthenticatedError;
      case 408:
        return StatusType.connectionError;
      case 422:
        return StatusType.programExceptionError;
      default:
        return StatusType.unknownError;
    }
  }

  String _getHost() {
    return "$_serverAddress:$_port";
  }
}