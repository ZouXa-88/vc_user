import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:page_transition/page_transition.dart';

part 'package:user/pages/switch_page.dart';


class PageSwitcher {

  PageSwitcher._();

  static void pushPage({
    required BuildContext context,
    required Widget destinationPage,
    required String lottiePath,
    required String label,
    PageTransitionType fromAnimation = PageTransitionType.rightToLeft,
    PageTransitionType toAnimation = PageTransitionType.fade,
  }) {
    Navigator.of(context).push(
      PageTransition(
        child: SwitchPage(
          destinationPage: destinationPage,
          lottiePath: lottiePath,
          label: label,
          animation: toAnimation,
        ),
        type: fromAnimation,
      ),
    );
  }

  static void pushPageWithHero({
    required BuildContext context,
    required Widget destinationPage,
    required String lottiePath,
    required Hero heroLabel,
    PageTransitionType toAnimation = PageTransitionType.fade,
  }) {
    // TODO: Implement it.
  }
}