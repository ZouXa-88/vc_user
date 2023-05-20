import 'package:flutter/material.dart';

import 'package:user/modules/app_theme.dart';

class SnackBarPresenter {

  SnackBarPresenter._();

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.darkGrey,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}