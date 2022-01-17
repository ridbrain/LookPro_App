import 'package:flutter/material.dart';
import 'package:master/widgets/bottom_sheet.dart';

class MainRouter {
  static Future<dynamic> nextPage(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }

  static Future<dynamic> fullScreenDialog(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return page;
        },
      ),
    );
  }

  static Future<dynamic> openBottomSheet({
    required BuildContext context,
    required Widget child,
    double? height,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StandartBottomSheet(
        child: child,
        height: height,
      ),
    );
  }

  static void changeMainPage(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
      (route) => false,
    );
  }
}
