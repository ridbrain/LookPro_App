import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:master/pages/calendar.dart';
import 'package:master/pages/catalog.dart';
import 'package:master/pages/notifications.dart';
import 'package:master/pages/stat.dart';
import 'package:master/services/services.dart';
import 'package:master/widgets/nav_bar.dart';
import 'package:master/widgets/notification_icon.dart';

class HomeLite extends StatefulWidget {
  HomeLite({
    required this.masterUid,
    required this.entitlement,
  });

  final String masterUid;
  final Entitlement entitlement;

  @override
  _HomeLiteState createState() => _HomeLiteState();
}

class _HomeLiteState extends State<HomeLite> {
  var _index = 0;

  Widget _getPage() {
    final pages = [
      CalendarPage(
        masterUid: widget.masterUid,
      ),
      NotificationsPage(
        entitlement: widget.entitlement,
        masterUid: widget.masterUid,
      ),
      Catalog(),
    ];

    return pages[_index];
  }

  List<BottomNavigationBarItem> _buttons() {
    return [
      BottomNavigationBarItem(
        label: "Календарь",
        icon: const Icon(LineIcons.calendar),
        activeIcon: const Icon(LineIcons.calendar, color: Colors.black),
      ),
      BottomNavigationBarItem(
        label: "Уведомления",
        icon: NotificationIcon(
          masterUid: widget.masterUid,
          entitlement: widget.entitlement,
        ),
        activeIcon: const Icon(LineIcons.bell, color: Colors.black),
      ),
      BottomNavigationBarItem(
        label: "Настройки",
        icon: const Icon(LineIcons.bars),
        activeIcon: const Icon(LineIcons.bars, color: Colors.black),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _getPage(),
      bottomNavigationBar: StandartNavBar(
        buttons: _buttons(),
        select: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}

class HomeBase extends StatefulWidget {
  HomeBase({
    required this.masterUid,
    required this.entitlement,
  });

  final String masterUid;
  final Entitlement entitlement;

  @override
  _HomeBaseState createState() => _HomeBaseState();
}

class _HomeBaseState extends State<HomeBase> {
  var _index = 0;

  Widget _getPage() {
    final pages = [
      CalendarPage(
        masterUid: widget.masterUid,
      ),
      NotificationsPage(
        entitlement: widget.entitlement,
        masterUid: widget.masterUid,
      ),
      StatPage(),
      Catalog(),
    ];

    return pages[_index];
  }

  List<BottomNavigationBarItem> _buttons() {
    return [
      BottomNavigationBarItem(
        label: "Календарь",
        icon: Icon(LineIcons.calendar),
        activeIcon: Icon(LineIcons.calendar, color: Colors.black),
      ),
      BottomNavigationBarItem(
        label: "Уведомления",
        icon: NotificationIcon(
          masterUid: widget.masterUid,
          entitlement: widget.entitlement,
        ),
        activeIcon: Icon(LineIcons.bell, color: Colors.black),
      ),
      BottomNavigationBarItem(
        label: "Статистика",
        icon: const Icon(LineIcons.barChartAlt),
        activeIcon: const Icon(LineIcons.barChartAlt, color: Colors.black),
      ),
      BottomNavigationBarItem(
        label: "Настройки",
        icon: const Icon(LineIcons.bars),
        activeIcon: Icon(LineIcons.bars, color: Colors.black),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _getPage(),
      bottomNavigationBar: StandartNavBar(
        buttons: _buttons(),
        select: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
