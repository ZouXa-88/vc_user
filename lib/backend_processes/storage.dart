import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:user/objects/account.dart';

Storage storage = Storage();

class Storage {

  late final String _userDirectoryPath;
  final Map<String, String> _sharesCache = {};


  Future<bool> initialize() async {
    if(await _checkPermission()){
      try{
        final applicationDirectoryPath = (await getApplicationDocumentsDirectory()).path;
        _userDirectoryPath = "$applicationDirectoryPath/user";
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

  FutureOr<String?> loadShare(final String doorName) async {
    if(_sharesCache.containsKey(doorName)){
      return _sharesCache[doorName];
    }

    final file = File("$_userDirectoryPath/doors/$doorName.txt");
    if(await file.exists() && await _checkPermission()) {
      String share = await file.readAsString();
      _sharesCache[doorName] = share;
      return share;
    }

    return null;
  }

  Future<bool> storeAccountData(final Account account) async {
    try{
      final file = File("$_userDirectoryPath/user_data.txt");
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
      await file.create();
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
      await file.delete();
      _sharesCache.remove(doorName);
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