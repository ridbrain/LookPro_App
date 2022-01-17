import 'package:flutter/material.dart';
import 'package:master/services/constants.dart';
import 'package:master/widgets/convert_date.dart';

class WorkTime {
  WorkTime(
    this.time,
    this.free,
  );

  final int time;
  final bool free;
}

class TimeCell extends StatelessWidget {
  TimeCell({
    required this.date,
    required this.onSelect,
    required this.selected,
  });

  final WorkTime date;
  final bool selected;
  final Function() onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: Constants.radius,
      color: selected ? Colors.grey[800] : Colors.grey[100],
      child: InkWell(
        borderRadius: Constants.radius,
        onTap: onSelect,
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ConvertDate(context).fromUnix(date.time, "HH:mm"),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: selected
                      ? date.free
                          ? Colors.white
                          : Colors.orange
                      : date.free
                          ? Colors.black
                          : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
