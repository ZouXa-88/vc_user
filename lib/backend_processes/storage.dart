import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:user/objects/account.dart';

final Storage storage = Storage();

class Storage {

  late String _applicationDirectoryPath;
  String _userDirectoryPath = "";


  Future<bool> initialize() async {
    if(await _checkPermission()){
      try{
        _applicationDirectoryPath = (await getApplicationDocumentsDirectory()).path;
        _userDirectoryPath = "$_applicationDirectoryPath/users";
        Directory(_userDirectoryPath).create(recursive: true);

        return true;
      }
      catch(e){
        print("Storage initialize failed: ${e.toString()}");
        return false;
      }
    }

    print("Storage permission is not allowed.");
    return false;
  }

  void setCurrentUser(String userName) {
    _userDirectoryPath = "$_applicationDirectoryPath/users/$userName";
  }

  bool hasAccountData() {
    return File("$_userDirectoryPath/data.txt").existsSync();
  }

  Future<String?> loadAccountData() async {
    final file = File("$_userDirectoryPath/data.txt");
    if(await file.exists()){
      return await file.readAsString();
    }

    return null;
  }

  Future<String?> loadShare(final String doorName) async {
    final file = File("$_userDirectoryPath/doors/$doorName.txt");
    if(await file.exists() && await _checkPermission()) {
      return await file.readAsString();
    }

    return null;
  }

  Future<bool> storeAccountData(final Account account) async {
    try{
      final file = File("$_applicationDirectoryPath/users/${account.getName()}/data.txt");
      await file.create(recursive: true);
      await file.writeAsString(account.buildAccountData());

      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<bool> storeShare(final String doorName, final String share) async {
    try{
      final file = File("$_userDirectoryPath/doors/$doorName.txt");
      await file.create(recursive: true);
      await file.writeAsString(share);
      return true;
    }
    catch(e){
      print("Store share failed: ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteShare(final String doorName) async {
    try{
      final file = File("$_userDirectoryPath/doors/$doorName.txt");
      if(await file.exists()) {
        await file.delete();
      }
      return true;
    }
    catch(e){
      print("Delete share failed: ${e.toString()}");
      return false;
    }
  }

  Future<bool> _checkPermission() async {
    if(!(await Permission.manageExternalStorage.isGranted)){
      await Permission.manageExternalStorage.request();
    }
    return await Permission.manageExternalStorage.isGranted;
  }
}