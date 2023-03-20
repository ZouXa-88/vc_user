import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'accounts.dart';

Storage storage = Storage();

class Storage {

  String _applicationDirectoryPath = "";
  String _userDirectoryPath = "";


  Future<void> initialize() async {
    _applicationDirectoryPath = (await getApplicationDocumentsDirectory()).path;
    _userDirectoryPath = "$_applicationDirectoryPath/user";
    Directory(_userDirectoryPath).create(recursive: true);
  }

  bool hasStoredAccount() {
    return File("$_userDirectoryPath/user_data.txt").existsSync();
  }

  Future<String?> loadAccountData() async {
    final file = File("$_userDirectoryPath/user_data.txt");
    if(await file.exists()){
      final jsonString = await file.readAsString();
      return jsonString;
    }

    return null;
  }

  Future<String?> loadDoorData(final String doorId) async {
    final file = File("$_userDirectoryPath/doors/$doorId.txt");
    if(await file.exists() && await _checkPermission()) {
      final jsonString = file.readAsString();
      return jsonString;
    }

    return null;
  }

  Future<bool> storeAccountData(final Account account) async {
    if(await _checkPermission()){
      final file = File("$_userDirectoryPath/user_data.txt");

      file.create(recursive: true);
      await file.writeAsString(account.buildAccountData());

      // TODO: Remove it latter.
      Directory("$_userDirectoryPath/doors").create(recursive: true);
      for(Door door in account.getAllRegisteredDoors()){
        final doorFile = File("$_userDirectoryPath/doors/${door.id}.txt");
        doorFile.create(recursive: true);
        doorFile.writeAsString(door.buildDoorData());
      }

      return true;
    }
    return false;
  }

  Future<bool> _checkPermission() async {
    if(await Permission.storage.isDenied){
      Permission.storage.request();
    }
    return await Permission.storage.isGranted;
  }
}