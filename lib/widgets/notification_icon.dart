import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_icon_badge/flutter_app_icon_badge.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/services/network.dart';
import 'package:master/services/services.dart';

class NotificationIcon extends StatefulWidget {
  NotificationIcon({
    required this.masterUid,
    required this.entitlement,
  });

  final String masterUid;
  final Entitlement entitlement;

  @override
  _NotificationIconState createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  late Timer _timer;
  var _show = false;

  void _update() async {
    var uid = widget.masterUid;
    var prefs = await PrefsHandler.getInstance();
    var count = 0;

    var server = await NetHandler.getLastNotificationId(uid);
    var local = prefs.getLastNotificationId();
    if (server > local) {
      count++;
    }

    var records = (await NetHandler.getRecords(uid, '0'))?.length ?? 0;
    if (records > 0) {
      count = count + records;
    }

    var prices = (await NetHandler.getPrices(uid))?.length ?? 0;
    if (prices == 0) {
      count++;
    }

    var places = (await NetHandler.getPlaces(uid))?.length ?? 0;
    if (places == 0) {
      count++;
    }

    if (_ckeckLink()) {
      var link = prefs.getShowLink();
      if (link) {
        count++;
      }
    }

    setState(() {
      _show = count > 0;
    });

    FlutterAppIconBadge.updateBadge(count);
  }

  bool _ckeckLink() {
    switch (widget.entitlement) {
      case Entitlement.none:
        return true;
      case Entitlement.lite:
        return false;
      case Entitlement.base:
        return false;
      case Entitlement.pro:
        return true;
      case Entitlement.max:
        return true;
      default:
        return true;
    }
  }

  Widget _getBadge() {
    if (_show) {
      return Positioned(
        top: 0.0,
        right: 0.0,
        child: Icon(
          Icons.brightness_1,
          size: 8.0,
          color: Colors.red,
        ),
      );
    }

    return SizedBox.shrink();
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((message) => _update());
    _timer = Timer.periodic(
      Duration(minutes: 1),
      (timer) => _update(),
    );
    _update();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(LineIcons.bell),
        _getBadge(),
      ],
    );
  }
}
