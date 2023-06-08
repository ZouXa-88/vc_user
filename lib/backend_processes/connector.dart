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

  Timer? _authenticationCheckTimer;
  final Duration _authenticationCheckDuration = const Duration(seconds: 5);

  String _serverAddress = "10.201.25.250";
  int _port = 8000;

  final Map<String, String> _header = {"Content-Type": "application/json"};

  ConnectResponse _onException(String e) => ConnectResponse(code: 422, data: {"detail": e});
  ConnectResponse _onNotAuthenticated() => ConnectResponse(code: 401, data: {"detail": "Require login"});
  ConnectResponse _onInvalidIp() => ConnectResponse(code: 422, data: {"detail": "Server's ip is invalid"});


  Connector() {
    _authenticate();
    _authenticationCheckTimer = Timer.periodic(
      _authenticationCheckDuration,
      (timer) => _authenticate(),
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

  bool getAuthenticationStatus() {
    if(_client != null) {
      final token = _client!.credentials.accessToken;
      return !JwtDecoder.isExpired(token);
    }

    return false;
  }

  Future<String> pingTest() async {
    if(!_isValidIp()){
      return "Server's address is invalid";
    }

    String errorMessage = "no reply";

    try{
      final ping = Ping(_serverAddress, count: 1);
      await for (PingData pingData in ping.stream) {
        if(pingData.summary == null){
          errorMessage = "No ping result";
        }
        else{
          // Empty string if no error message.
          errorMessage = pingData.summary!.errors.join("\n");
        }
      }
    }
    catch(e){
      errorMessage = e.toString();
    }

    return errorMessage;
  }

  Future<ConnectResponse> login({
    required String email,
    required String password,
  }) async {
    if(!_isValidIp()){
      return _onInvalidIp();
    }

    try{
      _client = await oauth2.resourceOwnerPasswordGrant(
        Uri.http(_getHost(), "/token"),
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
    if(!_isValidIp()){
      return _onInvalidIp();
    }
    if(_client == null){
      return _onNotAuthenticated();
    }

    try{
      final response = await _client!.get(
        Uri.http(_getHost(), "/users/getMyKeys"),
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
    if(!_isValidIp()){
      return _onInvalidIp();
    }

    try{
      final response = await http.post(
        Uri.http(_getHost(), "/users/createUser"),
        body: jsonEncode({
          "password": password,
          "email": email,
          "user_name": userName,
        }),
        headers: _header,
      );

      return ConnectResponse(
        code: response.statusCode,
      );
    }
    catch(e){
      print(e.toString());
      return _onException(e.toString());
    }
  }

  Future<ConnectResponse> validate({required String code}) async {
    if(!_isValidIp()){
      return _onInvalidIp();
    }

    try{
      final response = await http.get(
        Uri.http(_getHost(), "/users/validateEmail", {"code": code}),
        headers: _header,
      );

      return ConnectResponse(
        code: response.statusCode,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Future<ConnectResponse> requestKey({required String doorName}) async {
    if(!_isValidIp()){
      return _onInvalidIp();
    }
    if(_client == null){
      return _onNotAuthenticated();
    }

    try{
      final response = await _client!.post(
        Uri.http(_getHost(), "/users/requestKey"),
        body: jsonEncode({
          "door_name": doorName,
        }),
        headers: _header,
      );

      return ConnectResponse(
        code: response.statusCode,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Future<ConnectResponse> deleteKey({required String doorName}) async {
    if(!_isValidIp()){
      return _onInvalidIp();
    }
    if(_client == null){
      return _onNotAuthenticated();
    }

    try{
      final response = await _client!.delete(
        Uri.http(_getHost(), "/users/deleteKey"),
        body: jsonEncode({
          "share": await storage.loadShare(doorName),
        }),
        headers: _header,
      );

      return ConnectResponse(
        code: response.statusCode,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Future<ConnectResponse> requestUpdateKey({required String doorName}) async {
    if(!_isValidIp()){
      return _onInvalidIp();
    }
    if(_client == null){
      return _onNotAuthenticated();
    }

    try{
      final response = await _client!.put(
        Uri.http(_getHost(), "/users/requestUpdateKey"),
        body: jsonEncode({
          "share": await storage.loadShare(doorName),
        }),
        headers: _header,
      );

      return ConnectResponse(
        code: response.statusCode,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  Future<ConnectResponse> deleteUser() async {
    if(!_isValidIp()){
      return _onInvalidIp();
    }
    if(_client == null){
      return _onNotAuthenticated();
    }

    try{
      final response = await _client!.delete(
        Uri.http(_getHost(), "/users/deleteUser"),
        headers: _header,
      );

      return ConnectResponse(
        code: response.statusCode,
      );
    }
    catch(e){
      return _onException(e.toString());
    }
  }

  String _getHost() {
    return "$_serverAddress:$_port";
  }

  bool _isValidIp() {
    List<dynamic> buf = _serverAddress.split(".");
    if(buf.length != 4){
      return false;
    }

    for(dynamic seg in buf){
      int? num = int.tryParse(seg);
      if(num == null || !(num >= 0 && num <= 255)){
        return false;
      }
    }

    return true;
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
    storage.deleteCredentials();
    try{
      final accountData = jsonDecode((await storage.loadAccountData())!);
      _client = await oauth2.resourceOwnerPasswordGrant(
        Uri.http(_getHost(), "/token"),
        accountData["email"],
        accountData["password"],
      );
      _storeCredentials();
    }
    catch(e){
      print("Cannot re-login: ${e.toString()}");
    }
  }

  void _authenticate() {
    if(_client != null) {
      final token = _client!.credentials.accessToken;
      final remainTime = JwtDecoder.getRemainingTime(token);
      final isExpired = JwtDecoder.isExpired(token);
      print(remainTime);
      if(isExpired || remainTime.compareTo(const Duration(minutes: 1)) <= 0){
        _reLogin();
      }
    }
    else if(storage.hasAccountData()){
      _reLogin();
    }
  }

  void _clearClient() {
    _client?.close();
    _client = null;
  }
}
