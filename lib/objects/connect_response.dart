part of 'package:user/backend_processes/connector.dart';

class ConnectResponse {

  StatusType type;
  Map<String, dynamic> data;

  ConnectResponse({required this.type, this.data = const {}});

  bool isOk() {
    return type == StatusType.ok;
  }

}

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