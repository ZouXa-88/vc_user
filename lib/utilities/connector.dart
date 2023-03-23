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

  Future<ConnectorResponse> login({required final String email, required final String password}) async {
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
    return ConnectorResponse(ok: true);
  }

  Future<ConnectorResponse> createAccount({required String userName, required String email, required String password}) async {
    Uri url = Uri.http(_serverAddress, "/createUser");
    final response = await http.post(url, body: {
      "userName": userName,
      "email": email,
      "password": password,
    });

    final responseBody = _getResponseBody(response);
    if(response.statusCode == 200){
      return ConnectorResponse(ok: true);
    }
    return ConnectorResponse(ok: false, errorMessage: responseBody["reason"]);
  }

  Future<ConnectorResponse> registerDoor({required String doorName}) async {
    // TODO.
    return ConnectorResponse(ok: true);
  }

  Future<ConnectorResponse> deleteDoor({required String doorName}) async {
    // TODO.
    return ConnectorResponse(ok: true);
  }

  Future<ConnectorResponse> update() async {
    // TODO.
    return ConnectorResponse(ok: true);
  }

  Future<ConnectorResponse> deleteAccount() async {
    // TODO.
    return ConnectorResponse(ok: true);
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
}

// ==========Connector==========

// ==========ConnectorResponse==========

class ConnectorResponse {

  bool ok;
  String errorMessage;

  ConnectorResponse({required this.ok, this.errorMessage = ""});
}

// ==========ConnectorResponse==========