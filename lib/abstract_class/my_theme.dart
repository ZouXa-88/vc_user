import 'package:flutter/material.dart';

abstract class MyTheme {

  ThemeData getThemeData() {
    return ThemeData(
      primarySwatch: Colors.green,
      splashColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        /*
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.green,
          */
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
                  letterSpacing: 5,
                  fontWeight: FontWeight.bold,
                )
            )
        ),
      ),
    );
  }
}