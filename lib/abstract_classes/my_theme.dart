import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class MyTheme {

  static const background = Color(0xFFF2F3F8);

  static const green = Color(0xFF2ECC71);
  static const blue = Color(0xFF3498DB);
  static const yellow = Color(0xFFF1C40F);
  static const red = Color(0xFFE74C3C);
  static const lightGrey = Color(0xFFD0D3D4);

  void setSystemBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons).
      statusBarBrightness: Brightness.light, // For iOS (dark icons).
    ));
  }

  ThemeData getThemeData() {
    return ThemeData(
      splashColor: Colors.transparent,
      primarySwatch: Colors.green,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.black26,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )
          ),
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        shadowColor: Colors.black38,
      ),
    );
  }
}