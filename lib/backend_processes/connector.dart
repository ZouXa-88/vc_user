import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dart_ping/dart_ping.dart';

import 'package:user/backend_processes/storage.dart';
part 'package:user/objects/connect_response.dart';


final Connector connector = Connector();

class Connector {

  oauth2.Client? _client;

  Timer? _credentialsCheckTimer;
  final Duration _credentialsCheckDuration = const Duration(seconds: 30);

  String _serverAddress = "vc-server-hha2.onrender.com";
  int _port = 8000;

  final Map<String, String> _header = {"Content-Type": "application/json"};

  ConnectResponse _onException(String e) => ConnectResponse(code: 422, data: {"detail": e});
  ConnectResponse _onNotAuthenticated() => ConnectResponse(code: 401, data: {"detail": "Require login"});


  Connector() {
    _checkExpiration();
    _credentialsCheckTimer = Timer.periodic(
      _credentialsCheckDuration,
      (timer) => _checkExpiration(),
    );
  }

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

  Future<void> initialize({bool loadCredentials = false}) async {
    _client = oauth2.Client(oauth2.Credentials.fromJson((await storage.loadCredentials())!));
  }

  bool isLogout() {
    return _client == null;
  }

  Future<bool> pingTest() async {
    bool successful = true;

    final ping = Ping("vc-server-hha2.onrender.com", count: 1);
    await for(PingData pingData in ping.stream){
      if(pingData.error != null){
        successful = false;
      }
    }

    return successful;
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
      _storeAccountData(email: email, password: password);
      return ConnectResponse(code: 200);
    }
    catch(e){
      _client = null;
      return _onException(e.toString());
    }
  }

  void logout() {
    _clearClient();
    storage.deleteAccountData();
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

  Future<void> _storeCredentials() async {
    if(_client != null){
      storage.storeCredentials(_client!.credentials.toJson());
    }
  }

  Future<void> _storeAccountData({
    required String email,
    required String password,
  }) async {
    storage.storeAccountData(jsonEncode({
      "email": email,
      "password": password,
    }));
  }

  Future<void> _reLogin() async {
    _clearClient();
    storage.deleteCredentials();
    try{
      final accountData = jsonDecode((await storage.loadAccountData())!);
      _client = await oauth2.resourceOwnerPasswordGrant(
        Uri.https(_serverAddress, "/token"),
        accountData["email"],
        accountData["password"],
      );
      _storeCredentials();
    }
    catch(e){
      if(e.toString().contains("Incorrect username or password")){
        storage.deleteAccountData();
      }
    }
  }

  void _checkExpiration() {
    if(_client != null) {
      final token = _client!.credentials.accessToken;
      final remainTime = JwtDecoder.getRemainingTime(token);
      final isExpired = JwtDecoder.isExpired(token);

      if(isExpired || remainTime.compareTo(_credentialsCheckDuration * 2) <= 0){
        _reLogin();
      }
    }
  }

  void _clearClient() {
    _client?.close();
    _client = null;
  }
}
