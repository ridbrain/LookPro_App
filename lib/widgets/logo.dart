import 'package:flutter/material.dart';

class MasterLogo {
  static Widget white(double height) {
    return Image.asset(
      'assets/master_white.png',
      height: height,
    );
  }

  static Widget color(double height) {
    return Image.asset(
      'assets/master_color.png',
      height: height,
    );
  }
}
