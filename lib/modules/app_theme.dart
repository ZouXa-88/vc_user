import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AppTheme {

  static const background = Color(0xFFF2F3F8);

  static const green = Color(0xFF2ECC71);
  static const blue = Color(0xFF018DFF);
  static const brightCyan = Color(0xFF07E7C5);
  static const cyan = Color(0xFF26BDCF);
  static const yellow = Color(0xFFF1C40F);
  static const yellowOrange = Color(0xFFF39C12);
  static const orange = Color(0xFFE67E22);
  static const brightRed = Color(0xFFFF556F);
  static const red = Color(0xFFE74C3C);
  static const lightGrey = Color(0xFFD0D3D4);
  static const darkGrey = Color(0xFF7C92A9);

  static const veryLightGreen = Color(0xFFF5FBF5);
  static const veryLightOrange = Color(0xFFFBF9F5);


  AppTheme._();

  static void setSystemTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons).
      statusBarBrightness: Brightness.light, // For iOS (dark icons).
    ));
  }

  static InputDecoration getRoundedRectangleInputDecoration({
    required String labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.black26,
        ),
      ),
    );
  }

  static InputDecoration getEllipseInputDecoration({
    required String labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.black26,
        ),
      ),
    );
  }

  static ThemeData getThemeData() {
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