import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/constants.dart';
import 'package:overlay_support/overlay_support.dart';

class StandartSnackBar {
  static void show(BuildContext context, String text, SnackBarStatus status) {
    showOverlayNotification(
      (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Constants.radius,
              boxShadow: Constants.shadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  Icon(
                    status.icon,
                    color: status.color,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      duration: Duration(milliseconds: 4000),
    );
  }
}

class SnackBarStatus {
  SnackBarStatus(
    this.icon,
    this.color,
  );

  final IconData icon;
  final Color color;

  static SnackBarStatus success() {
    return SnackBarStatus(
      LineIcons.checkCircle,
      Colors.green.shade800,
    );
  }

  static SnackBarStatus warning() {
    return SnackBarStatus(
      LineIcons.exclamationCircle,
      Colors.deepOrange.shade800,
    );
  }

  static SnackBarStatus message() {
    return SnackBarStatus(
      LineIcons.bell,
      Colors.yellow.shade800,
    );
  }
}

class MessageBottom extends StatelessWidget {
  MessageBottom({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(45, 0, 45, 40),
      alignment: Alignment.center,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
