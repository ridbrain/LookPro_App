import 'package:flutter/material.dart';

class StandartNavBar extends StatefulWidget {
  StandartNavBar({
    required this.buttons,
    required this.select,
  });

  final List<BottomNavigationBarItem> buttons;
  final Function select;

  @override
  _StandartNavBarState createState() => _StandartNavBarState();
}

class _StandartNavBarState extends State<StandartNavBar> {
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      iconSize: 25,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _selected,
      onTap: (index) {
        setState(() {
          _selected = index;
          widget.select(index);
        });
      },
      items: widget.buttons,
    );
  }
}
