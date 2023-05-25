import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final Storage storage = Storage();

class Storage {

  String _userDirectoryPath = "";


  Future<bool> initialize() async {
    if(await _checkPermission()){
      try{
        final applicationDirectoryPath = (await getApplicationDocumentsDirectory()).path;
        _userDirectoryPath = "$applicationDirectoryPath/users";
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

  Future<String?> loadShare(final String doorName) async {
    try{
      final file = File("$_userDirectoryPath/doors/$doorName.txt");

      if(await file.exists()){
        return await file.readAsString();
      }
    }
    catch(e){
      print("Load share failed: ${e.toString()}");
    }

    return null;
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

  Future<bool> clearAllShares() async {
    try{
      final directory = Directory("$_userDirectoryPath/doors");
      if(await directory.exists()){
        await directory.delete(recursive: true);
      }
      return true;
    }
    catch(e){
      print("Delete shares directory failed: ${e.toString()}");
      return false;
    }
  }

  bool hasCredentials() {
    try{
      return File("$_userDirectoryPath/credentials.txt").existsSync();
    }
    catch(e){
      print("Cannot check whether credentials exist: ${e.toString()}");
      return false;
    }
  }

  Future<bool> storeCredentials(String credentials) async {
    try{
      final file = File("$_userDirectoryPath/credentials.txt");
      await file.create(recursive: true);
      await file.writeAsString(credentials);
      return true;
    }
    catch(e){
      print("Store credentials failed: ${e.toString()}");
      return false;
    }
  }

  Future<String?> loadCredentials() async {
    try{
      final file = File("$_userDirectoryPath/credentials.txt");

      if(await file.exists()){
        return await file.readAsString();
      }
    }
    catch(e){
      print("Load credentials failed: ${e.toString()}");
    }

    return null;
  }

  Future<bool> deleteCredentials() async {
    try{
      final file = File("$_userDirectoryPath/credentials.txt");
      if(await file.exists()) {
        await file.delete();
      }
      return true;
    }
    catch(e){
      print("Delete credentials failed: ${e.toString()}");
      return false;
    }
  }

  Future<String?> loadAccountData() async {
    try{
      final file = File("$_userDirectoryPath/account_data.txt");

      if(await file.exists()){
        return await file.readAsString();
      }
    }
    catch(e){
      print("Load account data failed: ${e.toString()}");
    }

    return null;
  }

  Future<bool> deleteAccountData() async {
    try{
      final file = File("$_userDirectoryPath/account_data.txt");
      if(await file.exists()) {
        await file.delete();
      }
      return true;
    }
    catch(e){
      print("Delete account data failed: ${e.toString()}");
      return false;
    }
  }

  Future<bool> storeAccountData(String accountData) async {
    try{
      final file = File("$_userDirectoryPath/account_data.txt");
      await file.create(recursive: true);
      await file.writeAsString(accountData);
      return true;
    }
    catch(e){
      print("Store account data failed: ${e.toString()}");
      return false;
    }
  }

  bool hasAccountData() {
    try{
      return File("$_userDirectoryPath/account_data.txt").existsSync();
    }
    catch(e){
      print("Cannot check whether account data exist: ${e.toString()}");
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