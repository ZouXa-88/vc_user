import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;

import 'package:user/backend_processes/storage.dart';
part 'package:user/objects/connect_response.dart';


final Connector connector = Connector();

class Connector {

  oauth2.Client? _client;
  String _serverAddress = "vc-server-hha2.onrender.com";
  int _port = 8000;

  final Map<String, String> _header = {"Content-Type": "application/json"};

  ConnectResponse _onException(String e) => ConnectResponse(code: 422, data: {"detail": e});
  ConnectResponse _onNotAuthenticated() => ConnectResponse(code: 401, data: {"detail": "Require login"});


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

  Future<void> autoLogin() async {
    _client = oauth2.Client(oauth2.Credentials.fromJson((await storage.loadCredentials())!));
  }

  Future<void> _storeCredentials() async {
    if(_client != null){
      storage.storeCredentials(_client!.credentials.toJson());
    }
  }

  Future<void> _storeAccountData({
    required String email,
    required String password,
  }) async {

  }

  Future<void> _reLogin() async {
    
  }

  Future<void> ping() async {

  }

  Future<ConnectResponse> login({
    required String email,
    required String password,
  }) async {
    try{
      _client = await oauth2.resourceOwnerPasswordGrant(
        Uri.https(_serverAddress, "/token"),
        email,
        password,
      );
      _storeCredentials();
      return ConnectResponse(code: 200);
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  void logout() {
    _client?.close();
    _client = null;
    storage.deleteCredentials();
  }

  Future<ConnectResponse> getKeys() async {
    if(_client == null){
      return _onNotAuthenticated();
    }

    try{
      final response = await _client!.get(
        Uri.https(_serverAddress, "/users/getMyKeys"),
        headers: _header,
      );
      final responseBody = jsonDecode(response.body);

      return ConnectResponse(
        code: response.statusCode,
        data: responseBody,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Future<ConnectResponse> createAccount({
    required String userName,
    required String email,
    required String password,
  }) async {
    try{
      final response = await http.post(
        Uri.https(_serverAddress, "/users/createUser"),
        body: jsonEncode({
          "password": password,
          "email": email,
          "user_name": userName,
        }),
        headers: _header,
      );
      final responseBody = jsonDecode(response.body);

      return ConnectResponse(
        code: response.statusCode,
        data: responseBody,
      );
    }
    catch(e){
      print(e.toString());
      return _onException(e.toString());
    }
  }

  Future<ConnectResponse> validate({required String code}) async {
    try{
      final response = await http.get(
        Uri.http(_serverAddress, "/users/validateEmail", {"code": code}),
        headers: _header,
      );
      final responseBody = _getResponseBody(response);

      return ConnectResponse(
        code: response.statusCode,
        data: responseBody,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Future<ConnectResponse> requestKey({required String doorName}) async {
    if(_client == null){
      return _onNotAuthenticated();
    }

    try{
      final response = await _client!.post(
        Uri.https(_serverAddress, "/users/requestKey"),
        body: jsonEncode({
          "door_name": doorName,
        }),
        headers: _header,
      );
      final responseBody = _getResponseBody(response);

      return ConnectResponse(
        code: response.statusCode,
        data: responseBody,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Future<ConnectResponse> deleteKey({required String doorName}) async {
    if(_client == null){
      return _onNotAuthenticated();
    }

    try{
      final response = await _client!.delete(
        Uri.https(_serverAddress, "/users/deleteKey"),
        body: jsonEncode({
          "share": await storage.loadShare(doorName),
        }),
        headers: _header,
      );
      final responseBody = _getResponseBody(response);

      return ConnectResponse(
        code: response.statusCode,
        data: responseBody,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Future<ConnectResponse> deleteUser() async {
    if(_client == null){
      return _onNotAuthenticated();
    }

    try{
      final response = await _client!.delete(
        Uri.https(_serverAddress, "/users/deleteUser"),
        headers: _header,
      );
      final responseBody = _getResponseBody(response);

      return ConnectResponse(
        code: response.statusCode,
        data: responseBody,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Map<String, dynamic> _getResponseBody(http.Response response) {
    return jsonDecode(response.body);
  }

  String _getHost() {
    return "$_serverAddress:$_port";
  }
}
