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

  Future<bool> storeCookie(String cookie) async {
    try{
      final file = File("$_userDirectoryPath/cookie.txt");
      await file.create(recursive: true);
      file.writeAsString(cookie);
    }
    catch(e){
      print("Store cookie failed: ${e.toString()}");
      return false;
    }

    return true;
  }

  Future<bool> deleteCookie() async {
    try{
      final file = File("$_userDirectoryPath/cookie.txt");
      if(await file.exists()){
        file.delete();
      }
    }
    catch(e){
      print("Delete cookie failed: ${e.toString()}");
      return false;
    }

    return true;
  }

  Future<String> loadCookie() async {
    try{
      final file = File("$_userDirectoryPath/cookie.txt");
      if(await file.exists()){
        return file.readAsString();
      }
    }
    catch(e){
      print("Load cookie failed: ${e.toString()}");
    }

    return "";
  }

  Future<bool> _checkPermission() async {
    if(!(await Permission.manageExternalStorage.isGranted)){
      await Permission.manageExternalStorage.request();
    }
    return await Permission.manageExternalStorage.isGranted;
  }
}