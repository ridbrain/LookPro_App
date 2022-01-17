import 'dart:async';

import 'package:flutter/material.dart';
import 'package:master/services/constants.dart';

class Shimmer extends StatefulWidget {
  Shimmer({
    this.width,
    required this.height,
    this.child,
  });

  final double? width;
  final double height;
  final Widget? child;

  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> {
  late Timer _timer;
  var _state = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _state = !_state;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: _state
            ? Colors.grey.withOpacity(0.1)
            : Colors.grey.withOpacity(0.2),
        borderRadius: Constants.radius,
      ),
      child: widget.child,
    );
  }
}
