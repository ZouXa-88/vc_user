import 'dart:io';

import 'package:message/message.dart';
import 'package:user/accounts.dart';

Connector connector = Connector();

class Connector {

  Socket? _socket;
  String _serverAddress = "172.16.1.245";
  static const int _port = 7777;


  void initialize() {
    _sendMessage(
      Message(
        senderId: currentAccount.getId(),
        messageTitle: MessageTitle.userCheckUpdate,
        data: "",
      )
    );
  }

  void setServerAddress(final String serverAddress) {
    _serverAddress = serverAddress;
  }

  String getServerAddress() {
    return _serverAddress;
  }

  void close() {
    _socket?.close();
  }

  void sendDoorRegistration({required final String senderId,
                             required final String doorId,
                             required final String registrationReason})
  {
    _sendMessage(
      Message(
        senderId: senderId,
        messageTitle: MessageTitle.userRegisterDoor,
        data: "$doorId $registrationReason",
      )
    );
  }

  void _sendMessage(Message message) {
    Socket.connect(_serverAddress, _port).then(
      (Socket socket) {
        socket.write(message);
      }
    );
  }
}