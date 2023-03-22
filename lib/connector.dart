import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:user/accounts.dart';

// ==========Connector==========

Connector connector = Connector();

class Connector {

  String _serverAddress = "0.0.0.0";


  void setServerAddress(final String serverAddress) {
    _serverAddress = serverAddress;
  }

  String getServerAddress() {
    return _serverAddress;
  }

  Future<ConnectorResponse> sendLogin({required final String email, required final String password}) async {
    /*
    Uri url = Uri.https(_serverAddress, "/login");
    Response response = await http.post(url, body: {
      "email": email,
      "password": password,
    });

    final responseBody = _getResponseBody(response);
    if(response.statusCode == 200){
      return ConnectorResponse(ok: true);
    }
    return ConnectorResponse(ok: false, errorMessage: responseBody["reason"]);
    */
    await Future.delayed(const Duration(seconds: 1));
    return ConnectorResponse(ok: true);
  }

  Future<void> sendDoorRegistration({required final String doorId}) async {

  }

  Map<String, dynamic> _getResponseBody(final Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
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